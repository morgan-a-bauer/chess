//
//  game_history_struct.swift
//  ChessApp
//
//  Created by Jackson Butler on 3/30/25.
//

struct UserHistory: Codable {
    let username: String;
    let outcome: String
    let is_white: Bool
    let time_left: String
    
    init(username: String="Doctor", outcome: String="win", is_white: Bool=true, time_left: String="00:00") {
        self.username = username
        self.outcome = outcome
        self.is_white = is_white
        self.time_left = time_left
    }
}

struct GameHistoryData: Codable {
    let moves: String;
    let termination: String;
    let result: String;
    let is_rated: Bool;
    let time_control: String;
    
    init(moves: String="", termination:String="Null", result:String="0-0", time_control:String="15|10", is_rated:Bool=false) {
        self.moves = moves
        self.termination = termination
        self.time_control = time_control
        self.result = result
        self.is_rated = is_rated
    }
}

struct GameHistory: Codable {
    let user: UserHistory;
    let opponent: UserHistory;
    let game: GameHistoryData;
    
    init(user: UserHistory=UserHistory(), opponent: UserHistory=UserHistory(), game: GameHistoryData=GameHistoryData()) {
        self.user = user
        self.opponent = opponent
        self.game = game
    }
}
