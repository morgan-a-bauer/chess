//
//  BoardScene.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/31/25.
//

import SpriteKit
import UIKit


// Morgan this is a base for you to jump off of when developing the board and pieces. Change whatever you want to change
class GameScene: CustomSKScene, GameSceneActionsDelegate {
    
    
    weak var viewControllerDelegate: GameSceneDelegate? // Delegate property for boardscene -> VC
    
    // Testing Variable
    let targetCell: Int = 11
    
    var touchedNode: SKShapeNode? = nil
    var originalLocation: CGPoint? = nil
    //var moveHistory: MoveHistory = MoveHistory(gameId:WebSocketManager.shared.gameID!)
    var moveHistory: MoveHistory = MoveHistory(gameId: WebSocketManager.shared.gameID ?? 0)
    weak var sceneDelegate: BoardToSceneDelegate?
    var players: [Player] = []
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
                
                var myDatabase = [["Nate","Goucher"],["John", "Hilliard"]]
                var p1 = Player(color:"white",playerName:myDatabase[0][0], turn:true)
                var p2 = Player(color:"black",playerName:myDatabase[1][0])
                var players = [p1,p2]
            }
        }

        
    }

    func getCurrentPlayer() -> Player? {
        for player in players {
            if player.turn == true {
                print(player)
                return player
            }
        }
        print("bug!")
        return nil
    }
    
    func getWaitingPlayer() -> Player?{
        for player in players {
            if player.turn == false {
                return player
            }
        }
        return nil
    }
    
    func completeMove() {
        print("complete move called")
        if let currentPlayer = getCurrentPlayer(), let nextPlayer = getWaitingPlayer() {
            print("Ending turn for \(currentPlayer.playerName) (\(currentPlayer.color))")
            currentPlayer.endturn() //calls pauseTimer()
            
            print("Starting turn for \(nextPlayer.playerName) (\(nextPlayer.color))")
            nextPlayer.startturn() //calls unpauseTimer()
            
            viewControllerDelegate?.didCompleteMove()
        } else {
            print("Error: Cannot complete move - players not properly initialized")
        }
    }
    
    func performCompleteMove() {
        print("debug: performCompleteMove called")
        
        //debugging
        if let currentPlayer = getCurrentPlayer() {
            print("Current player before move completion: \(currentPlayer.playerName) (\(currentPlayer.color))")
            print("Timer state: \(currentPlayer.pausedTimer ? "paused" : "running")")
        }
        
        self.completeMove()
        
        //Debugging
        if let newCurrentPlayer = getCurrentPlayer() {
            print("Current player after move completion: \(newCurrentPlayer.playerName) (\(newCurrentPlayer.color))")
            print("Timer state: \(newCurrentPlayer.pausedTimer ? "paused" : "running")")
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
//        let startCell: Cell = Cell(cell: 5)
//        let targetCell: Cell = Cell(cell: 23)
//        let pieceMoved: Bishop = Bishop(cellId: 5)
//         let pieceCaptured: BasePiece? = nil
//         let inCheck: Bool = false
//         let inMate: Bool = false
//         let move: Move = Move(startCell: startCell, targetCell: targetCell, pieceMoved: pieceMoved, pieceCaptured: pieceCaptured, inCheck: inCheck, inMate: inMate)
//         moveHistory.append(move)
        sceneDelegate?.updateViewableMoveHistory(moveHistory)
        
        //begin code for updating turns and timers.
        //Use same conditions for updating move history to trigger timer change from white to black and vice versa.
        
        // NEW TIMER CODE: Removed automatic completeMove() call here
        // Now the user must explicitly press the "End Move" button to complete their move
        // This gives them a chance to adjust their move if needed
        // completeMove()
        
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
