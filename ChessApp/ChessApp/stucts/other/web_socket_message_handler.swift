//
//  web_socket_message_handler.swift
//  ChessApp
//
//  Created by Jackson Butler on 3/18/25.
//

import Foundation


extension WebSocketManager {
    typealias Handler = (ResponseMessage) -> HandlerResponse
    
    
    
    func registerHandlers() {
        handlers["move_received"] = handleMoveReceived
        handlers["move_sent"] = handleMoveSent
        handlers["game_ended"] = handleGameEnded
        handlers["user_joined_game"] = handleUserJoinedGame
        handlers["opponent_joined_game"] = handleOpponentJoinedGame
        handlers["entered_game_queue"] = handleEnteredGameQueue
        handlers["left_game_queue"] = handleLeftGameQueue
        handlers["invalid_query"] = handleInvalidQuery
        handlers["login_successful"] = handleLoginSuccessful
        handlers["invalid_username"] = handleInvalidUsername
        handlers["invalid_password"] = handleInvalidPassword
        handlers["created_user"] = handleCreatedUser
        handlers["invalid_user"] = handleInvalidUser
        handlers["no_auth_user"] = handleNoAuthUser
        handlers["game_not_active"] = handleGameNotActive
        handlers["invalid_message"] = handleInvalidMessage
        handlers["match_made"] = handleMatchMade
        handlers["queue_failed"] = handleQueueFailed
        
//        handlers[ResponseSubType.move_received.rawValue] = handleMoveReceived
//        handlers[ResponseSubType.move_sent.rawValue] = handleMoveSent
//        handlers[ResponseSubType.game_ended.rawValue] = handleGameEnded
//        handlers[ResponseSubType.user_joined_game.rawValue] = handleUserJoinedGame
//        handlers[ResponseSubType.opponent_joined_game.rawValue] = handleOpponentJoinedGame
//        handlers[ResponseSubType.enter_game_queue.rawValue] = handleEnterGameQueue
//        handlers[ResponseSubType.left_game_queue.rawValue] = handleLeftGameQueue
//        handlers[ResponseSubType.invalid_query.rawValue] = handleInvalidQuery
//        handlers[ResponseSubType.login_successful.rawValue] = handleLoginSuccessful
//        handlers[ResponseSubType.invalid_username.rawValue] = handleInvalidUsername
//        handlers[ResponseSubType.invalid_password.rawValue] = handleInvalidPassword
//        handlers[ResponseSubType.created_user.rawValue] = handleCreatedUser
//        handlers[ResponseSubType.invalid_user.rawValue] = handleInvalidUser
//        handlers[ResponseSubType.no_auth_user.rawValue] = handleNoAuthUser
//        handlers[ResponseSubType.game_not_active.rawValue] = handleGameNotActive
//        handlers[ResponseSubType.invalid_message.rawValue] = handleInvalidMessage
//        handlers[ResponseSubType.match_made.rawValue] = handleMatchMade
//        handlers[ResponseSubType.queue_failed.rawValue] = handleQueueFailed
        }
    
    func decodeMessage(_ data: String) -> ResponseMessage? {
        do {
            print("message to decode:",data)
            let jsonData = data.data(using: .utf8)
            return try JSONDecoder().decode(ResponseMessage.self, from: jsonData!)
            
        } catch {
            print("Error decoding message: \(error)")
            return nil
        }
    }
    
    func handleMessage(_ message: ResponseMessage) -> HandlerResponse{
        if let handler = handlers[message.sub_type.rawValue] {
            return handler(message)
        } else {
            print("Unhandled message type: \(message.sub_type.rawValue)")
        }
        return HandlerResponse();
    }
    
    func handleMoveReceived(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the move received case
        do {
            let jsonData = message.data?.data(using: .utf8)
            let data = try JSONDecoder().decode(MoveData.self, from: jsonData!)
            let result: HandlerResponse = HandlerResponse(listenForMessage: false, isMove: true, hasData: true, data: data, successful: true);
            return result;
        } catch {
            print("ruh roh \(error)")
        }
        let result: HandlerResponse = HandlerResponse(successful: false);
        return result;
    }

    func handleMoveSent(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the move sent case
        // Handle the move received case
        let result: HandlerResponse = HandlerResponse(listenForMessage: true, hasData: false, successful: true);
        return result;
    }
    
    func handleUserJoinedGame(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the user joined game case
        let result: HandlerResponse = HandlerResponse(successful: true);
        userConnectedToGame = true;
        homeDelegate?.joinedGame();
        return result;
    }
    func handleOpponentJoinedGame(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the user joined game case
        let result: HandlerResponse = HandlerResponse(successful: true);
        opponentConnectedToGame = true;
        homeDelegate?.joinedGame()
        //Perhaps a game start delegate which is async until both user and opponent have joined?
        return result;
    }

    func handleEnteredGameQueue(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the enter game queue case
        let result: HandlerResponse = HandlerResponse(successful: true);
        homeDelegate?.enteredGameQueue()
        return result;
    }

    func handleLeftGameQueue(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the left game queue case
        let result: HandlerResponse = HandlerResponse(listenForMessage: false, hasData: false, successful: true);
        return result;
    }
    
    func handleGameEnded(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the game ended case
        let result: HandlerResponse = HandlerResponse(listenForMessage: true, hasData: false, successful: true);
        return result;
    }

    func handleInvalidQuery(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the invalid query case
        let result: HandlerResponse = HandlerResponse(listenForMessage: false, hasData: false, successful: false);
        return result;
    }

    func handleLoginSuccessful(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the login successful case
        do {
            let jsonData = message.data?.data(using: .utf8);
            let data = try JSONDecoder().decode(UserData.self, from: jsonData!);
            userID = data.user_id;
            loginDelegate?.didReceiveLoginSuccess()
            let result: HandlerResponse = HandlerResponse(successful: true);
            print("successfuly decoded login message")
            return result;
        } catch {
            print("ruh roh \(error)")
        }
        let result: HandlerResponse = HandlerResponse(successful: false);
        return result;
    }

    func handleInvalidUsername(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the invalid username case
        let result: HandlerResponse = HandlerResponse(successful: false);
        loginDelegate?.didReceiveLoginFailure(error:"Invalid Username")
        return result;
    }
    
    func handleInvalidPassword(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the invalid password case
        let result: HandlerResponse = HandlerResponse(successful: false);
        loginDelegate?.didReceiveLoginFailure(error:"Invalid Password")
        return result;
    }

    func handleCreatedUser(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the created user case
        let result: HandlerResponse = HandlerResponse(listenForMessage: false, hasData: false, successful: true);
        return result;
    }

    func handleInvalidUser(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the invalid user case
        let result: HandlerResponse = HandlerResponse(successful: false);
        return result;
    }

    func handleNoAuthUser(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the no auth user case
        let result: HandlerResponse = HandlerResponse(successful: false);
        return result;
    }

    func handleGameNotActive(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the game not active case
        let result: HandlerResponse = HandlerResponse(successful: false);
        return result;
    }

    func handleInvalidMessage(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the invalid message case
        let result: HandlerResponse = HandlerResponse(successful: false);
        return result;
    }
    func handleMatchMade(_ message: ResponseMessage) -> HandlerResponse {
        // Handle valid match creation
        do {
            let jsonData = message.data?.data(using: .utf8);
            let data = try JSONDecoder().decode(GameData.self, from: jsonData!);
            gameID = data.game_id;
            opponentUsername = data.username;
            isWhite = !(data.is_white);
            homeDelegate?.matchFound()
            let result: HandlerResponse = HandlerResponse(successful: true);
            return result;
        } catch {
            print("ruh roh \(error)")
        }
        let result: HandlerResponse = HandlerResponse(successful: false);
        return result;
    }
    
    func handleQueueFailed(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the invalid match
        let result: HandlerResponse = HandlerResponse(successful: false);
        return result;
    }
    
}
