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
    
    var timer: Timer?;
    var secondsElapsed = 0;
    var gameScene: GameScene?
    weak var gameSceneActionDelegate: GameSceneActionsDelegate? // vc -> bs
    
    @IBOutlet weak var game_history: UITableView!
    @IBOutlet weak var enter_queue: UIButton!
    @IBOutlet weak var skView: SKView!
  
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
        
        // Do any additional setup after loading the view.
 

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
