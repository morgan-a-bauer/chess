//
//  BoardScene.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/31/25.
//

import SpriteKit
import UIKit


// Morgan this is a base for you to jump off of when developing the board and pieces. Change whatever you want to change
class GameScene: SKScene {
    
    var touchedNode: SKShapeNode? = nil
    var originalLocation: CGPoint? = nil
    
    // Kind of "Main"
    override func didMove(to view: SKView) {
        // Build chess/checkers board
        //        board = Array(repeating: Array(repeating: boardCell(), count: Int(content!.number)), count: Int(content!.number))
        let squareWidth = self.size.width/8
        let squareHeight = self.size.height/8
        
        
        // Basic board draw
        // Rows
        for row in 0..<Int(8) {
            var colour: Bool
            let squarePosY = (squareHeight * CGFloat(row)) + (squareHeight/2)
            
            if (row%2 != 0) {colour = true} else {colour = false}
            
            // Columns
            for column in 0..<Int(8) {
                
                // Board
                let squarePosX = (squareWidth * CGFloat(column)) + (squareWidth/2)
                // Attributes of square
                let square = SKShapeNode(rectOf: CGSize(width: squareWidth, height: squareHeight))
                square.position = CGPoint(x: squarePosX, y: squarePosY)
                square.zPosition = 1
                if colour {square.fillColor = .white} else {square.fillColor = .brown}
                square.name = "\(row),\(column),square"
                
                
                // !! Places SKShape into SKScene
                addChild(square)
                //                board[column][row] = boardCell(square: square)
                colour = !colour
            }
        }
    }
    
    
    // Called if something is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Gets current mouse location
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        
        // Currently can pick up any drawn node, board cells included
        if let node = self.atPoint(touchLocation) as? SKShapeNode {
            touchedNode = node
            originalLocation = node.position
            //  findValidMoves()
        }
        print(self.atPoint(touchLocation))
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
        
        // Not actually necessary for what we currently have, although the some form of the below pieceNode lock to cell idea will be required at final implementation
          if  touchedNode != nil {
              touchedNode?.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 0.005))
          }
        
        // An idea of how to lock piece to a board cell center
        // pieceNode?.run(SKAction.move(to: CGPoint(x: nodesBelow.first!.position.x, y: nodesBelow.first!.position.y), duration: 0.005))
        
        print("Touch Stopped At: \(touchLocation)")
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

