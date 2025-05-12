//
//  web_socket_message_handler.swift
//  ChessApp
//
//  Created by Jackson Butler on 3/18/25.
//  Written By Jackson Butler
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
        handlers["game_history"] = gameHistory
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
    
    func handleMoveReceived(_ message: ResponseMessage) -> HandlerResponse{
        // Handle the move received case
        let data = message.data!
        boardDelegate?.opponentMove(data);
        let result: HandlerResponse = HandlerResponse(listenForMessage: true, hasData: true, successful: true);
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
        if message.type == .success {
            homeDelegate?.leftGameQueue()
        }
        return result;
    }
    
    func handleGameEnded(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the game ended case
        let result: HandlerResponse = HandlerResponse(listenForMessage: true, hasData: false, successful: true);
        if message.type == .success {
            gameDelegate?.handleGameEnded()
            
        }
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
//            let milestonesJsonData = data.milestones.data?.data(using: .utf8);
//            let milestones = try JSONDecoder().decode(MilestonesData.self, from: milestonesJsonData!);
//            
            userID = data.user_id;
            userIcon = data.user_icon;
            userMilestones = data.milestones;
            loginDelegate?.didReceiveLoginSuccess()
            let result: HandlerResponse = HandlerResponse(successful: true);
            print("successfuly decoded login message", jsonData!, data)
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
        createAccountDelegate?.didReceiveCreateAccount()
        return result;
    }

    func handleInvalidUser(_ message: ResponseMessage) -> HandlerResponse {
        // Handle the invalid user case
        let result: HandlerResponse = HandlerResponse(successful: false);
        createAccountDelegate?.didReceiveCreateAccountFailure(error: message.message!)
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
    
    func gameHistory(_ message: ResponseMessage) -> HandlerResponse {
        
        if let dataArray = message.dataArray {
            var decodedGames: [GameHistory] = []
            
            for jsonString in dataArray {
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let game = try JSONDecoder().decode(GameHistory.self, from: jsonData)
                        decodedGames.append(game)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
//            print(decodedGames)
            homeDelegate?.receiveGameHistory(decodedGames)
        }
                    
        let result: HandlerResponse = HandlerResponse(successful: true);
        return result;
    }
    
}
