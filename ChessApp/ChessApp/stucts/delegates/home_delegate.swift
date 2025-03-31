//
//  home_delegate.swift
//  ChessApp
//
//  Created by Jackson Butler on 3/23/25.
//

protocol HomeDelegate: AnyObject {
    func enteredGameQueue();
    func matchFound();
    func joinedGame();
    func receiveGameHistory(_ response:[GameHistory]);
}
