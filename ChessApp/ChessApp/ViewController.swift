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

class ViewController: UIViewController, HomeDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var historyReceived = false;
    var inQueue: Bool = false;
    var timer: Timer?;
    var secondsElapsed = 0;
    var gameScene: GameScene?;
    weak var gameSceneActionDelegate: GameSceneActionsDelegate? // vc -> bs
    weak var gameControllerDelegate: GameDelegate?;
    
    @IBOutlet weak var game_history: UITableView!
    @IBOutlet weak var enter_queue: UIButton!
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var elo_button: UIButton!
    @IBOutlet weak var profile_button: UIButton!
    
    var gameHistoryData: [GameHistory] = [GameHistory()];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: viewDidLoad started")
        WebSocketManager.shared.homeDelegate = self;
        
//        enter_queue.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
      
        game_history.delegate = self
        game_history.dataSource = self
        game_history.rowHeight = 80;
        WebSocketManager.shared.addMessage(["type":"get_game_history", "user_id": WebSocketManager.shared.userID!])
        
        enter_queue.setTitleColor(.gray, for: .highlighted)
        // Do any additional setup after loading the view.
        profile_button.setTitle(WebSocketManager.shared.username, for: .normal) 
 

    }
    
    
    @IBAction func enterGameQueue(_ sender: Any) {
        if !inQueue {
            WebSocketManager.shared.addMessage(["type":"enter_game_queue", "user_id": WebSocketManager.shared.userID!, "time_control": "15|10"])
        } else {
            WebSocketManager.shared.addMessage(["type":"leave_game_queue", "user_id": WebSocketManager.shared.userID!, "time_control": "15|10"])
        }
    }
    
    func enteredGameQueue() {
        DispatchQueue.main.async { [weak self] in
            print("joined")
            self?.inQueue = true
            self?.startTimer()
        }
    }
    
    func leftGameQueue() {
        DispatchQueue.main.async { [weak self] in
            print("left");
            self?.inQueue = false;
            self?.timer?.invalidate();
            self?.timer = nil;
            self?.secondsElapsed = 0;
            self?.enter_queue.setTitle("Enter Queue", for: .normal)
            self?.enter_queue.setTitleColor(.black, for: .normal)
        }
    }
    
    func matchFound() {
        WebSocketManager.shared.addMessage(["type":"join_game", "game_id": WebSocketManager.shared.gameID!, "user_id": WebSocketManager.shared.userID!])
    }
    
    func joinedGame() {
        // bug where this is sometimes not called, I think the response is getting eated by the opponent joined and by the time the next receive message occurs it is already missed...
        if (WebSocketManager.shared.userConnectedToGame &&  WebSocketManager.shared.opponentConnectedToGame){
            DispatchQueue.main.async { [weak self] in
                WebSocketManager.shared.inGame = true;
                self?.inQueue = false;
                self?.timer?.invalidate();
                self?.timer = nil;
                self?.secondsElapsed = 0;
                self?.enter_queue.setTitle("Enter Queue", for: .normal)
                self?.enter_queue.setTitleColor(.black, for: .normal)
                self?.performSegue(withIdentifier: "goToGameBoard", sender: self)
            }
        }
    }
    
    func receiveGameHistory(_ response:[GameHistory]) {
        historyReceived = true;
        gameHistoryData = response;
        
        DispatchQueue.main.async {
            self.game_history.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return gameHistoryData.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard historyReceived else {
            // Return an empty/default cell if data hasn't been received yet
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContainerTableViewCell

        // Pass data to each cell and embed a new child view controller
        let data = gameHistoryData[indexPath.row]
        print(data)
        cell.userLabel.text = data.user.username;
        cell.userOutcomeLabel.text = data.user.outcome;
        cell.opponentLabel.text = data.opponent.username;
        cell.opponentOutcomeLabel.text = data.opponent.outcome;
        cell.movesLabel.text = String(data.game.moves.split(separator: " ").count);

        return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = gameHistoryData[indexPath.row]
        print("User tapped game: \(selectedGame.user.username) vs \(selectedGame.opponent.username)")
        
        WebSocketManager.shared.isWhite = selectedGame.user.is_white;
        WebSocketManager.shared.inGame = false;
        WebSocketManager.shared.gameID = nil;
        WebSocketManager.shared.opponentConnectedToGame = false;
        WebSocketManager.shared.userConnectedToGame = true;
        WebSocketManager.shared.opponentIcon = "";
        WebSocketManager.shared.opponentUsername = selectedGame.opponent.username;
        
        
        performSegue(withIdentifier: "goToGameBoard", sender: self)
        gameControllerDelegate?.loadOldGame(selectedGame.game.moves.split(separator: " ").map(String.init), selectedGame.user, selectedGame.opponent)
        // Example: push a detail view controller or perform segue
        // performSegue(withIdentifier: "goToGameDetail", sender: selectedGame)
    }
    
    
    
    @objc func startTimer() {
        self.enter_queue.setTitle("In Queue: \(self.secondsElapsed)s", for: .normal)
        timer?.invalidate()
        secondsElapsed = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true);
        RunLoop.main.add(timer!, forMode: .common)

        }
    @objc func updateTime() {
//        print(secondsElapsed)
            secondsElapsed += 1
            updateButtonTitle()
        }

    func updateButtonTitle() {
        DispatchQueue.main.async {
            self.enter_queue.setTitle("In Queue: \(self.secondsElapsed)s", for: .normal)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameBoard",
           let gameVC = segue.destination as? GameController {
            self.gameControllerDelegate = gameVC  // store ref so you can call delegate methods
        }
    }
}

