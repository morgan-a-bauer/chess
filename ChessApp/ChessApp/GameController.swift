//
//  GameController.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/30/25.
//

import UIKit
import SpriteKit

class GameController: UIViewController, BoardToSceneDelegate, GameSceneDelegate {

    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var moveHistoryScroll:
    UIScrollView!
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var opponentLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    let contentView = UIView()
    var previousButton: UIButton?
    
    
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
        
        
        // Scroll View
        setupScrollView()
        
        
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
    
    func formatTime(_ seconds: Int) -> String {
            let minutes = seconds / 60
            let secs = seconds % 60
            return String(format: "%02d:%02d", minutes, secs)
        }
        
    //
    func didCompleteMove() {
        print("Move completed - timers have been switched")
    }
        
        @IBAction func endMoveButton(_ sender: Any) {
            // NEW TIMER CODE: Call performCompleteMove on the gameScene
            // This will pause current player's timer, end their turn,
            // and start the next player's timer
            if let scene = gameView.scene as? GameScene {
                scene.performCompleteMove()
            } else {
                print("Warning: Could not access GameScene")
            }
        }
    
    func setupScrollView() {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            moveHistoryScroll.addSubview(contentView)

            // Constraints for contentView inside scrollView
            // Not Working
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: moveHistoryScroll.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: moveHistoryScroll.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: moveHistoryScroll.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: moveHistoryScroll.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: moveHistoryScroll.widthAnchor) // Vertical Scrolling
            ])
        }

    
    func updateViewableMoveHistory(_ moveHistory: MoveHistory){
        print(moveHistory.moves)
        
        // Boiler plate button for testing... Button yet to do anything
        let button = UIButton()
        button.setTitle(moveHistory.getLast()?.asLongAlgebraicNotation(), for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
                        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                        button.widthAnchor.constraint(equalToConstant: 200),
                        button.heightAnchor.constraint(equalToConstant: 50)
                    ])
        if let prev = previousButton {
            button.topAnchor.constraint(equalTo: prev.bottomAnchor, constant: 20).isActive = true
        } else {
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        }
        previousButton = button
        // Ensure last button defines the content size
//        if let lastButton = previousButton {
//            lastButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
//        }
    }
}
