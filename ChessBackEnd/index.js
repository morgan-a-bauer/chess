import { WebSocketServer } from 'ws';
import bodyParser from 'body-parser';
import {Sequelize, DataTypes, Model, sequelize, Op} from './db_models/sql_init.js';

import Users from './db_models/users.js'
import Games from './db_models/games.js'
import GameParticipants from './db_models/game_participants.js'
import Moves from './db_models/moves.js'
import GameQueue from './helpers.js/game_queue.js';
import verifyLogin from './db_queries/login_verification.js'
import select_username_by_id from './db_queries/select_username_by_id.js';
import { parse } from 'dotenv';

const queue = new GameQueue();
const clients = new Map();

async function queue_listener_handler() {
    while (true) {
        var match_valid = false
        const {player1, player2} = await queue.listen();
        if (clients.get(player1)?.readyState === WebSocket.OPEN) {
            match_valid = true;
        }
        else {
            clients.delete(player1);
            match_valid = false;
        }
        if (match_valid) {
            if (clients.get(player2)?.readyState === WebSocket.OPEN) {
                match_valid = true;
            }
            else {
                queue.add(player1)
                clients.delete(player2);
                match_valid = false;
            }
        } else {
            queue.add(player2)
        }
        if (match_valid) {
            // Database game creation
            const game = await Games.create({});
            const game_participant1 = await GameParticipants.create({"game_id": game.dataValues.id, "user_id": player1, "is_white": true});
            const game_participant2 = await GameParticipants.create({"game_id": game.dataValues.id, "user_id": player2, "is_white": false});

            // Communication to clients
            const username1 = await select_username_by_id(player1);
            const username2 = await select_username_by_id(player2);
            clients.get(player1).send(JSON.stringify({"type": "success", "sub_type":"match_made", "data":`{"username": "${username2}", "game_id": ${game.dataValues.id}, "is_white": ${true}}`}));
            clients.get(player2).send(JSON.stringify({"type": "success", "sub_type":"match_made", "data":`{"username": "${username1}", "game_id": ${game.dataValues.id}, "is_white": ${false}}`}));
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
                                {"type":"add_move", "game_id": 1, "turn": 1, "move":"e2e4"}
                                */
                               if (game.is_active) {
                                    clients.get(opponent.user_id).send(JSON.stringify({"type":"success", "sub_type":"move_received", "data":parsedData.move}));
                                    ws.send(JSON.stringify({"type":"success", "sub_type":"move_sent", "message": "Move Sent Successfully"}));
                                    await Moves.create({"game_id": game.id, "turn": parsedData.turn, "move": parsedData.move});
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
                                {"type":"enter_game_queue","user_id": 1}
                                */
                                queue.add(parsedData.user_id);
                                ws.send(JSON.stringify({"type": "success", "sub_type": "entered_game_queue"}))
                                // Have fun with the game queue and listener to create game and game_participants was not actually bad :)
                                break;
                            }
                            case "leave_game_queue": {
                                queue.leave(parsedData.user_id);
                                ws.send(JSON.stringify({"type": "success", "sub_type": "left_game_queue"}))
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
                                    }
                                    case "invalid_password": {
                                        ws.send(JSON.stringify({"type": "error", "sub_type": "invalid_password", "message":"Password is not correct"}))
                                    }
                                    default: {
                                        ws.send(JSON.stringify({"type": "success", "sub_type": "login_successful", "message":"Logged in", "data":`{"user_id":${login}}`}))
                                        is_authenticated = true;
                                        clients.set(login, ws);
                                    }
                                }
                                break;
                            }
                            case "create_user": {
                                try{
                                    /* 
                                    {"type":"create_user", "username":"jackcameback","email":"jackson@butler.net", "first_name":"jackson", "last_name":"butler", "password":"foobar"}
                                    */
                                    await Users.create({ username: parsedData["username"], email: parsedData["email"], first_name: parsedData["first_name"], last_name: parsedData["last_name"], password: parsedData["password"] });
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


    });

    // create user
    // const Jackson = await Users.create({ username: 'jackcameback', email: 'jackson@butler.net', first_name: 'Jackson', last_name: 'Butler', password: 'foobar' });
    // create game
    // const game1 = await Games.create({});
    // create game_participant
    // const game_participant = await GameParticipants.create({"game_id": 1, "user_id": 1, "is_white": true});
    // create move
    // const move = await Moves.create({"game_id": 1, "turn": 1, "move": "e2e4"})

    // // // Jackson exists in the database now!
    // console.log(Jackson instanceof User); // true
    // console.log(Jackson.username); // "Jackcameback"
    // Code here

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
