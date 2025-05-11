//
//  pawn.swift
//  ChessApp
//
//  Created by Morgan Bauer on 2/3/25.
//
import SpriteKit

struct Pawn: BasePiece {
    var cellId: Int
    var color = ""
    var icon = ""
    var node = SKSpriteNode()

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<Int> {
        var moves = [10]
        return moves
    }

    func charRepresentation() -> String {
        return ""
    }
}
