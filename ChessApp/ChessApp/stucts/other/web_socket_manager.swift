//
//  web_socket_manager.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/27/25.
//

import Foundation
import Combine

enum WebSocketState {
    case connected
    case reconnecting
    case disconnected
}

class WebSocketManager: NSObject, ObservableObject {
    static let shared = WebSocketManager()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession: URLSession = URLSession(configuration: .default)
    private let url = URL(string: "ws://chessbackend-iwcv.onrender.com:10000")!
    private var connectionState: WebSocketState = .disconnected
    @Published private var messageQueue: [String] = []
    
    
    deinit {
        print("WebSocketManager deinitialized")
    }
    
    
    private override init() {
    }
    
    // You can manually change the state as needed
    private func setConnectionState(to state: WebSocketState) {
        connectionState = state
        print("Connection state changed to: \(state)")
        if connectionState == .connected {
            self.sendMessage()
        }
    }
    
    private func getConnectionState() -> WebSocketState {
            return connectionState
        }
    
    func connect() {
        webSocketTask = self.urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        print("sendPing")
        Task{
            await self.sendPing()
        }
        print("pingSent")
        guard getConnectionState() != .connected else { return }
        receiveMessage()  // Start listening for messages
        print(messageQueue)
        self.sendMessage()
    }
    
    func addMessage (_ messageData: [String: Any]) {
        do {
            print("Add message to queue")
            let jsonData = try JSONSerialization.data(withJSONObject:messageData)
            if let message = String(data: jsonData, encoding: .utf8) {
                messageQueue.append(message)
                print(messageQueue)
            }
        } catch {
            print("error")
        }
    }
    
    private func sendMessage() {
        guard (!messageQueue.isEmpty) && (self.getConnectionState() == .connected) else { return }
        print("Send Message")
        let message = messageQueue.removeFirst()
        let messageToSend = URLSessionWebSocketTask.Message.string(message)
            self.webSocketTask?.send(messageToSend) {error in
            if let error = error {
                print("\nWebSocket Send Error: \(error.localizedDescription) \n")
                switch self.getConnectionState() {
                case .connected:
                    self.setConnectionState(to: .disconnected)
                    self.handleConnectionLoss()
                case .reconnecting:
                    print("Waiting for reconnect")
                case .disconnected:
                    self.handleConnectionLoss()
                }
                
                
            } else {
                print("Message Sent: \(message)")
            }
        }
        messageQueue = messageQueue // Triggers message listener to fire off whole queue
    }
        
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received: \(text)")
                case .data(let data):
                    print("Received binary data: \(data)")
                default:
                    break
                }
                self?.receiveMessage()  // Continue listening
            case .failure(let error):
                print("WebSocket receive error: \(error)\n\n")
                switch self?.getConnectionState() {
                case .connected:
                    self?.setConnectionState(to: .disconnected)
                    print("handleConnectionLoss")
                    self?.handleConnectionLoss()
                case .reconnecting:
                    print("Waiting for reconnect")
                case .disconnected:
                    print("handleConnectionLoss")
                    self?.handleConnectionLoss()
                case .none:
                    print("Fuck")
                }
            }
            
        }
    }
    
    func monitorMessageQueue(_ manager: WebSocketManager) async {
        for await newState in manager.$messageQueue.values {
            switch self.getConnectionState(){
            case .connected:
                self.sendMessage()
            case .disconnected:
                self.handleConnectionLoss()
            case .reconnecting:
                let foo:String
            }
        }
    }
    
//    func monitorConnectionState(_ manager: WebSocketManager) async {
//        for await newState in manager.$connectionState.values {
//            
//            switch newState {
//            case .connected:
//                print("WebSocket is connected!")
//            case .reconnecting:
//                print("Reconnecting")
//            case .disconnected:
//                print("Handling Disconnect")
//                self.handleConnectionLoss()
//            }
//        }
//    }
    
    func disconnect() {
        setConnectionState(to: .disconnected)
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
//    /// Sends a ping every 15 seconds and checks if the WebSocket is still alive
//    private func startPing() {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 15) { [weak self] in
//            self?.sendPing()
//            self?.startPing() // Schedule next ping
//        }
//    }
//    
    private func sendPing() async {
        webSocketTask?.sendPing { [weak self] error in
            if let error = error {
                self?.setConnectionState(to: .disconnected)
                print("Ping failed: \(error.localizedDescription)")
            } else {
                self?.setConnectionState(to: .connected)
                print("Ping successful")
            }
        }
    }
    /// Reconnects if the WebSocket dies
    func handleConnectionLoss() {
        setConnectionState(to: .reconnecting)
        print("Reconnecting...")
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 5) { [weak self] in
            print("reconnect attempt")
            if (self?.getConnectionState() != .connected) {
                self?.connect()
            } else {
                self?.setConnectionState(to: .connected)
                
                print("Connected")
            }
        }
    }
    
}
