//
//  board_delegate.swift
//  ChessApp
//
//  Created by Jackson Butler on 4/8/25.
//


protocol BoardDelegate: AnyObject {
    func opponentMove(_ move: String)
}
