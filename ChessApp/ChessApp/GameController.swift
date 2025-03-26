//
//  GameController.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/30/25.
//

import UIKit
import SpriteKit

class GameController: UIViewController, BoardToSceneDelegate {

    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var moveHistoryScroll:
    UIScrollView!
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var opponentLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    let contentView = UIView()
    var previousButton: UIButton?
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
        
        // Delegate for sending data from the SKScene to parent ViewController
         scene.sceneDelegate = self
        
        gameView.presentScene(scene)
        // collisionCounter.text = contentKey
        // puzzleDelate?.puzzleToGameData(contentKey) // Replace with BoardToSceneDelegate
        
        // Optional: enable debugging info
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        
        
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



