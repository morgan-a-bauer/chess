const express = require('express')
const bodyParser = require('body-parser')
const {Sequelize, DataTypes, Model} = require('sequelize')
const sequelize = new Sequelize('postgres://jacksonbutler:Eden3299@localhost/persistentChess');


class User extends Model {

    /* can add methods to this */
}

User.init(
    {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            allowNull: false,
            primaryKey: true,
            
        },
        username: {
            type: DataTypes.STRING(50),
            allowNull: false,
        },
        firstName: {
            type: DataTypes.STRING(50),
            allowNull: false,
        },
        lastName: {
            type: DataTypes.STRING(50),
            allowNull: false,
        },
    },
    {
        sequelize,

    },
);
async function userMake(username, first_name, last_name) {
    return await User.create({ username: username, firstName: first_name, lastName: last_name });
}
const Jackson = userMake('Jackcameback', 'Jackson', 'Butler')
// Jackson exists in the database now!
console.log(Jackson instanceof User); // true
console.log(Jackson.username); // "Jackcameback"

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
const app = express();
const port = 3000;

app.use(express.json());

app.get('/', (req, res) => res.json({ message: 'Hello World' }));

try {
    sequelize.authenticate()
    .then(
    console.log('Connection has been established successfully.'));
} catch (error) {
    console.error('Unable to connect to the database:', error);
}

app.listen(port, () => console.log(`Example app listening on port ${port}!`))


