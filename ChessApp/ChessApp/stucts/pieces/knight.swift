//
//  knight.swift
//  ChessApp
//
//  Created by Morgan Bauer on 2/3/25.
//
import SpriteKit

struct Knight: BasePiece {
    var cellId: Int
    var color = ""
    var icon = ""
    var node = SKSpriteNode()
    var nodeMap = NodeMap<String, SKNode>()

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
