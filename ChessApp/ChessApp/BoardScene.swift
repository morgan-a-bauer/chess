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
    
    // Testing Variable
    let targetCell: Int = 11
    
    var touchedNode: SKShapeNode? = nil
    var originalLocation: CGPoint? = nil
    var moveHistory: MoveHistory = MoveHistory(gameId:1)
    weak var sceneDelegate: BoardToSceneDelegate?
    
    var childNodeMap: [String: SKNode] = [:]
    
    
    override var children: [SKNode] {
        return Array(childNodeMap.values)
    }
    
    override func addChild(_ node: SKNode) {
        guard let name = node.name else{
            fatalError("Nodes muust have a unique name.")
        }
        childNodeMap[name] = node
        super.addChild(node)
    }
    
    override func removeChildren(in nodes: [SKNode]) {
        for node in nodes {
            if let name = node.name {
                childNodeMap.removeValue(forKey: name)
            }
        }
        super.removeChildren(in: nodes)
    }
    
    // Use this for checking node locations...
    // Hmmmmm. This is the actual square cells themselves. Some more is needed to check for if a piece is present...
    func getNode(named name: Int) -> SKNode? {
        return childNodeMap[String(name)]
    }
    
    
    
    // Kind of "Main"
    override func didMove(to view: SKView) {
        // Build chess/checkers board
        //        board = Array(repeating: Array(repeating: boardCell(), count: Int(content!.number)), count: Int(content!.number))
        // Piece seems to need to be added within this scope to "view"
        let squareWidth = self.size.width/8
        let squareHeight = self.size.height/8
        
        
        // Basic board draw
        // Rows
        var cell = 0
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
                square.name = "\(cell)"
                
                
                // !! Places SKShape into SKScene
                addChild(square)
                //                board[column][row] = boardCell(square: square)
                colour = !colour
                cell += 1
            }
            cell += 2
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
        // Testing square naming
        if getNode(named: targetCell) == touchedNode {
            print("Target Cell", touchedNode?.name!)
        }
        else {
            print("Non Target", touchedNode?.name!)
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
        
        // Not actually necessary for what we currently have, although the some form of the below pieceNode lock to cell idea will be required at final implementation
          if  touchedNode != nil {
              touchedNode?.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 0.005))
          }
        
        
        // An idea of how to lock piece to a board cell center
        // pieceNode?.run(SKAction.move(to: CGPoint(x: nodesBelow.first!.position.x, y: nodesBelow.first!.position.y), duration: 0.005))
        
//        print("Touch Stopped At: \(touchLocation)")
        
        // Testing Code for move history
//        let startCell: Cell = Cell("e2")
//        let targetCell: Cell = Cell("e4")
//        let pieceMoved: Bishop = Bishop()
//        let pieceCaptured: BasePiece? = nil
//        let inCheck: Bool = false
//        let inMate: Bool = false
//        let move: Move = Move(startCell: startCell, targetCell: targetCell, pieceMoved: pieceMoved, pieceCaptured: pieceCaptured, inCheck: inCheck, inMate: inMate)
//        moveHistory.append(move)
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

