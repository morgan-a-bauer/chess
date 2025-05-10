//
//  game_delegate.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/10/25.
//

protocol BoardToGameDelegate: AnyObject {
    func updateViewableMoveHistory(_ moveHistory: MoveHistory)
}
