import { WebSocketServer } from 'ws';
import {Sequelize, DataTypes, Model, sequelize, Op} from './db_models/sql_init.js';
import {Users, Games, GameParticipants, Moves} from "./db_models/model_init.js"
import GameQueue from './helpers.js/game_queue.js';
import verifyLogin from './db_queries/login_verification.js'
import select_username_by_id from './db_queries/select_username_by_id.js';
import get_game_history from './db_queries/get_game_history.js';
import { parse } from 'dotenv';

const queue = new GameQueue();
const clients = new Map();


async function queue_listener_handler() {
    while (true) {
        var match_valid = false
        const {player1, player2} = await queue.listen();
        console.log(player1, player2)
        if (clients.get(player1)?.readyState === WebSocket.OPEN) {
            match_valid = true;
        }
        else {
            console.log("match fucked due to websocket failure")
            clients.delete(player1);
            match_valid = false;
        }
        if (match_valid) {
            if (clients.get(player2)?.readyState === WebSocket.OPEN) {
                match_valid = true;
            }
            else {
                console.log("match fucked due to websocket failure")
                queue.add(player1)
                clients.delete(player2);
                match_valid = false;
            }
        } else {
            queue.add(player2)
        }
        if (match_valid) {
            console.log("match good so far")
            // Database game creation
            const game = await Games.create({});
            const game_participant1 = await GameParticipants.create({"game_id": game.dataValues.id, "user_id": player1, "is_white": true});
            const game_participant2 = await GameParticipants.create({"game_id": game.dataValues.id, "user_id": player2, "is_white": false});
            // Communication to clients
            const username1 = await select_username_by_id(player1);
            const username2 = await select_username_by_id(player2);
            clients.get(player1).send(JSON.stringify({"type": "success", "sub_type":"match_made", "data":`{"username": "${username2}", "game_id": ${game.dataValues.id}, "is_white": ${true}}`}));
            clients.get(player2).send(JSON.stringify({"type": "success", "sub_type":"match_made", "data":`{"username": "${username1}", "game_id": ${game.dataValues.id}, "is_white": ${false}}`}));
            console.log("match success")
        }
        else {
            ws.send(JSON.stringify({"type":"error", "sub_type":"queue_failed", "message": "Trying To Requeue You"}));
        }
    }
};

(async () => {
    queue_listener_handler()
    await sequelize.sync({ alter: true });

    wss.on ('connection', function connection(ws) {

        var is_authenticated = false;
        var game = null;
        var opponent = null;
        var user = null;
        var in_game = false;
        
        var user_id = null;
        var in_queue = false;
        var time_control = "";
        var game_history_pointer = 0;
        ws.on('error', console.error);

        ws.on('message', function message(data) {
            try {
                const parsedData = JSON.parse(data);
                console.log('Recevied', parsedData);
                (async () =>{
                    // Might need to check what create does and substitute it out...
                    // All ws.send should use the same formating that swift client sends to this server, parsable json.
                    console.log("authed?:", is_authenticated)
                    if (is_authenticated) {
                        // This is not the droid you are looking for

                        switch (parsedData.type) {
                            case "add_move": {
                                /*
                                {"type":"add_move", "game_id": 1, "turn": 1, "move":11033}
                                */
                               if (game.is_active) {
                                    clients.get(opponent.user_id).send(JSON.stringify({"type":"success", "sub_type":"move_received", "dataInt":parsedData.move}));
                                    ws.send(JSON.stringify({"type":"success", "sub_type":"move_sent", "message": "Move Sent Successfully"}));
                                    // moves needs to take a move as an integer not text...
                                    // await Moves.create({"game_id": game.id, "turn": parsedData.turn, "move": parsedData.move});
                                } else {
                                    ws.send(JSON.stringify({"type":"error", "sub_type":"game_not_active", "message": "There is no active game"}));
                                }
                                break;
                            }
                            case "join_game": {
                                /*
                                {"type":"join_game", "game_id": 1, "user_id": 1}
                                */
                                game = await Games.findOne({
                                    where: { id: parsedData.game_id }
                                  });
                                opponent = await GameParticipants.findOne({
                                    where: {
                                      game_id: parsedData.game_id,
                                      user_id: { [Op.ne]: parsedData.user_id } // Exclude the current user
                                    }
                                });
                                user = await GameParticipants.findOne({
                                    where: {
                                        game_id: parsedData.game_id,
                                        user_id: { [Op.eq]: parsedData.user_id } // Includes the current user
                                    }
                                });
                                clients.get(opponent.user_id).send(JSON.stringify({"type":"success", "sub_type":"opponent_joined_game", "message": "Your opponenet has connected"}));
                                ws.send(JSON.stringify({"type":"success", "sub_type":"user_joined_game", "message": "Joined Game"}));
                                in_game = true;
                                game_history_pointer = 0;

                                break;
                            }
                            case "end_game": {
                                // find game where id == game_id set is_active false
                                /* 
                                {"type":"end_game", "game_id": 1, "result": "win"}
                                
                                SQL Query for checking if code works:
                                SELECT U.*, P.* FROM users U INNER JOIN game_participants P ON U.id = P.user_id WHERE P.game_id = 1;
                                */
                                
                                game = await Games.findOne({
                                    where: { id: parsedData.game_id }
                                  });
                                if (game.is_active) {
                                    game.is_active = false;
                                    switch (parsedData.result) {
                                        case "win": {
                                            user.won_game = true;
                                            opponent.won_game = false;
                                            break;
                                        }
                                        case "lose": {
                                            user.won_game = false;
                                            opponent.won_game = true;
                                            break;
                                        }
                                        case "draw": {
                                            break;
                                        }
                                    };
                                    await game.save()
                                    await user.save()
                                    await opponent.save()
                                    ws.send(JSON.stringify({"type":"success", "sub_type":"game_ended", "message": "Game Result Recorded"}));
                                } else {
                                    ws.send(JSON.stringify({"type":"success", "sub_type":"game_ended", "message": "Game Result Already Recorded"}));
                                }
                                in_game = false;
                                break;
                            }
                            // case "get_username": {
                            //     /*
                            //     {"type":"get_username","user_id"}
                            //     */
                            //     ws.send(JSON.stringify({"type": "success","sub_type":"get_username","username": await select_username_by_id(parsedData.user_id), "user_id": parsedData.user_id}));
                            //     break;
                            // }
                            case "enter_game_queue": {
                                /*
                                {"type":"enter_game_queue","user_id": 1, "time_control":"15|10"}
                                */
                                if (!in_queue) {
                                    if (queue.add(parsedData.user_id, String(parsedData.time_control))) {
                                        ws.send(JSON.stringify({"type": "success", "sub_type": "entered_game_queue"}))
                                        in_queue = true;
                                        time_control = String(parsedData.time_control);
                                    } else {
                                        ws.send(JSON.stringify({"type": "error", "sub_type": "invalid_query", "message": "failed to join game queue"}))
                                    }

                                    
                                // Have fun with the game queue and listener to create game and game_participants was not actually bad :)
                                };
                                break;
                            }
                            case "leave_game_queue": {
                                // {"type":"leave_game_queue","user_id": 1, "time_control":"15|10"}
                                if (in_queue) {
                                    if (queue.leave(parsedData.user_id, String(parsedData.time_control))) {
                                        ws.send(JSON.stringify({"type": "success", "sub_type": "left_game_queue"}))
                                        in_queue = false;
                                    } else {
                                        ws.send(JSON.stringify({"type": "error", "sub_type": "invalid_query", "message": "failed to leave game queue"}))
                                    }
                                };
                                break;
                            }
                            case "get_game_history": {
                                // {"type":"get_game_history","user_id": 1}
                                const temp = await get_game_history(parsedData.user_id);
                                // console.log("get_game_history")
                                // console.log(temp)
                                ws.send(JSON.stringify({"type": "success", "sub_type": "game_history", "dataArray":temp}))
                                break;
                            }
                            default: {
                                ws.send(JSON.stringify({"type":"error", "sub_type": "invalid_query", "message":"ya done fucked it"}))
                            }
                        }
                    } else {
                        switch (parsedData.type) {
                            case "auth": {
                                /* 
                                {"type":"auth","username":"jackcameback","password":"foobar"}
                                */
                                // Need a more secure way of sending password...
                                const login = await verifyLogin(parsedData.username, parsedData.password)
                                switch (login) {
                                    case "invalid_username": {
                                        ws.send(JSON.stringify({"type": "error", "sub_type": "invalid_username", "message":"Username does not exist"}))
                                        break;
                                    }
                                    case "invalid_password": {
                                        ws.send(JSON.stringify({"type": "error", "sub_type": "invalid_password", "message":"Password is not correct"}))
                                        break;
                                    }
                                    default: {
                                        ws.send(JSON.stringify({"type": "success", "sub_type": "login_successful", "message":"Logged in", "data":JSON.stringify(login)}))
                                        // `{'user_id':${login.user_id}, 'icon':${login.icon}, 'milestones':${login.milestones}}`
                                        is_authenticated = true;
                                        user_id = login.user_id;
                                        clients.set(login, ws);
                                        // Check to see if user is still in a game.
                                        // Maybe keep connection alive for some amount of time before killing it? and load them back into game upon reconnect?
                                        break;
                                    }
                                }
                                break;
                            }
                            case "create_account": {
                                try{
                                    /* 
                                    {"type":"create_account", "username":"jackcameback","email":"jackson@butler.net", "first_name":"jackson", "last_name":"butler", "password":"foobar"}
                                    */ 
                                    
                                    await Users.create({ username: parsedData["username"], email: parsedData["email"], first_name: parsedData["first_name"], last_name: parsedData["last_name"], elo: parsedData["elo"],password: parsedData["password"] });
                                    ws.send(JSON.stringify({"type":"success", "sub_type":"created_user", "message": "User created successfully"}))
                                }catch {
                                    ws.send(JSON.stringify({"type":"error", "sub_type":"invalid_user", "message": "Username/Email is already in use"}))
                                }
                                break;
                            }
                            default: {
                                ws.send(JSON.stringify({"type":"error", "sub_type":"no_auth_user", "message": "Invalid query"}));
                            }
                        };
                    };
                    
                })()
            } catch {
                ws.send(JSON.stringify({"type":"error", "sub_type":"invalid_message", "message": `Message ${data} is invalid`}))
            };
        });

        ws.on('close', () => {
            console.log("connection closed to user:", user_id)
            if (in_queue) {
                console.log(queue.queue[time_control].length)
                queue.leave(user_id, time_control)
                console.log(queue.queue[time_control].length)
            }
            if (in_game) {
                // Figure out what this entails...
            }
        });
    });
})() ; // These call the async function... careful to not get rid of them

/*
Testing Only, migrations should be used in production
await sequelize.sync({ alter: true });
console.log('All models were synchronized successfully.');
*/

/*
check out refrence for foreign keys
https://sequelize.org/docs/v6/core-concepts/model-basics/
*/

try {
    sequelize.authenticate()
    .then(
    console.log('Connection has been established successfully.'));
} catch (error) {
    console.error('Unable to connect to the database:', error);
}

// app.listen(port, () => console.log(`Example app listening on port ${port}!`))


const wss = new WebSocketServer({port: process.env.PORT || 8080});
