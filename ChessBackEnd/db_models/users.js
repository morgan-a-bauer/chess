import {Sequelize, DataTypes, Model, sequelize} from './sql_init.js';


class Users extends Model {
    /* can add methods to this */
}

Users.init(
    {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            allowNull: false,
            primaryKey: true,
        },
        username: {
            type: DataTypes.TEXT,
            unique: true,
            allowNull: false,
        },
        email: {
            type: DataTypes.TEXT,
            unqie: true,
            allowNull: false,
        },
        first_name: {
            type: DataTypes.TEXT,
            allowNull: false,
        },
        last_name: {
            type: DataTypes.TEXT,
            allowNull: false,
        },
        password: {
            type: DataTypes.TEXT,
            set(value) {
                // Storing passwords in plaintext in the database is terrible.
                // Hashing the value with an appropriate cryptographic hash function is better.
                // Using the username as a salt is better.
                this.setDataValue('password', hash(this.username + value));
            },
            allowNull: false,
        },
    },
    {
        sequelize,
        timestamps: true,
        tableName: 'users',
    }
)

export default Users