//
//  bishop.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/3/25.
//

struct Bishop: BasePiece {
    
    init(){
        
    }
    
    func moveIsValid(_ destination: Cell) -> Bool {
        return true
    }
    func charRepresentation() -> String {
        return "b"
    }
}
