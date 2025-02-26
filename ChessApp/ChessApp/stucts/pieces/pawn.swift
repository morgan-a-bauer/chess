//
//  pawn.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Pawn: BasePiece {
    var cellId: UInt8

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<UInt8> {
        return []
    }

    func charRepresentation() -> String {
        return ""
    }
}
