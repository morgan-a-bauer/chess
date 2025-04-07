//
//  BoardScene.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/31/25.
//

import SpriteKit
import UIKit


// Morgan this is a base for you to jump off of when developing the board and pieces. Change whatever you want to change
class GameScene: CustomSKScene {

    
    // Testing Variable
    let targetCell: Int = 11
    var counter: Int = 0
    
    var touchedNode: SKShapeNode? = nil
    var originalLocation: CGPoint? = nil
    var moveHistory: MoveHistory = MoveHistory()
    weak var sceneDelegate: BoardToSceneDelegate?
    // nodeMap is an implied data type check ./structs/other for more info
    // use and treat it as hashMap

    // Kind of "Main"
    override func didMove(to view: SKView) {
        // Build chess board
        // Piece seems to need to be added within this scope to "view"
        
        var colour: Bool
        let squareWidth = self.size.width/8
        let squareHeight = self.size.height/8
        
        // Basic board draw
        // Rows
        for row in 0..<Int(8) {
            let squarePosY = (squareHeight * CGFloat(row)) + (squareHeight/2)
            if (row%2 != 0) {colour = true} else {colour = false}
            
            // Columns
            for column in 0..<Int(8) {
                let squarePosX = (squareWidth * CGFloat(column)) + (squareWidth/2)
                
                // Attributes of square
                
                let square = SKShapeNode(rectOf: CGSize(width: squareWidth, height: squareHeight))
                let cellStrValue:UnicodeScalar = UnicodeScalar(column+97)!
                
                if colour {square.fillColor = .white} else {square.fillColor = .brown}
                
                square.position = CGPoint(x: squarePosX, y: squarePosY)
                square.zPosition = 1
                square.name = "\(String(describing: cellStrValue))\(row+1)"
                
                
                // !! Places SKShapeNode into SKScene
                addChild(square)
                
                // House Keeping
                colour = !colour
            }
        }
    }

    // Get valid moves

    // Called if something is touched within scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Gets current mouse location
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // Currently can pick up any drawn node, board cells included
        if let node = self.atPoint(touchLocation) as? SKShapeNode {
            
            touchedNode = node
            originalLocation = node.position
            
            //  findValidMoves() ??
        }
        // Testing square naming
        if getNode(named: targetCell) == touchedNode {
            print("Target Cell", touchedNode?.name ?? "Nil")
        }
        else {
            print("Non Target", touchedNode?.name ?? "Nil")
        }
    }
    
    
    // Called if touch moves
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Gets current mouse location
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // Touch move
        let x = touchLocation.x.rounded()
        let y = touchLocation.y.rounded()
        
        // Make touched node track mouse
        if touchedNode != nil {
            touchedNode?.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 0.005))
        }
    }
    
    
    // Called if touch is released
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Gets current mouse location
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // Touch move
        let x = touchLocation.x.rounded()
        let y = touchLocation.y.rounded()
        
        // Some form of the below pieceNode lock to cell idea will be required at final implementation
          if  touchedNode != nil {
              touchedNode?.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 0.005))
              
              // Just Spitballing on ideas for checking valid moves, I'll stop this and leave it up to you.
//              if (nodeMap.move(piece: touchedNode, to: 11)) == false {
//                  // if move invalid?
//                  // Have a not so funky fresh time?
//              }
            
          }
        
        // An idea of how to lock piece to a board cell center
        // pieceNode?.run(SKAction.move(to: CGPoint(x: nodesBelow.first!.position.x, y: nodesBelow.first!.position.y), duration: 0.005))
        
        
        
                
        // Testing Code for move history
        let startCell: Cell = Cell(cell: 5)
        let targetCell: Cell = Cell(cell: counter)
        let pieceMoved: Bishop = Bishop(cellId: 5)
         let pieceCaptured: BasePiece? = nil
         let inCheck: Bool = false
         let inMate: Bool = false
         
        let move: Move = Move(startCell: startCell, targetCell: targetCell, pieceMoved: pieceMoved, pieceCaptured: pieceCaptured, inCheck: inCheck, inMate: inMate)
            moveHistory.append(move)
        counter += 1;
         
        sceneDelegate?.updateViewableMoveHistory(moveHistory)
        
    }
    
    
    // Called if the touch is interrupted
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Returns node to original location
        touchedNode?.run(SKAction.move(to: CGPoint(x: originalLocation!.x, y: originalLocation!.y), duration: 0.005))
        print("Touch cancelled")
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        }
    
    
    
}

