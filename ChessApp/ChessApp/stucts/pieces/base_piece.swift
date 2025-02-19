//
//  base_piece.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

// Check out protocol extensions for cool functionality
protocol BasePiece {
    var cellId: UInt8 { get set }

    func moveIsValid(_ destination: Cell) -> Bool
    func getMoves() -> Array<UInt8>
    func charRepresentation() -> String
}
