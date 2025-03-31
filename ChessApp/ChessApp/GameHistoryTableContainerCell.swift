//
//  GameHistoryTableCell.swift
//  ChessApp
//
//  Created by Jackson Butler on 3/27/25.
//

import UIKit

class ContainerTableViewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var userOutcomeLabel: UILabel!
    @IBOutlet weak var opponentOutcomeLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    
    
    func configure(with data: GameHistory, parent: UIViewController) {
        userLabel.text = data.user.username;
        userOutcomeLabel.text = data.user.outcome;
        opponentLabel.text = data.opponent.username;
        opponentOutcomeLabel.text = data.opponent.outcome;
        movesLabel.text = String(data.moves);
        print("Configured Successfully")
    }
}
