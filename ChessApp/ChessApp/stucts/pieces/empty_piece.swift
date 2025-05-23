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

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves(nodeMap: NodeMap<String, SKNode>, nodeToPiece: [SKSpriteNode?: BasePiece]) -> Array<Int> {
        return [0]
    }

    func charRepresentation() -> String {
        return "_"
    }
}
