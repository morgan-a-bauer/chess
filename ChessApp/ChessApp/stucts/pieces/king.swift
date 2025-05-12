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

    func getMoves(nodeMap: NodeMap<String, SKNode>, nodeToPiece: [SKSpriteNode?: BasePiece]) -> Array<Int> {
        var moves: [Int] = []
        let incs = [1, -1, 9, -9, 10, -10, 11, -11]
        for inc in incs{
            var potentialMove = cellId + inc
            if potentialMove <= 77 && potentialMove >= 0 && (potentialMove % 10) != 8 && (potentialMove % 10) != 9 {
                print(potentialMove)
                if nodeMap[String(potentialMove)] == nil {
                    moves.append(potentialMove)
                }
                else if let node = nodeMap[String(potentialMove)] as? SKSpriteNode {
                    if nodeToPiece[node]?.color != color {
                        moves.append(potentialMove)
                    }
                }
                potentialMove += inc
            }
        }

        return moves
    }

    func charRepresentation() -> String {
        return "k"
    }
}
