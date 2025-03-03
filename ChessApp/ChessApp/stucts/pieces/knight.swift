//
//  knight.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Knight: BasePiece {
    var cellId: Int

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<Int> {
        var moves = [-21, -19, -12, -8, 8, 12, 19, 21]

        return moves
    }

    func charRepresentation() -> String {
        return "n"
    }
}
