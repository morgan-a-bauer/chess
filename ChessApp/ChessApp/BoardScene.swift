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
    // Inside GameScene class in BoardScene.swift

    override func didMove(to view: SKView) {
        // If your CustomSKScene has its own didMove, and it needs to be called,
        // you would call it here. For example:
        // super.didMove(to: view)

        // 1. BUILD THE CHESS BOARD
        // -------------------------------------------------------------
        var colour: Bool // Variable to alternate square colors
        let squareWidth = self.size.width / 8 // Calculate the width of each square
        let squareHeight = self.size.height / 8 // Calculate the height of each square

        // Iterate through rows (ranks)
        for row in 0..<Int(8) {
            // Calculate the Y position for the center of the squares in the current row
            let squarePosY = (squareHeight * CGFloat(row)) + (squareHeight / 2)
            // Determine the starting color for the row
            if (row % 2 != 0) { colour = true } else { colour = false }

            // Iterate through columns (files)
            for column in 0..<Int(8) {
                // Calculate the X position for the center of the square in the current column
                let squarePosX = (squareWidth * CGFloat(column)) + (squareWidth / 2)

                // Create the SKShapeNode for the square
                let square = SKShapeNode(rectOf: CGSize(width: squareWidth, height: squareHeight))
                
                // Original logic for cellStrValue from your uploaded file
                let cellStrValue:UnicodeScalar = UnicodeScalar(column+97)!
                
                // Set the square's fill color based on the alternating pattern
                if colour {
                    square.fillColor = .white // Light square
                } else {
                    square.fillColor = .brown  // Dark square (or your chosen dark color)
                }

                // Set the square's position
                square.position = CGPoint(x: squarePosX, y: squarePosY)
                // Set zPosition to ensure squares are behind pieces (if pieces have higher zPosition)
                square.zPosition = 1
                
                // Original square naming logic from your uploaded file - UNCHANGED
                square.name = "\(String(describing: cellStrValue))\(row+1)"
                
                // Add the square to the scene
                addChild(square)

                // Flip the color for the next square in the row
                colour = !colour
            }
        }
        // -------------------------------------------------------------
        // END OF BOARD DRAWING LOGIC
        // -------------------------------------------------------------

        // 2. INITIALIZE PLAYERS (Moved OUTSIDE the board drawing loops)
        // This block now runs only ONCE after all squares are drawn.
        // --------------------------------------------------------------------
        var myDatabase = [["Nate","Goucher"],["John", "Hilliard"]]
        var p1 = Player(color:"white",playerName:myDatabase[0][0], turn:true)
        var p2 = Player(color:"black",playerName:myDatabase[1][0])
        // Assign to the GameScene's 'players' property (self.players)
        self.players = [p1,p2]
        // --------------------------------------------------------------------
        // END OF PLAYER INITIALIZATION
        // --------------------------------------------------------------------
                
        // 3. TEST FEN GENERATION (Moved OUTSIDE the board drawing loops)
        // This block also now runs only ONCE after players are initialized.
        // --------------------------------------------------------------------
        setupTestBoardState() // Populate `testLogicalBoard` and FEN state variables

        let generatedFen = generateFEN() // Call your FEN generation function

        // Print the result to the console.
        print("------------------------------------------------------")
        print("FEN GENERATION TEST:") // Removed "(Loop Iteration)"
        print("Generated FEN for test state: \(generatedFen)")
        print("Expected FEN (e.g., for 1.e4 e5): rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2")
        print("------------------------------------------------------")
        // --------------------------------------------------------------------
        // END OF FEN GENERATION TEST
        // --------------------------------------------------------------------
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
    
    // 5/6 added code

    // Add this private property to hold our hardcoded board state for testing
    private var testLogicalBoard: [String: (fenChar: Character, pieceType: BasePiece.Type?, isWhite: Bool)] = [:]

    // Keep the game state properties we added earlier. We'll set them for our test.
    var canWhiteCastleKingSide: Bool = true
    var canWhiteCastleQueenSide: Bool = true
    var canBlackCastleKingSide: Bool = true
    var canBlackCastleQueenSide: Bool = true
    var enPassantTargetSquare: String? = nil
    var halfMoveClock: Int = 0
    var fullMoveNumber: Int = 2 // After "1. e4 e5", it's start of move 2
    var activePlayerColor: String = "w" // White's turn

    // You can call this in didMove(to view: SKView) for setup during testing
    func setupTestBoardState() {
        // Clear any previous state
        testLogicalBoard.removeAll()

        // Standard starting pieces (condensed for brevity, only pieces relevant to 1.e4 e5 are shown)
        // White pieces
        testLogicalBoard["e2"] = (fenChar: "P", pieceType: Pawn.self, isWhite: true) // Original position of e-pawn
        // ... other white pieces like King, Queen, Rooks for castling ...
        testLogicalBoard["e1"] = (fenChar: "K", pieceType: King.self, isWhite: true)
        testLogicalBoard["a1"] = (fenChar: "R", pieceType: Rook.self, isWhite: true)
        testLogicalBoard["h1"] = (fenChar: "R", pieceType: Rook.self, isWhite: true)
        // ... other white pawns ...
        for file in ["a", "b", "c", "d", "f", "g", "h"] {
            testLogicalBoard["\(file)2"] = (fenChar: "P", pieceType: Pawn.self, isWhite: true)
        }
         testLogicalBoard["b1"] = (fenChar: "N", pieceType: Knight.self, isWhite: true)
         testLogicalBoard["g1"] = (fenChar: "N", pieceType: Knight.self, isWhite: true)
         testLogicalBoard["c1"] = (fenChar: "B", pieceType: Bishop.self, isWhite: true)
         testLogicalBoard["f1"] = (fenChar: "B", pieceType: Bishop.self, isWhite: true)
         testLogicalBoard["d1"] = (fenChar: "Q", pieceType: Queen.self, isWhite: true)


        // Black pieces
        testLogicalBoard["e7"] = (fenChar: "p", pieceType: Pawn.self, isWhite: false) // Original position of e-pawn
        // ... other black pieces ...
        testLogicalBoard["e8"] = (fenChar: "k", pieceType: King.self, isWhite: false)
        testLogicalBoard["a8"] = (fenChar: "r", pieceType: Rook.self, isWhite: false)
        testLogicalBoard["h8"] = (fenChar: "r", pieceType: Rook.self, isWhite: false)
        for file in ["a", "b", "c", "d", "f", "g", "h"] {
            testLogicalBoard["\(file)7"] = (fenChar: "p", pieceType: Pawn.self, isWhite: false)
        }
        testLogicalBoard["b8"] = (fenChar: "n", pieceType: Knight.self, isWhite: false)
        testLogicalBoard["g8"] = (fenChar: "n", pieceType: Knight.self, isWhite: false)
        testLogicalBoard["c8"] = (fenChar: "b", pieceType: Bishop.self, isWhite: false)
        testLogicalBoard["f8"] = (fenChar: "b", pieceType: Bishop.self, isWhite: false)
        testLogicalBoard["d8"] = (fenChar: "q", pieceType: Queen.self, isWhite: false)


        // --- Simulate the board after "1. e4 e5" ---
        // White moves e2-e4
        testLogicalBoard["e2"] = nil // e2 is now empty
        testLogicalBoard["e4"] = (fenChar: "P", pieceType: Pawn.self, isWhite: true) // White Pawn on e4

        // Black moves e7-e5
        testLogicalBoard["e7"] = nil // e7 is now empty
        testLogicalBoard["e5"] = (fenChar: "p", pieceType: Pawn.self, isWhite: false) // Black Pawn on e5

        // Set FEN state variables for this specific board state (after 1. e4 e5)
        activePlayerColor = "w" // White's turn next
        canWhiteCastleKingSide = true // Assuming King and h1 Rook haven't moved
        canWhiteCastleQueenSide = true // Assuming King and a1 Rook haven't moved
        canBlackCastleKingSide = true // Assuming King and h8 Rook haven't moved
        canBlackCastleQueenSide = true // Assuming King and a8 Rook haven't moved
        enPassantTargetSquare = nil // No en passant target after e5 (unless previous move was e.g. d5 creating e.p. on e6)
                                    // For simplicity, let's assume no immediate en passant.
        halfMoveClock = 0 // Reset on pawn moves
        fullMoveNumber = 2 // This will be the start of White's 2nd move.
    }

    // Modify getPieceInfo to use our testLogicalBoard
    // This function returns the FEN character directly for simplicity in this test setup.
    func getPieceFENChar(at squareNotation: String) -> Character? {
        if let pieceData = testLogicalBoard[squareNotation] {
            return pieceData.fenChar
        }
        return nil
    }

    func generateFEN() -> String {
        var fen = ""
        var emptyCount = 0

        // 1. Piece Placement
        for rank in (1...8).reversed() { // Iterate ranks 8 down to 1
            for fileCharValue in UnicodeScalar("a").value...UnicodeScalar("h").value { // Iterate files 'a' to 'h'
                let fileChar = String(UnicodeScalar(fileCharValue)!)
                let squareNotation = fileChar + String(rank)

                if let pieceFenChar = getPieceFENChar(at: squareNotation) {
                    // Piece exists
                    if emptyCount > 0 {
                        fen += String(emptyCount)
                        emptyCount = 0
                    }
                    fen += String(pieceFenChar)
                } else {
                    // Square is empty
                    emptyCount += 1
                }
            } // End files loop

            // After each rank, append remaining empty count if any
            if emptyCount > 0 {
                fen += String(emptyCount)
                emptyCount = 0
            }

            // Add rank separator "/"
            if rank > 1 {
                fen += "/"
            }
        } // End ranks loop

        // 2. Active Color
        fen += " " + activePlayerColor // Use the hardcoded activePlayerColor

        // 3. Castling Availability
        var castlingString = ""
        if canWhiteCastleKingSide { castlingString += "K" }
        if canWhiteCastleQueenSide { castlingString += "Q" }
        if canBlackCastleKingSide { castlingString += "k" }
        if canBlackCastleQueenSide { castlingString += "q" }
        fen += " " + (castlingString.isEmpty ? "-" : castlingString)

        // 4. En Passant Target Square
        fen += " " + (enPassantTargetSquare ?? "-")

        // 5. Halfmove Clock
        fen += " " + String(halfMoveClock)

        // 6. Fullmove Number
        fen += " " + String(fullMoveNumber)

        return fen
    }
    
}
