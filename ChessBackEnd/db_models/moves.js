import {Sequelize, DataTypes, Model, sequelize} from './sql_init.js';
import Games from './games.js';

class Moves extends Model {
    /* can add methods to this */
}

Moves.init(
    {
        game_id : {
            type: DataTypes.INTEGER,
            primaryKey: true,
            allowNull: false,
            references: {
                model: Games,
                key: 'id',
            }
        },
        turn: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            allowNull: false,
        },
        move: {
            type: DataTypes.TEXT,
            allowNull: false,
        }
    },
    {
        sequelize,
        timestamps: false,
        tableName: 'moves',
    }
)

export default Moves