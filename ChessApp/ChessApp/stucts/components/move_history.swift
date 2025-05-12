//
//  move_history.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct MoveHistory {
    var moves: [Move] = []
    
    mutating func append(_ move: Move) {
        self.moves.append(move)
    }
    
    func getLast() -> Move? {
        return self.moves.last
    }
    
    func export() -> String {
        var exportString: String = ""
        for move in self.moves {
            exportString += move.asLongAlgebraicNotation() + " "
        }
        return exportString
    }
    // When in button form and clicked change board to be at this point in history...
}
