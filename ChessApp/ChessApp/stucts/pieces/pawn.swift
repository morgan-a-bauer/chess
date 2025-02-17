//
//  pawn.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Pawn: BasePiece {
    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }
    func charRepresentation() -> String {
        return ""
    }
}
