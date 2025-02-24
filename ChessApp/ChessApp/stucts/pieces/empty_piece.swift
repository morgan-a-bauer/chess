//
//  empty_piece.swift
//  ChessApp
//
//  Created by Morgan Bauer on 2/19/25.
//

struct EmptyPiece: BasePiece {
    var cellId: Int

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<Int> {
        return [0]
    }

    func charRepresentation() -> String {
        return ""
    }
}
