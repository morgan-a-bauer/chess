//
//  move.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Move {
    let cell: Cell
    let startCell: Cell
    let targetCell: Cell
//    let pieceMoved: Piece
//    let pieceCaptured: Piece?
    let inCheck: Bool
    let inMate: Bool
}
