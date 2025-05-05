//
//  game_history_struct.swift
//  ChessApp
//
//  Created by Jackson Butler on 3/30/25.
//

struct UserHistory: Codable {
    let username: String;
    let outcome: String
    
    init(username: String="Doctor", outcome: String="win") {
        self.username = username
        self.outcome = outcome
    }
}

struct GameHistory: Codable {
    let user: UserHistory;
    let opponent: UserHistory;
    let moves: Int;
    let moveHistory: [Move];
    
    init(user: UserHistory=UserHistory(), opponent: UserHistory=UserHistory(), moves: Int=0) {
        self.user = user
        self.opponent = opponent
        self.moves = moves
    }
}

struct GameHistoryList: Codable {
    let games: [GameHistory];
    
    init(games: [GameHistory] = []) {
        self.games = games
    }
}


//username: String="Doctor", userOutcome: String="lose", opponent: String="Cyber Controller", opponentOutcome: String="win", moves: Int=12
