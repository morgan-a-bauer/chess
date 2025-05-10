//
//  base_piece_extension.swift
//  ChessApp
//
//  Created by Jackson Butler on 5/9/25.
//

func pieceFromChar(_ c: Character, cellId: Int) -> BasePiece {
    switch c.lowercased() {
    case "k": return King(cellId: cellId)
    case "q": return Queen(cellId: cellId)
    case "r": return Rook(cellId: cellId)
    case "b": return Bishop(cellId: cellId)
    case "n": return Knight(cellId: cellId)
    case "p": return Pawn(cellId: cellId)
    default:  return EmptyPiece(cellId: cellId)
    }
}
