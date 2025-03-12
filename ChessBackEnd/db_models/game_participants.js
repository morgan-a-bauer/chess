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
            onDelete: 'CASCADE',
            allowNull: false,
        },
        user_id : {
            type: DataTypes.INTEGER,
            primaryKey: true,
            references: {
                model: Users,
                key: 'id',
            },
            onDelete: 'CASCADE',
            allowNull: false,
        },
        is_white: {
            type: DataTypes.BOOLEAN,
            allowNull: false,
        },
        won_game: {
            type: DataTypes.BOOLEAN,
        }
    },
    {
        sequelize,
        timestamps: false,
        tableName: 'game_participants',
    }
)

export default GameParticipants