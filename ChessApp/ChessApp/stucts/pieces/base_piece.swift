//
//  base_piece.swift
//  ChessApp
//
//  Created by Morgan Bauer on 2/3/25.
//

// Check out protocol extensions for cool functionality
import SpriteKit

protocol BasePiece {
    var cellId: Int { get set };
    var color: String { get set};
    var icon: String { get set };
    var node: SKSpriteNode { get set};

    func moveIsValid(_ destination: Cell) -> Bool
    func getMoves(nodeMap: NodeMap<String, SKNode>, nodeToPiece: [SKSpriteNode?: BasePiece]) -> Array<Int>
    func charRepresentation() -> String
}
