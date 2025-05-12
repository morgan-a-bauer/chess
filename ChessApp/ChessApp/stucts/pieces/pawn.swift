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
    var nodeMap = NodeMap<String, SKNode>()

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves() -> Array<Int> {
        let direction = (color == "w") ? 1 : -1
        var moves: [Int] = []
        if nodeMap[String(cellId + 10)] == nil {
            moves.append(cellId + 10)
        }
        if (color == "w" && cellId >= 10 && cellId <= 17) ||
            (color == "b" && cellId >= 60 && cellId <= 67) {
            if nodeMap[String(cellId + 20)] == nil {
                moves.append(cellId + 20)
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
        return ""
    }
}
