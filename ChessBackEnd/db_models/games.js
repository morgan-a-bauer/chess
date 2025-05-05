import GameParticipants from './game_participants.js';
import {Sequelize, DataTypes, Model, sequelize} from './sql_init.js';
import Users from './users.js';

class Games extends Model {
    /* can add methods to this */
}

Games.init(
    {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            allowNull: false,
            primaryKey: true,
        },
        is_active: {
            type: DataTypes.BOOLEAN,
            defaultValue: true
        },
    },
    {
        sequelize,
        timestamps: true,
        tableName: 'games',
    }
)
export default Games