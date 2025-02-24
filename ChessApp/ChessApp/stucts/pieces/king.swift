//
//  king.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct King: BasePiece {
    var cellId: Int

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<Int> {
        var moves = [-11, -10, -9, -1, 1, 9, 10, 11]

        return moves
    }

    func charRepresentation() -> String {
        return "k"
    }
}
