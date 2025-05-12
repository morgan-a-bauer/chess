//
//  StartViewController.swift
//  ChessApp
//
//  Created by Jackson Butler on 5/12/25.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubviewToBack(backgroundImageView)
    }
    
}

