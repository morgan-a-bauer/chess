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
            const message = JSON.stringify({"game_id": game.dataValues.id, "user1": {"username": username1, "user_id": player1}, "user2":{"username": username2, "user_id": player2}})
            clients.get(player1).send(message);
            clients.get(player2).send(message);
        }
        else {
            console.log("Invalid Match");
        }
        
    }
};

(async () => {
    queue_listener_handler()
    await sequelize.sync({ alter: true });

    wss.on ('connection', function connection(ws) {

        var is_authenticated = false;
        var game_id = null
        ws.on('error', console.error);

        ws.on('message', function message(data) {
            try {
                const parsedData = JSON.parse(data);
                console.log('Recevied', parsedData);
                (async () =>{
                    // Might need to check what create does and substitute it out...
                    // All ws.send should use the same formating that swift client sends to this server, parsable json.
                    if (is_authenticated) {
                        // You are not the droids we are looking for

                        switch (parsedData["type"]) {
                            case "add_move": {
                                const move = await Moves.create({"game_id": parsedData.game_id, "turn": parsedData.turn, "move": parsedData.move});
                                break;
                            }
                            case "start_game": {
                                game_id = parsedData.game_id;
                                break
                            }
                            case "end_game": {
                                // find game where id == game_id set is_active false
                                break;
                            }
                            case "add_user": {
                                await Users.create({ username: parsedData["username"], email: parsedData["email"], first_name: parsedData["first_name"], last_name: parsedData["last_name"], password: parsedData["password"] });
                                break;
                            }
                            case "get_username": {
                                ws.send(JSON.stringify({"username": await select_username_by_id(parsedData.user_id), "user_id": parsedData.user_id}));
                                break;
                            }
                            case "enter_game_queue": {
                                console.log("enteredGamequeue")
                                queue.add(parsedData["user_id"]);
                                // Have fun with the game queue and listener to create game and game_participants
                                break;
                            }
                            case "leave_game_queue": {
                                queue.leave(parsedData["user_id"]);
                                break;
                            }

                            default: {
                                ws.send("ya done fucked it")
                            }
                        }
                    } else {
                        if (!is_authenticated && (parsedData["type"] == "auth")){
                            // Need a more secure way of sending password...
                            const login = await verifyLogin(parsedData["username"], parsedData["password"])
                            if (login === "Invalid Login" || login === "User not found") {
                                ws.send(login); // Send "Invalid Login" or "User not found" message
                                
                            } else {
                                is_authenticated = true;
                                clients.set(login, ws);
                                console.log(login); // login now holds the user id (or other value from verifyLogin)
                                ws.send(String(login)); // Send the user ID or whatever is returned from verifyLogin
                            }
                        }
                        else {
                            ws.send("Unauthenticated User")
                        }
                    };
                    
                })()
            } catch {
                ws.send("Invalid Message")
            }
            
            // Parse message here
            // Decide on format for message
            // Unique game_id, username, move_occured?,
            // move_occured needs to be something capable of being saved in backend here
                // as well as something which can be decoded by
            // ws.send('%s,%s,%s',game_id,username,move);


            /*
            New User
            {command:str, username:str, email:str, first_name:str, last_name:str, password:str}
            Delete User

            Game Start

            Game End

            Move Occured

            */

            // Save to backend here asynced as to not delay message to other user
            // OR get info from backend... These queries should be divied up in different files
            // (async () => {const data = await Users.findAll({
            //     attributes:['first_name', 'last_name'],
            //     where: {
            //         username: {
            //             [Op.eq]: parsedData.username,
            //         },
            //     },
            // })
            // console.log(data[0])

            // ws.send(JSON.stringify({"first_name": data[0].dataValues["first_name"], "last_name":data[0].dataValues["last_name"]}));
            // })();

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

// API ROUTING FUNCTIONALITY?


// app.get('/', (req, res) => res.json({ message: 'Hello World' }));

try {
    sequelize.authenticate()
    .then(
    console.log('Connection has been established successfully.'));
} catch (error) {
    console.error('Unable to connect to the database:', error);
}

// app.listen(port, () => console.log(`Example app listening on port ${port}!`))


const wss = new WebSocketServer({port: process.env.PORT || 8080});
