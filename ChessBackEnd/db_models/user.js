import {Sequelize, DataTypes, Model, sequelize} from './sql_init.js';

class User extends Model {
    getUsername() {
        return this.username
    }
    /* can add methods to this */
};

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
        

    },
);

export default User