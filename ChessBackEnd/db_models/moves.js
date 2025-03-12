import {Sequelize, DataTypes, Model, sequelize} from './sql_init.js';
import Games from './games.js';

class Moves extends Model {
    /* can add methods to this */
}

Moves.init(
    {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            allowNull: false,
            primaryKey: true,
        },
        game_id : {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: Games,
                key: 'id',
            },
            onDelete: 'CASCADE',
        },
        turn: {
            type: DataTypes.INTEGER,
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