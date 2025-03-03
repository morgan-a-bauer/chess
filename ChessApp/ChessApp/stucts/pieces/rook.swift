//
//  rook.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Rook: BasePiece {
    var cellId: Int

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<Int> {
        var moves = [-70, -60, -50, -40, -30, -20, -10, -7, -6, -5, -4, -3, -2,
                     -1, 1, 2, 3, 4, 5, 6, 7, 10, 20, 30, 40, 50, 60, 70]

        return moves
    }

    func charRepresentation() -> String {
        return "r"
    }
}
