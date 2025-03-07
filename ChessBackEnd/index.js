import { WebSocketServer } from 'ws';
import bodyParser from 'body-parser';
import {Sequelize, DataTypes, Model, sequelize, Op} from './db_models/sql_init.js';

import Users from './db_models/users.js'
import Games from './db_models/games.js'
import GameParticipants from './db_models/game_participants.js'
import Moves from './db_models/moves.js'



(async () => {
    console.log("good?")
    await sequelize.sync({ alter: true });


    wss.on ('connection', function connection(ws) {



        ws.on('error', console.error);

        ws.on('message', function message(data) {
            const parsedData = JSON.parse(data);
            console.log('Recevied', parsedData);
            (async () =>{
                // Might need to check what create does and substitute it out...
                switch (parsedData["command"]) {
                    case "add_user": {
                        await Users.create({ username: parsedData["username"], email: parsedData["email"], first_name: parsedData["first_name"], last_name: parsedData["last_name"], password: parsedData["password"] });
                        break;
                    }
                    case "enter_game_queue": {
                        // Have fun with the game queue and listener to create game and game_participants
                        break;
                    }
                    case "add_move": {
                        const turn = "foo" // turn might be able to be auto incremented every two with move with same game_id...
                        const move = await Moves.create({"game_id": parsedData["game_id"], "turn": turn, "move": parsedData["move"]})
                    }
                    default: {
                        ws.send("ya done fucked it")
                    }
                }
            })()
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
            if (parsed)
            (async () => {const data = await Users.findAll({
                attributes:['first_name', 'last_name'],
                where: {
                    username: {
                        [Op.eq]: parsedData.username,
                    },
                },
            })
            console.log(data[0])

            ws.send(JSON.stringify({"first_name": data[0].dataValues["first_name"], "last_name":data[0].dataValues["last_name"]}));
            })();

        });
        
        
    });
    
    // create user
    // const Jackson = await Users.create({ username: 'Jackcameback', email: 'jackson@butler.net', first_name: 'Jackson', last_name: 'Butler', password: 'foobar' });
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
