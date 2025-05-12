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

    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }

    func getMoves(nodeMap: NodeMap<String, SKNode>, nodeToPiece: [SKSpriteNode?: BasePiece]) -> Array<Int> {
        var moves: [Int] = []
        
        // Values to add to current position for possible moves
        let incs = [9, -9, 11, -11]
        for inc in incs{
            var potentialMove = cellId + inc
            
            // Stop if out of bounds of the board
            while potentialMove <= 77 && potentialMove >= 0 && (potentialMove % 10) != 8 && (potentialMove % 10) != 9 {
                
                // Valid move if space is free or contains an opponent's piece
                if nodeMap[String(potentialMove)] == nil {
                    moves.append(potentialMove)
                }
                else if let node = nodeMap[String(potentialMove)] as? SKSpriteNode {
                    if nodeToPiece[node]?.color != color {
                        moves.append(potentialMove)
                    }
                    
                    // stop once a piece is reached
                    break
                }
                potentialMove += inc
            }
        }

        return moves
    }

    func charRepresentation() -> String {
        return "b"
    }
}
