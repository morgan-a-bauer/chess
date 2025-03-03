//
//  queen.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Queen: BasePiece {
    var cellId: Int

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<Int> {
        var moves = [-77, -70, -66, -63, -60, -55, -54, -50, -45, -44, -40, -36,
                     -33, -30, -27, -22, -20, -18, -11, -10, -9, -7, -6, -5, -4,
                     -3, -2, -1, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 18, 20, 22, 27,
                     30, 33, 36, 40, 44, 45, 50, 54, 55, 60, 63, 66, 70, 77]

        return moves
    }

    func charRepresentation() -> String {
        return "q"
    }
}

