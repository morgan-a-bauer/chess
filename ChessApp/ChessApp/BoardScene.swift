//
//  BoardScene.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/31/25.
//

import SpriteKit
import UIKit



class GameScene: SKScene {
    
    // Kind of "Main"
    override func didMove(to view: SKView) {
        // Build chess/checkers board
        //        board = Array(repeating: Array(repeating: boardCell(), count: Int(content!.number)), count: Int(content!.number))
        let squareWidth = self.size.width/8
        let squareHeight = self.size.height/8
        
        
        
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
}

