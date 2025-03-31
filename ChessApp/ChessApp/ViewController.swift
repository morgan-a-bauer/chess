//
//  ViewController.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/30/25.
//

import UIKit
import ObjectiveC
import Foundation


class ViewController: UIViewController, HomeDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var timer: Timer?;
    var secondsElapsed = 0;
    
    @IBOutlet weak var game_history: UITableView!
    @IBOutlet weak var enter_queue: UIButton!
    var gameHistoryData: [GameHistory] = [GameHistory()];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.homeDelegate = self;
        game_history.delegate = self
        game_history.dataSource = self
        game_history.rowHeight = 80;
        WebSocketManager.shared.addMessage(["type":"get_game_history", "user_id": WebSocketManager.shared.userID!])
        
        
        // Do any additional setup after loading the view.
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
    func receiveGameHistory(_ response:[GameHistory]) {
        gameHistoryData = response;
        
        DispatchQueue.main.async {
            self.game_history.reloadData()
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return gameHistoryData.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContainerTableViewCell

        // Pass data to each cell and embed a new child view controller
        let data = gameHistoryData[indexPath.row]
        print(data)
        cell.userLabel.text = data.user.username;
        cell.userOutcomeLabel.text = data.user.outcome;
        cell.opponentLabel.text = data.opponent.username;
        cell.opponentOutcomeLabel.text = data.opponent.outcome;
        cell.movesLabel.text = String(data.moves);

        return cell
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
