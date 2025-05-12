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

    func getMoves(nodeMap: NodeMap<String, SKNode>, nodeToPiece: [SKSpriteNode?: BasePiece]) -> Array<Int> {
        let direction = 1
        var moves: [Int] = []
        if nodeMap[String(cellId + 10 * direction)] == nil {
            moves.append(cellId + 10 * direction)
        }
        if (cellId >= 10 && cellId <= 17) {
            if nodeMap[String(cellId + 20 * direction)] == nil {
                moves.append(cellId + 20 * direction)
            }
        }
        for offset in [9, 11] {
            let targetId = cellId + direction * offset
            if let piece = nodeMap[String(targetId)], let name = piece.name {
                print("to capture: \(name)")
                if name.prefix(1) != color {
                    moves.append(targetId)
                }
            }
        }
        return moves
    }

    func charRepresentation() -> String {
        return "p"
    }
}
