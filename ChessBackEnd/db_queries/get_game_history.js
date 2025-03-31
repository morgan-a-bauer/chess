import { Op, fn, col } from "sequelize";
import {Users, Games, GameParticipants, Moves} from "../db_models/model_init.js";

export default async function get_game_history(userId) {

    const games = await GameParticipants.findAll({
        where: {
            user_id: userId,
            
        },
        attributes: ['game_id'],

    });
    // console.log(games)
    const gameIds = games.map(item => item.dataValues.game_id);

    // console.log("GAME ID:",gameIds);

    if (gameIds.length > 0) {
        // Step 2: Find all GameParticipants in those games, excluding the original user
        const games = await Games.findAll({
            where: {
                id: gameIds,  // Find all participants in these games
            },

            attributes: ['id','is_active'],

            include: [
            {   model: GameParticipants,
                include: [{
                    model: Users,
                    attributes: ["username"]
                }]
            },
            {
                model: Moves,
                attributes: ["turn"], // We don't need the actual move data, just count them
            },
        ]
        });
    
        // console.log(games[0]);
        var returnGames = [];
        games.forEach(game => {
            var username;
            var opponentUsername;
            var userOutcome;
            var opponentOutcome;
            let moves = game.dataValues.Moves.length;
            // console.log(game.dataValues.GameParticipants[0].dataValues.user_id)
            if (game.dataValues.GameParticipants[0].dataValues.user_id == userId) {
                // console.log(game.dataValues.GameParticipants[0].dataValues.User)
                username = game.dataValues.GameParticipants[0].dataValues.User.dataValues.username;
                
                opponentUsername = game.dataValues.GameParticipants[1].dataValues.User.dataValues.username;
                if (!game.dataValues.GameParticipants[0].dataValues.won_game && !game.dataValues.GameParticipants[1].dataValues.won_game) {
                    userOutcome = "draw";
                    opponentOutcome = "draw";
                } else {
                    userOutcome = game.dataValues.GameParticipants[0].dataValues.won_game ? "won" : "lost";
                    opponentOutcome = game.dataValues.GameParticipants[1].dataValues.won_game ? "won" : "lost";
                }
            } else {
                username = game.dataValues.GameParticipants[1].dataValues.User.dataValues.username;
                opponentUsername = game.dataValues.GameParticipants[0].dataValues.User.dataValues.username;
                if (!game.dataValues.GameParticipants[0].dataValues.won_game && !game.dataValues.GameParticipants[1].dataValues.won_game) {
                    userOutcome = "draw";
                    opponentOutcome = "draw";
                } else {
                    userOutcome = game.dataValues.GameParticipants[1].dataValues.won_game ? "won" : "lost";
                    opponentOutcome = game.dataValues.GameParticipants[0].dataValues.won_game ? "won" : "lost";
                }
            }
            returnGames.push(`{"user": {"username": "${username}","outcome": "${userOutcome}"},"opponent": {"username":"${opponentUsername}","outcome": "${opponentOutcome}"},"moves": ${moves}}`)
        });
        return returnGames;

    } else {
        return []
    }
  }