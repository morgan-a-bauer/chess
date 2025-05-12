//
//  move_decode.swift
//  ChessApp
//
//  Created by Jackson Butler on 5/9/25.
//

func decodeMoveHistory(_ CodedMoveHistory: [String]) -> MoveHistory{
    var moveHistory: MoveHistory = MoveHistory();
    var moves: [Move] = [];
    for encodedMove in CodedMoveHistory{
        print(encodedMove)
        
        let move: Move = decodeMove(from: encodedMove);
        moves.append(move);
    }
    moveHistory.moves = moves;
    return moveHistory;
}


func decodeMove(from lan: String) -> Move {
    var trimmed = lan
    var inCheck = false
    var inMate = false

    if trimmed.hasSuffix("#") {
        inMate = true
        trimmed.removeLast()
    } else if trimmed.hasSuffix("+") {
        inCheck = true
        trimmed.removeLast()
    }

    let chars = Array(trimmed)

    var pieceChar: Character
    var startCellStr = ""
    var targetCellStr = ""
    var pieceCapturedChar: Character?
    var readingCapture = false

    pieceChar = chars[0]
    var i = 1
    startCellStr.append(pieceChar)

    while i < chars.count {
        let c = chars[i]
        if c == "x" {
            readingCapture = true
            i += 1
            continue
        }
        if !readingCapture {
            startCellStr.append(c)
        } else {
            if pieceCapturedChar == nil {
                pieceCapturedChar = c
            } else {
                targetCellStr.append(c)
            }
        }
        i += 1
    }
    let startCell = Int(startCellStr)!
    let targetCell = Int(targetCellStr)!

    let pieceMoved = pieceFromChar(pieceChar, cellId: startCell)
    let pieceCaptured = pieceFromChar(pieceCapturedChar!, cellId: targetCell)

    return Move(
        startCell: startCell,
        targetCell: targetCell,
        pieceMoved: pieceMoved,
        pieceCaptured: pieceCaptured,
        inCheck: inCheck,
        inMate: inMate
    )
}
