//
//  bishop.swift
//  ChessApp
//
//  Created by Morgan Bauer on 2/3/25.
//
import SpriteKit

struct Bishop: BasePiece {
    var cellId: Int
    var color = ""
    var icon = ""
    var node = SKSpriteNode()
    var nodeMap = NodeMap<String, SKNode>()

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<Int> {
        let moves = [-77, -66, -63, -55, -54, -45, -44, -36, -33, -27, -22, -18,
                     -11, -9, 9, 11, 18, 22, 27, 33, 36, 44, 45, 54, 55, 63, 66,
                      77]

        return moves
    }

    func charRepresentation() -> String {
        return "b"
    }
}
