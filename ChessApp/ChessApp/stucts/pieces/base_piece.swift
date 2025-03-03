//
//  base_piece.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

// Check out protocol extensions for cool functionality
protocol BasePiece {
    var cellId: Int { get set }

    func moveIsValid(_ destination: Cell) -> Bool
    func getMoves() -> Array<Int>
    func charRepresentation() -> String
}
