//
//  bishop.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Bishop: BasePiece {
    var cellId: Int

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<Int> {
        var moves = [-77, -66, -63, -55, -54, -45, -44, -36, -33, -27, -22, -18,
                     -11, -9, 9, 11, 18, 22, 27, 33, 36, 44, 45, 54, 55, 63, 66,
                      77]

        return moves
    }

    func charRepresentation() -> String {
        return "b"
    }
}
