//
//  response_message.swift
//  ChessApp
//
//  Created by Jackson Butler on 3/18/25.
//
enum ResponseType: String, Codable {
    case success
    case error
}

enum ResponseSubType: String, Codable {
    case move_sent = "move_sent"
    case move_received = "move_received"
    case game_not_active = "game_not_active"
    case joined_game = "joined_game"
    case game_ended = "game_ended"
    case user_joined_game = "user_joined_game"
    case opponent_joined_game = "opponent_joined_game"
    case entered_game_queue = "entered_game_queue"
    case left_game_queue = "left_game_queue"
    case invalid_query = "invalid_query"
    case login_successful = "login_successful"
    case invalid_username = "invalid_username"
    case invalid_password = "invalid_password"
    case created_user = "created_user"
    case invalid_user = "invalid_user"
    case no_auth_user = "no_auth_user"
    case invalid_message = "invalid_message"
    case match_made = "match_made"
    case queue_failed = "queue_failed"
    case unknown = "unknown"
}
//
struct MoveData: Codable {
    let move: String;
}
struct GameData: Codable {
    let game_id: Int;
    let username: String;
    let is_white: Bool;
}
struct UserData: Codable {
    let user_id: Int;
}

struct ResponseMessage: Codable {
    let type: ResponseType;
    let sub_type: ResponseSubType;
    let message: String?;
    let data: String?;
    
}
