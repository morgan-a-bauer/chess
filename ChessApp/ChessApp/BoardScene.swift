//
//  BoardScene.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/31/25.
//

import SpriteKit
import UIKit


// Morgan this is a base for you to jump off of when developing the board and pieces. Change whatever you want to change
class GameScene: CustomSKScene, GameSceneActionsDelegate, BoardDelegate {
    
    
    weak var viewControllerDelegate: GameSceneDelegate?; // Delegate property for boardscene -> VC
    weak var sceneDelegate: BoardToGameDelegate?;
    
    // Testing Variable
    let targetCell: Int = 11
    var counter: Int = 0
    
    var touchedNode: SKSpriteNode? = nil
    var originalLocation: CGPoint? = nil
    var nodeToPiece: [SKSpriteNode?: BasePiece] = [:]
    var moveHistory: MoveHistory = MoveHistory()

    
    var players: [Player] = []
    var turn: Int = 1
    // nodeMap is an implied data type check ./structs/other for more info
    // use and treat it as hashMap
    
    func setupScene() {
        self.removeAllChildren()
        
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
                square.zPosition = 0
                square.name = "\(String(describing: cellStrValue))\(row+1)"
                
                let pos = row * 10 + column
                // MB debug
                // print("User: \(WebSocketManager.shared.username)")
                // print("white: \(WebSocketManager.shared.isWhite)")
                //if WebSocketManager.shared.isWhite {
                if (row == 0) {
                    if (column == 0) || (column == 7) {
                        var rook = Rook(cellId: pos)
                        rook.color = "w"
                        rook.icon = "wR"
                        rook.node = SKSpriteNode(imageNamed: rook.icon)
                        rook.node.setScale(0.55)
                        rook.node.position = CGPoint(x: squarePosX, y: squarePosY)
                        rook.node.name = "\(pos)"
                        rook.node.zPosition = 1
                        nodeToPiece[rook.node] = rook
                        addChild(rook.node)
                    }
                    else if (column == 1) || (column == 6) {
                        var knight = Knight(cellId: pos)
                        knight.color = "w"
                        knight.icon = "wN"
                        knight.node = SKSpriteNode(imageNamed: knight.icon)
                        knight.node.setScale(0.55)
                        knight.node.position = CGPoint(x: squarePosX, y: squarePosY)
                        knight.node.name = "\(pos)"
                        knight.node.zPosition = 1
                        nodeToPiece[knight.node] = knight
                        addChild(knight.node)
                    }
                    else if (column == 2) || (column == 5) {
                        var bishop = Bishop(cellId: pos)
                        bishop.color = "w"
                        bishop.icon = "wB"
                        bishop.node = SKSpriteNode(imageNamed: bishop.icon)
                        bishop.node.setScale(0.55)
                        bishop.node.position = CGPoint(x: squarePosX, y: squarePosY)
                        bishop.node.name = "\(pos)"
                        bishop.node.zPosition = 1
                        nodeToPiece[bishop.node] = bishop
                        addChild(bishop.node)
                    }
                    else if (column == 3) {
                        var queen = Queen(cellId: pos)
                        queen.color = "w"
                        queen.icon = "wQ"
                        queen.node = SKSpriteNode(imageNamed: queen.icon)
                        queen.node.setScale(0.55)
                        queen.node.position = CGPoint(x: squarePosX, y: squarePosY)
                        queen.node.name = "\(pos)"
                        queen.node.zPosition = 1
                        nodeToPiece[queen.node] = queen
                        addChild(queen.node)
                    }
                    else if (column == 4) {
                        var king = King(cellId: pos)
                        king.color = "w"
                        king.icon = "wK"
                        king.node = SKSpriteNode(imageNamed: king.icon)
                        king.node.setScale(0.55)
                        king.node.position = CGPoint(x: squarePosX, y: squarePosY)
                        king.node.name = "\(pos)"
                        king.node.zPosition = 1
                        nodeToPiece[king.node] = king
                        addChild(king.node)
                    }
                }
                
                else if (row == 1) {
                    var pawn = Pawn(cellId: pos)
                    pawn.color = "w"
                    pawn.icon = "wP"
                    pawn.node = SKSpriteNode(imageNamed: pawn.icon)
                    pawn.node.setScale(0.55)
                    pawn.node.position = CGPoint(x: squarePosX, y: squarePosY)
                    pawn.node.name = "\(pos)"
                    pawn.node.zPosition = 1
                    nodeToPiece[pawn.node] = pawn
                    addChild(pawn.node)
                }
                
                else if (row == 6) {
                    var pawn = Pawn(cellId: pos)
                    pawn.color = "b"
                    pawn.icon = "bP"
                    pawn.node = SKSpriteNode(imageNamed: pawn.icon)
                    pawn.node.setScale(0.55)
                    pawn.node.position = CGPoint(x: squarePosX, y: squarePosY)
                    pawn.node.name = "\(pos)"
                    pawn.node.zPosition = 1
                    nodeToPiece[pawn.node] = pawn
                    addChild(pawn.node)
                }
                
                else if (row == 7) {
                    if (column == 0) || (column == 7) {
                        var rook = Rook(cellId: pos)
                        rook.color = "b"
                        rook.icon = "bR"
                        rook.node = SKSpriteNode(imageNamed: rook.icon)
                        rook.node.setScale(0.55)
                        rook.node.position = CGPoint(x: squarePosX, y: squarePosY)
                        rook.node.name = "\(pos)"
                        rook.node.zPosition = 1
                        nodeToPiece[rook.node] = rook
                        addChild(rook.node)
                    }
                    else if (column == 1) || (column == 6) {
                        var knight = Knight(cellId: pos)
                        knight.color = "b"
                        knight.icon = "bN"
                        knight.node = SKSpriteNode(imageNamed: knight.icon)
                        knight.node.setScale(0.55)
                        knight.node.position = CGPoint(x: squarePosX, y: squarePosY)
                        knight.node.name = "\(pos)"
                        knight.node.zPosition = 1
                        nodeToPiece[knight.node] = knight
                        addChild(knight.node)
                    }
                    else if (column == 2) || (column == 5) {
                        var bishop = Bishop(cellId: pos)
                        bishop.color = "b"
                        bishop.icon = "bB"
                        bishop.node = SKSpriteNode(imageNamed: bishop.icon)
                        bishop.node.setScale(0.55)
                        bishop.node.position = CGPoint(x: squarePosX, y: squarePosY)
                        bishop.node.name = "\(pos)"
                        bishop.node.zPosition = 1
                        nodeToPiece[bishop.node] = bishop
                        addChild(bishop.node)
                    }
                    else if (column == 3) {
                        var queen = Queen(cellId: pos)
                        queen.color = "b"
                        queen.icon = "bQ"
                        queen.node = SKSpriteNode(imageNamed: queen.icon)
                        queen.node.setScale(0.55)
                        queen.node.position = CGPoint(x: squarePosX, y: squarePosY)
                        queen.node.name = "\(pos)"
                        queen.node.zPosition = 1
                        nodeToPiece[queen.node] = queen
                        addChild(queen.node)
                    }
                    else if (column == 4) {
                        var king = King(cellId: pos)
                        king.color = "b"
                        king.icon = "bK"
                        king.node = SKSpriteNode(imageNamed: king.icon)
                        king.node.setScale(0.55)
                        king.node.position = CGPoint(x: squarePosX, y: squarePosY)
                        king.node.name = "\(pos)"
                        king.node.zPosition = 1
                        nodeToPiece[king.node] = king
                        addChild(king.node)
                    }
                }
                //}
                
                // !! Places SKShapeNode into SKScene
                addChild(square)
                
                // House Keeping
                colour = !colour
            }
        }
    }

    // Kind of "Main"
    override func didMove(to view: SKView) {
        WebSocketManager.shared.boardDelegate = self;
        // Build chess board
        // Piece seems to need to be added within this scope to "view"
        setupScene()
        
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
            if currentPlayer.color == "black" {
                turn += 1;
            }
                    
            
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
    
    func opponentMove(_ move: String) {
        if WebSocketManager.shared.inGame {
            DispatchQueue.main.async {
                self.performCompleteMove()
            }
        }
        
        let move: Move = decodeMove(from: move)
        
        
        let piece = nodeMap[String(move.startCell)]
        let squareWidth = self.size.width/8
        let squareHeight = self.size.height/8
        // Touch move
        // let x = touchLocation.x.rounded()
        // let y = touchLocation.y.rounded()
        let targetX = Int(move.targetCell % 10)
        let targetY = Int(move.targetCell / 10)
        let x = (squareWidth * CGFloat(targetX)) + (squareWidth/2)
        let y = (squareHeight * CGFloat(targetY)) + (squareHeight/2)
        if let spritePiece = piece as? SKSpriteNode {
            spritePiece.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 0.005))
            nodeMap.move(piece: spritePiece, to: move.targetCell)
            nodeToPiece[spritePiece]!.cellId = move.targetCell
            print("INTHIS")
        }
        counter += 1;
        if WebSocketManager.shared.inGame {
            DispatchQueue.main.async {
                self.moveHistory.append(move)
                self.sceneDelegate?.updateViewableMoveHistory(self.moveHistory)
            }
        }
    }

    // Called if something is touched within scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Gets current mouse location
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // Currently can pick up any drawn node, board cells included
        if let node = self.atPoint(touchLocation) as? SKSpriteNode {
            
            touchedNode = node
            originalLocation = node.position

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
        let touchedNodeColor = nodeToPiece[touchedNode]!.color
        if (touchedNode != nil) {
            if (WebSocketManager.shared.isWhite && touchedNodeColor == "w") || (!WebSocketManager.shared.isWhite && touchedNodeColor == "b"){
                    touchedNode?.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 0.005))
            }
        }
    }
    
    
    // Called if touch is released
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Gets current mouse location
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let squareWidth = self.size.width/8
        let squareHeight = self.size.height/8
        // Touch move
        // let x = touchLocation.x.rounded()
        // let y = touchLocation.y.rounded()
        let x_square = floor(touchLocation.x / squareWidth)
        let y_square = floor(touchLocation.y / squareHeight)
        let x = (squareWidth * CGFloat(x_square)) + (squareWidth/2)
        let y = (squareHeight * CGFloat(y_square)) + (squareHeight/2)
        let target = Int(y_square * 10 + x_square)
        //MB debug
        print("X square: \(x_square) Y square: \(y_square)")
        print("X: \(x) Y: \(y)")
        
        // Some form of the below pieceNode lock to cell idea will be required at final implementation
          if touchedNode != nil {
              
              guard let indexNode = touchedNode else { return }
              if let piece = nodeToPiece[indexNode] {
                  var moves = piece.getMoves(nodeMap: nodeMap, nodeToPiece: nodeToPiece)
                  // MB debug
                  print("Original location: \(piece.cellId)")
                  print("Valid moves: \(moves)")
                  
                  if moves.contains(target) {
                      let inCheck: Bool = false
                      let inMate: Bool = false
                      
                      let move: Move = Move(startCell: Int(touchedNode?.name ?? "")!, targetCell: target, pieceMoved: nodeToPiece[touchedNode]!, inCheck: inCheck, inMate: inMate)
                      moveHistory.append(move)
                      touchedNode?.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 0.005))
                      nodeMap.move(piece: touchedNode!, to: target)
                      nodeToPiece[touchedNode]!.cellId = target
                      
                      // Maybe include a current time as to deal with discontinuous delays in move send and receive
                      print(move.asLongAlgebraicNotation())
                      if WebSocketManager.shared.inGame {
                          performCompleteMove()
                          WebSocketManager.shared.addMessage(["type":"add_move", "game_id":WebSocketManager.shared.gameID!, "turn": turn, "move":move.asLongAlgebraicNotation()])
                          sceneDelegate?.updateViewableMoveHistory(moveHistory)
                      }
                      
                      
                      
                      // Just Spitballing on ideas for checking valid moves, I'll stop this and leave it up to you.
                      //if (nodeMap.move(piece: touchedNode, to: 11)) == false {
                      // if move invalid?
                      // Have a not so funky fresh time?
                      //}
                  }
                  else {
                      guard let name = touchedNode?.name,
                            let cellId = Int(name) else {
                          print("❌ Invalid node name")
                          return
                      }
                      let column = cellId % 10
                      let row = cellId / 10

                      let origX = CGFloat(column) * squareWidth + (squareWidth / 2)
                      let origY = CGFloat(row) * squareHeight + (squareHeight / 2)

                      print("Cell ID: \(cellId)")
                      print("origX: \(origX), origY: \(origY)")

                      touchedNode?.run(SKAction.move(to: CGPoint(x: origX, y: origY), duration: 0.005))
                  }
              }
          }
        
        // An idea of how to lock piece to a board cell center
        // pieceNode?.run(SKAction.move(to: CGPoint(x: nodesBelow.first!.position.x, y: nodesBelow.first!.position.y), duration: 0.005))
        
        
        
                
        
        
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
