//
//  cell_protocol.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Cell {
    let pos: String
    let column: Character
    let rank: Int
    
    init(_ notation: String) {
        guard notation.count == 2,
            let column = notation.first,
            let rank = Int(String(notation.last!)),
            ("a"..."h").contains(column),
            (1...8).contains(rank) else {
                fatalError("Invalid Chess Notation")
        }
        self.pos = notation
        self.column = column
        self.rank = rank
        
    }
}
