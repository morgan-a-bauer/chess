//
//  queen.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Queen: BasePiece {
    var cellId: UInt8

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }
    func charRepresentation() -> String {
        return "q"
    }
}

