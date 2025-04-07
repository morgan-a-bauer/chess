//
//  move.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Move {
    let startCell: Cell;
    let targetCell: Cell;
    let pieceMoved: BasePiece;
    let pieceCaptured: BasePiece?;
    let inCheck: Bool;
    let inMate: Bool;
    
    func asShortAlgebraicNotation() -> String {
//         \(pieceMoved.charRepresentation())\(pieceCaptured != nil ? "x" : "") \(targetCell.pos)
        return String(startCell.cell) + String(targetCell.cell)
    }
    
    func asLongAlgebraicNotation() -> String {
        return ""
    }
}
