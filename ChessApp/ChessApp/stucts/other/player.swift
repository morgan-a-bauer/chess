//
//  player.swift
//  ChessApp
//
//  Created by Nate on 4/7/25.
//
import UIKit
import ObjectiveC
import Foundation
import SpriteKit

class Player {
    /*Needs:
     Color
        white
        black
     Time
        pause
        switch after move finished
                touchEnded function
        base amnt of time
            editable
     isHuman
     */
    var color : String
    var isHuman : Bool
    var playerName : String
    var moveCount: Int = 0
    var turn : Bool
    var timeRemaining: Int = 4500 // 90 minutes in seconds
    var onTimerUpdate: ((Int) -> Void)?
    
    init(color: String, isHuman : Bool = true, playerName : String, turn : Bool = false) {
        self.color = color
        self.isHuman = isHuman
        self.playerName = playerName
        self.turn = turn
        
        
        //I think this is redundant and assumed to be self when made in the class? But need to double check
            //Update: the program gets mad at me if I make the timer and dont specify self declarations for everything else. I don't know why
        if turn {
            createTimer() // Only create timer for the player whose turn it is
        }
        
    }
    @objc func fireTimer() {
        // NEW TIMER CODE: Modified to count down instead of up
        if timeRemaining > 0 {
            timeRemaining -= 1
            onTimerUpdate?(timeRemaining)
            
            if timeRemaining == 0 {
                // Handle time out - can add logic for when time runs out
                print("Time's up for \(playerName)!")
            }
        }
    }
    
    var timer:Timer?
    var pausedTimer = false
    
    func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true) //creates a timer that performs the fireTimer() function every timeInterval (currently 1)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func pauseTimer() {
        timer?.invalidate() //Makes the timer stop ticking
        timer = nil //should be nil when invalidated but make sure to keep from breaking
        print("Timer paused for \(playerName)")
        pausedTimer = true
    }
    
    func unpauseTimer() {
        if timer == nil {
            createTimer()
            print("Timer resumed for \(playerName)")
            pausedTimer = false
        }
    }
    
    func startturn() {
        self.turn = true
        unpauseTimer()
    }
    
    func endturn() {
        pauseTimer()
        self.turn = false
    }
}
