const express = require('express')
const bodyParser = require('body-parser')
const {Sequelize, DataTypes, Model} = require('sequelize')
const sequelize = new Sequelize('postgres://jacksonbutler:Eden3299@localhost/persistentChess', {
    define: {
        freezeTableName: true,
    },
});


class User extends Model {

    /* can add methods to this */
}

User.init(
    'User',
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
        first_name: {
            type: DataTypes.STRING(50),
            allowNull: false,
        },
        last_name: {
            type: DataTypes.STRING(50),
            allowNull: false,
        },
    },
    {
        sequelize,
        timestamps: true,
        tableName: 'Users',
    }
)

const Jackson = await User.create({ username: 'Jackcameback', first_name: 'Jackson', last_name: 'Butler' });
// Jackson exists in the database now!
console.log(Jackson instanceof User); // true
console.log(jackcameback.name); // "Jackcameback"

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