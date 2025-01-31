//
//  GameController.swift
//  ChessApp
//
//  Created by Jackson Butler on 1/30/25.
//

import UIKit
import SpriteKit

class GameController: UIViewController {

    @IBOutlet weak var gameView: SKView!
//    weak var puzzleDelate: PuzzleToGameDelegate?
//    var contentKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Create a SpriteKit view
        self.view.addSubview(gameView)
        // Create a scene and set it to the view
        let scene = GameScene(size: gameView.bounds.size)
//        scene.content = contentDict[contentKey]
        
        // Delegate for sending data from the SKScene to parent ViewController
//        scene.gameDelegate = self
        
        gameView.presentScene(scene)
//        collisionCounter.text = contentKey
//        puzzleDelate?.puzzleToGameData(contentKey)
        
        // Optional: enable debugging info
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        
        
    }
}



