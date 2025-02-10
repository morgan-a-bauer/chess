//
//  base_piece.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

// Check out protocol extensions for cool functionality
protocol BasePiece {
    func moveIsValid(_ destination: Cell) -> Bool
    func charRepresentation() -> String
}
