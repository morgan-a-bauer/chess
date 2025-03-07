import {Sequelize, DataTypes, Model, sequelize} from './sql_init.js';

class Users extends Model {
    /* can add methods to this */
};

/*
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    password TEXT NOT NULL,
);
*/

Users.init(
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
            unique: true,
            get() {
                const rawValue = this.getDataValue('username');
                return rawValue ? rawValue : null;
              },
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
        modelName: 'users'
    },
);

export default User