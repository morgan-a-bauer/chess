//
//  pawn.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Pawn: BasePiece {
    var cellId: Int
    var hasMoved = false

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<Int> {
        var moves = [10]
        if self.hasMoved == false {
            moves.append(20)
        }
        return moves
    }

    func charRepresentation() -> String {
        return ""
    }
}
