//
//  empty_piece.swift
//  ChessApp
//
//  Created by Morgan Bauer on 2/19/25.
//

struct EmptyPiece: BasePiece {
    var cellId: UInt8

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }
    func charRepresentation() -> String {
        return ""
    }
}
