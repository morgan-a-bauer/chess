//
//  empty_piece.swift
//  ChessApp
//
//  Created by Morgan Bauer on 2/19/25.
//
import SpriteKit

struct EmptyPiece: BasePiece {
    var cellId: Int
    var color = ""
    var icon = ""
    var node = SKSpriteNode()
    var nodeMap = NodeMap<String, SKNode>()

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<Int> {
        return [0]
    }

    func charRepresentation() -> String {
        return "_"
    }
}
