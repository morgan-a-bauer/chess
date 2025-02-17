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
        print("program online")
        var p1 = Player(color:"black", playerName:"Nate")
        print(p1.color)
        print(Date())
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

    
    init(color: String, isHuman : Bool = true, playerName : String) {
        self.color = color
        self.isHuman = isHuman
        self.playerName = playerName
        createTimer()
        
    }
    @objc func fireTimer() {
        print("Timer fired!")
        runCount += 1
        
        
        if runCount == 4500 { //4500 for first 90 minutes
            print("first 90 minutes up")
        }
        
        if runCount == 5 {
            pauseTimer()
            print("wait")
            print("wait")
            print("wait")
            print("wait")
            unpauseTimer()
        }
    }
    var timer:Timer?
    var pausedTimer = false
    var runCount = 0
    func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
 }
    
    func pauseTimer() {
        timer?.invalidate()
        print("ideally paused")
        pausedTimer = true
    }
    func unpauseTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        pausedTimer = false
    }
}
