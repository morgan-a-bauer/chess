// Written by: Jackson Butler

import { Op, fn, col } from "sequelize";
import {Users, Games, GameParticipants} from "../db_models/model_init.js";

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

            attributes: ['id','termination', 'result', 'is_rated', 'time_control', 'moves', 'move_count'],

            include: [
            {   model: GameParticipants,
                attributes: ['is_white', 'time_left', 'won_game'],
                include: [{
                    model: Users,
                    attributes: ['username']
                }]
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
            let moves = game.dataValues.moves;
            var userIsWhite;
            var opponentIsWhite; 
            var userTimeLeft; 
            var opponentTimeLeft;
            
            // console.log(game.dataValues.GameParticipants[0].dataValues.user_id)
            if (game.dataValues.GameParticipants[0].dataValues.user_id == userId) {
                // console.log(game.dataValues.GameParticipants[0].dataValues.User)
                username = game.dataValues.GameParticipants[0].dataValues.User.dataValues.username;
                userIsWhite = game.dataValues.GameParticipants[0].dataValues.User.dataValues.is_white;
                userTimeLeft = game.dataValues.GameParticipants[0].dataValues.User.dataValues.time_left;

                opponentUsername = game.dataValues.GameParticipants[1].dataValues.User.dataValues.username;
                opponentIsWhite = game.dataValues.GameParticipants[1].dataValues.User.dataValues.is_white;
                opponentTimeLeft = game.dataValues.GameParticipants[1].dataValues.User.dataValues.time_left;

                if (!game.dataValues.GameParticipants[0].dataValues.won_game && !game.dataValues.GameParticipants[1].dataValues.won_game) {
                    userOutcome = "draw";
                    opponentOutcome = "draw";
                } else {
                    userOutcome = game.dataValues.GameParticipants[0].dataValues.won_game ? "won" : "lost";
                    opponentOutcome = game.dataValues.GameParticipants[1].dataValues.won_game ? "won" : "lost";
                }
            } else {
                username = game.dataValues.GameParticipants[1].dataValues.User.dataValues.username;
                userIsWhite = game.dataValues.GameParticipants[1].dataValues.is_white;
                userTimeLeft = game.dataValues.GameParticipants[1].dataValues.time_left;

                opponentUsername = game.dataValues.GameParticipants[0].dataValues.User.dataValues.username;
                opponentIsWhite = game.dataValues.GameParticipants[0].dataValues.is_white;
                opponentTimeLeft = game.dataValues.GameParticipants[0].dataValues.time_left;

                if (!game.dataValues.GameParticipants[0].dataValues.won_game && !game.dataValues.GameParticipants[1].dataValues.won_game) {
                    userOutcome = "draw";
                    opponentOutcome = "draw";
                } else {
                    userOutcome = game.dataValues.GameParticipants[1].dataValues.won_game ? "won" : "lost";
                    opponentOutcome = game.dataValues.GameParticipants[0].dataValues.won_game ? "won" : "lost";
                }
            }
            returnGames.push(`{"user": {"username": "${username}","outcome": "${userOutcome}", "is_white": ${userIsWhite}, "time_left": "${userTimeLeft}"},"opponent": {"username": "${opponentUsername}", "outcome": "${opponentOutcome}", "is_white": ${opponentIsWhite}, "time_left": "${opponentTimeLeft}"},"game": {"moves": "${moves}", "termination": "${game.dataValues.termination}", "result": "${game.dataValues.result}", "is_rated": ${game.dataValues.is_rated}, "time_control": "${game.dataValues.time_control}"}}`)
        });
        console.log(returnGames)
        return returnGames;

    } else {
        return [`{"user": {"username": "Doctor", "outcome": "lost", "is_white": true, "time_left": "00:00"}, "opponent": {"username": "Who", "outcome": "lost", "is_white": false, "time_left": "00:00"}, "game": {"moves": "", "termination": "unplayed", "result": "0-0", "is_rated": false, "time_control": "0|0"}}`];    }
  }