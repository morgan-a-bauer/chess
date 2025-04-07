//
//  ViewController.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/30/25.
//

import UIKit
import ObjectiveC
import Foundation
import SpriteKit

protocol GameSceneActionsDelegate: AnyObject { //VC command to BS
    func performCompleteMove()
}
protocol GameSceneDelegate: AnyObject { //BS response certification to VC
    func didCompleteMove()
}

class ViewController: UIViewController, HomeDelegate, GameSceneDelegate{
    
    var timer: Timer?;
    var secondsElapsed = 0;
    var gameScene: GameScene?
    weak var gameSceneActionDelegate: GameSceneActionsDelegate? // vc -> bs
    
    @IBOutlet weak var enter_queue: UIButton!
    @IBOutlet weak var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: viewDidLoad started")
        WebSocketManager.shared.homeDelegate = self;
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        self.gameSceneActionDelegate = scene
        scene.viewControllerDelegate = self
        //print("--- viewDidLoad: Delegate assigned! gameSceneActionDelegate is nil? \(self.gameSceneActionDelegate == nil)")
        skView.presentScene(scene)
        
        
//        enter_queue.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        // Do any additional setup after loading the view.

        var p0s = Player(color:"white", playerName:"Nate")
        //isHuman will be assumed to be true
        var whitePlayer = p0s
        whitePlayer.onTimerUpdate = { [weak self] seconds in
            DispatchQueue.main.async {
                self?.whitePlayerTimerLabel.text = "White: \(self?.formatTime(seconds) ?? "\(seconds)")"
            }
        }
 

//        var p1 = Player(color:"black", playerName:"Nate") //isHuman will be assumed to be true
    }
    
    
    @IBAction func enterGameQueue(_ sender: Any) {
        enter_queue.setTitleColor(.gray, for: .highlighted)
        WebSocketManager.shared.addMessage(["type":"enter_game_queue", "user_id": WebSocketManager.shared.userID!])
    }
    func enteredGameQueue() {
        DispatchQueue.main.async { [weak self] in
                self?.startTimer()
            }
    }
    func matchFound() {
        WebSocketManager.shared.addMessage(["type":"join_game", "game_id": WebSocketManager.shared.gameID!, "user_id": WebSocketManager.shared.userID!])
    }
    
    func joinedGame() {
        // bug where this is sometimes not called, I think the response is getting eated by the opponent joined and by the time the next receive message occurs it is already missed...
        if (WebSocketManager.shared.userConnectedToGame &&  WebSocketManager.shared.opponentConnectedToGame){
            timer?.invalidate() //Makes the timer stop ticking
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToGameBoard", sender: self)
            }
        }
        
    }
    
    
    @IBOutlet weak var whitePlayerTimerLabel: UILabel!
    
    @IBAction func endMoveButton(_ sender: Any) {
        print("debug: button pressed")
        if gameSceneActionDelegate == nil {
            print("Warning: gameSceneActionDelegate is nil")
            return
        }
        gameSceneActionDelegate?.performCompleteMove()
    }
    
    func didCompleteMove() {
        print("didCompleteMove called")
    }
    
    
    @objc func startTimer() {
        self.enter_queue.setTitle("In Queue: \(self.secondsElapsed)s", for: .normal)
        timer?.invalidate()
        secondsElapsed = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true);
        RunLoop.main.add(timer!, forMode: .common)

        }
    @objc func updateTime() {
        print(secondsElapsed)
            secondsElapsed += 1
            updateButtonTitle()
        
        }

    func updateButtonTitle() {
        DispatchQueue.main.async {
            self.enter_queue.setTitle("In Queue: \(self.secondsElapsed)s", for: .normal)
        }
    }
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
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
