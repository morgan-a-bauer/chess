//
//  king.swift
//  ChessApp
//
//  Created by Morgan Bauer on 2/3/25.
//
import SpriteKit

struct King: BasePiece {
    var cellId: Int
    var color = ""
    var icon = ""
    var node = SKSpriteNode()

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
