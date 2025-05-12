//
//  game_delegate.swift
//  ChessApp
//
//  Created by Jackson Butler on 5/5/25.
//

protocol GameDelegate: AnyObject {
    func handleGameEnded()
    func loadOldGame(_ moveHistory: [String], _ user: UserHistory, _ opponent: UserHistory)
}
