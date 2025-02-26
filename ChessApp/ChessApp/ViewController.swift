//
//  ViewController.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/30/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var p1 = Player(color:"black", playerName:"Nate") //isHuman will be assumed to be true
    }
}

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

    
    init(color: String, isHuman : Bool = true, playerName : String, turn : Bool = false) {
        self.color = color
        self.isHuman = isHuman
        self.playerName = playerName
        self.turn = turn
        
        
        //I think this is redundant and assumed to be self when made in the class? But need to double check
            //Update: the program gets mad at me if I make the timer and dont specify self declarations for everything else. I don't know why
        createTimer()
        
    }
    @objc func fireTimer() {
        //print("Timer fired!")
        runCount += 1
        //runCount keeps track of how many seconds go by- tick interval can be lowered or raised @ timeInterval is Timer object. runCount retains its value when the timer is paused (destroyed) and unpaused (recreated)
        
        
        if runCount == 5400 { //5400 for first 90 minutes
            print()
            //Implement effect in game once first 90 minutes are up, and then the last next 30 are up
        }
        
        /*if runCount == 5 {
            pauseTimer()
            print("wait")
            print("wait")
            print("wait")
            print("wait")
            unpauseTimer()
        }*/
    }
    
    var timer:Timer?
    var pausedTimer = false
    var runCount = 0
    func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true) //creates a timer that performs the fireTimer() function every timeInterval (currently 1)
 }
    
    func pauseTimer() {
        timer?.invalidate() //Makes the timer stop ticking
        print("ideally paused")
        pausedTimer = true
    }
    func unpauseTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true) //recreate invalidated timer. Timer-affected variables like runCount are preserved. 
        pausedTimer = false
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
