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

class GameController: UIViewController, GameDelegate, GameSceneDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var mainTableView: UITableView!

    @IBOutlet weak var altTableView: UITableView!
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var opponentLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!

    var previousButton: UIButton?
    var move_history: MoveHistory = MoveHistory();
    
    
    //TIMER stuff
    @IBOutlet weak var whitePlayerTimerLabel: UILabel!
    @IBOutlet weak var blackPlayerTimerLabel: UILabel!
       
    var gameScene: GameScene?
    var players: [Player] = []
    //end moved new timer stuff
    //    weak var puzzleDelate: PuzzleToGameDelegate?
//    var contentKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        opponentLabel.text = WebSocketManager.shared.opponentUsername
        userLabel.text = WebSocketManager.shared.username
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 30;
        altTableView.delegate = self
        altTableView.dataSource = self
        altTableView.rowHeight = 30;
        
        
        // Create a SpriteKit view
        self.view.addSubview(gameView)
        // Create a scene and set it to the view
        let scene = GameScene(size: gameView.bounds.size)
        self.gameScene = scene  // NEW TIMER CODE: Store reference to the scene
        
        // Delegate for sending data from the SKScene to parent ViewController
        scene.sceneDelegate = self
        scene.viewControllerDelegate = self  // NEW TIMER CODE: Set up delegate for move completion
        
        gameView.presentScene(scene)
        // collisionCounter.text = contentKey
        // puzzleDelate?.puzzleToGameData(contentKey) // Replace with BoardToSceneDelegate
        
        // Optional: enable debugging info
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        
        //TIMER stuff
        
        // new TIMER code, players are created here for testing but eventually will probably be created in BoardScene
        let whitePlayer = Player(color: "white", playerName: "Player 1", turn: true)
        let blackPlayer = Player(color: "black", playerName: "Player 2")
        
        players = [whitePlayer, blackPlayer]
        scene.players = players
        
        // Update time every timer fire
        whitePlayer.onTimerUpdate = { [weak self] seconds in
            DispatchQueue.main.async {
                self?.whitePlayerTimerLabel.text = "White: \(self?.formatTime(seconds) ?? "\(seconds)")"
            }
        }

        blackPlayer.onTimerUpdate = { [weak self] seconds in
            DispatchQueue.main.async {
                self?.blackPlayerTimerLabel.text = "Black: \(self?.formatTime(seconds) ?? "\(seconds)")"
            }
        }
        
        // Create timer boxes with chosen time. This is currently hard set to 5400, but it will be a choice later.
        whitePlayerTimerLabel.text = "White: \(formatTime(5400))"
        blackPlayerTimerLabel.text = "Black: \(formatTime(5400))"
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
            cell.moveLabel.text = data.asShortAlgebraicNotation()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "alt", for: indexPath) as! MoveHistoryControllerCellAlt
            
            
            // Pass data to each cell and embed a new child view controller
            if indexPath.row*2+1 < move_history.moves.count {
                let data = move_history.moves[indexPath.row*2+1]
                //            print("main",data)
                
                cell.moveLabel.text = data.asShortAlgebraicNotation()
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
}
