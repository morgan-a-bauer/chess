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
            allowNull: false,
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


// Users and GameParticipants
Users.hasMany(GameParticipants, { foreignKey: "user_id" });
GameParticipants.belongsTo(Users, { foreignKey: "user_id" });

// Users and Games (many-to-many via GameParticipants)
// Users.belongsToMany(Games, { through: GameParticipants, foreignKey: "user_id" });
// Games.belongsToMany(Users, { through: GameParticipants, foreignKey: "game_id"});

// Games and GameParticipants
Games.hasMany(GameParticipants, { foreignKey: "game_id" });
GameParticipants.belongsTo(Games, { foreignKey: "game_id" });

// Games and Moves (one-to-many)
Games.hasMany(Moves, { foreignKey: "game_id" });
Moves.belongsTo(Games, { foreignKey: "game_id" });

export {Users, Games, GameParticipants, Moves}