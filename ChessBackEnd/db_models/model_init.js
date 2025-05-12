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
        password: {
            type: DataTypes.TEXT,
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
        elo : {
            type: DataTypes.INTEGER,
            allowNull: false,
            defaultValue: 600,
        },
        icon : {
            type: Sequelize.BLOB('long'),
            allowNull: true,
        },
    },
    {
        sequelize,
        timestamps: true,
        tableName: 'users',
    }
)

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
        result: {
            type: DataTypes.TEXT,
            allowNull: false,
            defaultValue: '0-0', // 0-0, 1-0, 0-1, 1/2-1/2
        },
        termination: {
            type: DataTypes.TEXT,
            allowNull: false,
            defaultValue: 'active',
        },
        is_rated: {
            type: DataTypes.BOOLEAN,
            allowNull: false,
            defaultValue: true,
        },
        time_control: {
            type: DataTypes.TEXT, // 30|5
            allowNull: false,
            defaultVale: "15|10"
        },
        moves: {
            type: DataTypes.TEXT,
            allowNull: false,
            defaultValue: '',
        },
        move_count: {
            type: DataTypes.TEXT,
            allowNull: false,
            defaultValue: 0,
        }
    },
    {
        sequelize,
        timestamps: true,
        tableName: 'games',
    }
)

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
        },
        time_left: {
            type: DataTypes.STRING,
            allowNull: false,
            defaultValue: "00:00"
        },
    },
    {
        sequelize,
        timestamps: false,
        tableName: 'game_participants',
    }
)

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

// Users and GameParticipants
Users.hasMany(GameParticipants, { foreignKey: "user_id" });
Users.hasMany(Milestones, {foreignKey: "user_id"})
GameParticipants.belongsTo(Users, { foreignKey: "user_id" });

// Users and Games (many-to-many via GameParticipants)
// Users.belongsToMany(Games, { through: GameParticipants, foreignKey: "user_id" });
// Games.belongsToMany(Users, { through: GameParticipants, foreignKey: "game_id"});

// Games and GameParticipants
Games.hasMany(GameParticipants, { foreignKey: "game_id" });
GameParticipants.belongsTo(Games, { foreignKey: "game_id" });

await sequelize.sync({ alter: true });

// Games and Moves (one-to-many)
// Games.hasMany(Moves, { foreignKey: "game_id" });

export {Users, Games, GameParticipants, Milestones}