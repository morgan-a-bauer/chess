import { WebSocketServer } from 'ws';
import bodyParser from 'body-parser';
import {Sequelize, DataTypes, Model, sequelize, Op} from './db_models/sql_init.js';

import User from './db_models/user.js'



(async () => {
    console.log("good?")
    await sequelize.sync({ alter: true });


    wss.on ('connection', function connection(ws) {

        // Set a heartbeat mechanism
        ws.isAlive = true;

        // Handle pong responses
        ws.on('pong', () => {
            ws.isAlive = true;
        });

        ws.on('error', console.error);

        ws.on('message', function message(data) {
            const parsedData = JSON.parse(data);
            console.log('Recevied', parsedData);
            // Parse message here
            // Decide on format for message
            // Unique game_id, username, move_occured?, 
            // move_occured needs to be something capable of being saved in backend here
                // as well as something which can be decoded by 
            // ws.send('%s,%s,%s',game_id,username,move);

            // Save to backend here asynced as to not delay message to other user
            // OR get info from backend... These queries should be divied up in different files
            (async () => {const data = await User.findAll({
                attributes:['firstName', 'lastName'],
                where: {
                    username: {
                        [Op.eq]: parsedData.username,
                    },
                },
            })
            console.log(data[0])

            ws.send(JSON.stringify({"firstName": data[0].dataValues["firstName"], "lastName":data[0].dataValues["lastName"]}));
            })();

        });
        
        
    });
    
    // const Jackson = await User.create({ username: 'Androodle', firstName: 'Andrew', lastName: 'Veach' });

    // // Jackson exists in the database now!
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
