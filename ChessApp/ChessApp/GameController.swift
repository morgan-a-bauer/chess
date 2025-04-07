//
//  GameController.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/30/25.
//

import UIKit
import SpriteKit

class GameController: UIViewController, BoardToSceneDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var mainTableView: UITableView!

    @IBOutlet weak var altTableView: UITableView!
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var opponentLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!

    let contentView = UIView()
    var previousButton: UIButton?
    var move_history: MoveHistory = MoveHistory();
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
        
        // Delegate for sending data from the SKScene to parent ViewController
         scene.sceneDelegate = self
        
        gameView.presentScene(scene)
        // collisionCounter.text = contentKey
        // puzzleDelate?.puzzleToGameData(contentKey) // Replace with BoardToSceneDelegate
        
        // Optional: enable debugging info
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        
        
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
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "alt", for: indexPath) as! MoveHistoryControllerCellAlt
            
            
            if (move_history.moves.count-1 >= indexPath.row*2+1) {
                // Pass data to each cell and embed a new child view controller
//                
//                let minIndexPath = visibleIndexPaths?.min { $0.row < $1.row }
//                let maxIndexPath = visibleIndexPaths?.max { $0.row < $1.row }
                let data = move_history.moves[indexPath.row*2+1]
                print(indexPath.row*2+1, indexPath.row)
//                print("alt", move_history.moves.count, indexPath.row*2+1,data)
                
                cell.moveLabel.text = data.asShortAlgebraicNotation()
            }
            return cell
    
        }

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



