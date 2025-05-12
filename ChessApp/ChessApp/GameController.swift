//
//  GameController.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/30/25.
//

import UIKit
import SpriteKit
import Foundation
import ObjectiveC

class GameController: UIViewController, GameDelegate, BoardToGameDelegate, GameSceneDelegate, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var altTableView: UITableView!
    
    // Player Labels
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var opponentTimerLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userTimerLabel: UILabel!

    var previousButton: UIButton?
    var move_history: MoveHistory = MoveHistory();
    
       
    var gameScene: GameScene?
    var players: [Player] = []
    //end moved new timer stuff
    //    weak var puzzleDelate: PuzzleToGameDelegate?
//    var contentKey = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.gameDelegate = self;
        
        
        opponentLabel.text = WebSocketManager.shared.opponentUsername
        userLabel.text = WebSocketManager.shared.username
        
        // ————————— Move History Initialization —————————
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 30;
        altTableView.delegate = self
        altTableView.dataSource = self
        altTableView.rowHeight = 30;
        
        
        
        // ————————— Create and Link Board —————————
        self.view.addSubview(gameView)
        // Create a scene and set it to the view
        let scene = GameScene(size: gameView.bounds.size)
        self.gameScene = scene
        // Delegate for sending data from the SKScene to parent ViewController
        scene.sceneDelegate = self
        scene.viewControllerDelegate = self
        gameView.presentScene(scene)
        // collisionCounter.text = contentKey
        
        // Optional: enable debugging info
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        
        //TIMER stuff
        
        // new TIMER code, players are created here for testing but eventually will probably be created in BoardScene
        let whitePlayer = Player(color: "white", playerName: "Player 1", turn: true)
        let blackPlayer = Player(color: "black", playerName: "Player 2")
        
        players = [whitePlayer, blackPlayer]
        scene.players = players
        if WebSocketManager.shared.inGame {
            // Update time every timer fire
            whitePlayer.onTimerUpdate = { [weak self] seconds in
                DispatchQueue.main.async {
                    self?.opponentTimerLabel.text = "\(self?.formatTime(seconds) ?? "\(seconds)")"
                }
            }
            
            blackPlayer.onTimerUpdate = { [weak self] seconds in
                DispatchQueue.main.async {
                    self?.userTimerLabel.text = "\(self?.formatTime(seconds) ?? "\(seconds)")"
                }
            }
            opponentTimerLabel.text = (formatTime(5400))
            userTimerLabel.text = (formatTime(5400))
        }
        // Create timer boxes with chosen time. This is currently hard set to 5400, but it will be a choice later.
        
//        WRITE A FUNCTION TO CONVERT STRING 90:00 -> SECONDS
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainTableView {
            altTableView.contentOffset = scrollView.contentOffset
        } else if scrollView == altTableView {
            mainTableView.contentOffset = scrollView.contentOffset
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (move_history.moves.count+1)/2
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let visibleIndexPaths = tableView.indexPathsForVisibleRows
        if tableView == mainTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath) as! MoveHistoryControllerCellMain
            
            
            // Pass data to each cell and embed a new child view controller
            let data = move_history.moves[indexPath.row*2]
            //            print("main",data)
            
            cell.turnLabel.text = "Turn: " + String(indexPath.row+1)
            cell.moveLabel.text = data.asLongAlgebraicNotation()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "alt", for: indexPath) as! MoveHistoryControllerCellAlt
            
            
            // Pass data to each cell and embed a new child view controller
            if indexPath.row*2+1 < move_history.moves.count {
                let data = move_history.moves[indexPath.row*2+1]
                //            print("main",data)
                
                cell.moveLabel.text = data.asLongAlgebraicNotation()
            } else {
                cell.moveLabel.text = ""
            }
            
            return cell
        }
    }
    
    func formatTime(_ seconds: Int) -> String {
            let minutes = seconds / 60
            let secs = seconds % 60
            return String(format: "%02d:%02d", minutes, secs)
        }
        
    //
    func didCompleteMove() {
        print("Move completed - timers have been switched")
    }

    
    func updateViewableMoveHistory(_ moveHistory: MoveHistory){
        move_history = moveHistory;
        mainTableView.reloadData()
        altTableView.reloadData()
        
        DispatchQueue.main.async {
            let index = IndexPath(row: self.altTableView.numberOfRows(inSection: 0) - 1, section: 0)
            self.altTableView.scrollToRow(at: index, at: .bottom, animated: true)
        }
    }
    
    func loadOldGame(_ CodedMoveHistory: [String], _ user: UserHistory, _ opponent: UserHistory){
        
        userTimerLabel.text = user.time_left
        opponentTimerLabel.text = opponent.time_left
        
        
        
        self.move_history = decodeMoveHistory(CodedMoveHistory);
        mainTableView.reloadData()
        altTableView.reloadData()
    }
    
    
    func handleGameEnded() {
        players[0].timer?.invalidate();
        players[0].timer = nil;
        players[1].timer?.invalidate();
        players[1].timer = nil;
        
        WebSocketManager.shared.isWhite = false;
        WebSocketManager.shared.inGame = false;
        WebSocketManager.shared.gameID = nil;
        WebSocketManager.shared.opponentConnectedToGame = false;
        WebSocketManager.shared.userConnectedToGame = false;
        WebSocketManager.shared.opponentIcon = "";
        WebSocketManager.shared.opponentUsername = "Jeremy";
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "gameToMain", sender: self)
        }
    }

    // Testing Code
    @IBAction func leaveGame(_ sender: Any) {
//        var result: String = (WebSocketManager.shared.isWhite ? "0-1" : "1-0")
        if WebSocketManager.shared.inGame {
            var result: String = "lost"
            WebSocketManager.shared.addMessage([
                "type": "end_game",
                "game_id": WebSocketManager.shared.gameID!,
                "termination": "quit",
                "result": result,
                "user_time": userTimerLabel.text!,
                "opponent_time":opponentTimerLabel.text!,
                "moves": move_history.export(),
                "move_count": move_history.moves.count
            ])
        } else {
            handleGameEnded()
        }
        
    }
    
    @IBAction func loseGame(_ sender: Any) {
//        var result: String = (WebSocketManager.shared.isWhite ? "0-1" : "1-0")
        var result: String = "lost"

        WebSocketManager.shared.addMessage([
            "type": "end_game",
            "game_id": WebSocketManager.shared.gameID!,
            "termination": "checkmate",
            "result": result,
            "user_time": userTimerLabel.text!,
            "opponent_time":opponentTimerLabel.text!,
            "moves": move_history.export(),
            "move_count": move_history.moves.count
        ])
    }
    
    @IBAction func drawGame(_ sender: Any) {
        var result: String = "draw"
        
        WebSocketManager.shared.addMessage([
            "type": "end_game",
            "game_id": WebSocketManager.shared.gameID!,
            "termination": "checkmate",
            "result": result,
            "user_time": userTimerLabel.text!,
            "opponent_time":opponentTimerLabel.text!,
            "moves": move_history.export(),
            "move_count": move_history.moves.count
        ])
    }
    
    @IBAction func winGame(_ sender: Any) {
//        var result: String = (WebSocketManager.shared.isWhite ? "1-0" : "0-1")
        var result: String = "won"
        
        WebSocketManager.shared.addMessage([
            "type": "end_game",
            "game_id": WebSocketManager.shared.gameID!,
            "termination": "checkmate",
            "result": result,
            "user_time": userTimerLabel.text!,
            "opponent_time":opponentTimerLabel.text!,
            "moves": move_history.export(),
            "move_count": move_history.moves.count
        ])
    }
}
