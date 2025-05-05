import {Sequelize, DataTypes, Model, sequelize} from './sql_init.js';
import Users from './users.js';

class Milestones extends Model {
    /* can add methods to this */
}

Milestones.init(
    {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            allowNull: false,
            primaryKey: true,
        },
        user_id : {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: Users,
                key: 'id',
            },
            onDelete: 'CASCADE',
        },
        title: {
            type: DataTypes.TEXT,
            allowNull: false,
        },
        is_complete: {
            type: DataTypes.BOOLEAN,
            allowNull: false,
        }
    },
    {
        sequelize,
        timestamps: false,
        tableName: 'milestones',
    }
)

export default Milestones