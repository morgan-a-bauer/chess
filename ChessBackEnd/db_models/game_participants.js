import {Sequelize, DataTypes, Model, sequelize} from './sql_init.js';
import Users from './users.js';
import Games from './games.js';

class GameParticipants extends Model {
    /* can add methods to this */
}

GameParticipants.init(
    {
        game_id : {
            type: DataTypes.INTEGER,
            primaryKey: true,
            references: {
                model: Games,
                key: 'id',
            },
            allowNull: false,
        },
        user_id : {
            type: DataTypes.INTEGER,
            primaryKey: true,
            references: {
                model: Users,
                key: 'id',
            },
            allowNull: false,
        },
        is_white: {
            type: DataTypes.BOOLEAN,
            allowNull: false,
        },
    },
    {
        sequelize,
        timestamps: false,
        tableName: 'game_participants',
    }
)

export default GameParticipants