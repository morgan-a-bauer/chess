//
//  move.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Move {
    let startCell: Int;
    let targetCell: Int;
    let pieceMoved: BasePiece;
    let pieceCaptured: BasePiece?;
    let inCheck: Bool;
    let inMate: Bool;
    
    init(startCell: Int=0, targetCell: Int=0, pieceMoved: BasePiece=EmptyPiece(cellId: 0), pieceCapturedId: Int=0, pieceCaptured: BasePiece=EmptyPiece(cellId: 0), inCheck: Bool=false, inMate: Bool=false) {
        self.startCell = startCell
        self.targetCell = targetCell
        self.pieceMoved = pieceMoved
        self.pieceCaptured = pieceCaptured
        self.inCheck = inCheck
        self.inMate = inMate
    }
    
    func asShortAlgebraicNotation() -> String {
//         \(pieceMoved.charRepresentation())\(pieceCaptured != nil ? "x" : "") \(targetCell.pos)
        return String(startCell) + String(targetCell)
    }
    
    func asLongAlgebraicNotation() -> String {
        return String(pieceMoved.charRepresentation()) + String(startCell) +
               (pieceCaptured != nil ? "x"+String(pieceCaptured!.charRepresentation()) : "") +
               String(targetCell) + (inCheck ? "+" : "") + (inMate ? "#" : "")
    }
}
