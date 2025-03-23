//
//  handler_response.swift
//  ChessApp
//
//  Created by Jackson Butler on 3/19/25.
//

struct HandlerResponse {
    let listenForMessage: Bool;
    let isMove: Bool;
    let hasData: Bool;
    let data : Any?;
    let successful: Bool;
    let errorMessage: String?;
    
    init(listenForMessage: Bool=false, isMove: Bool=false, hasData: Bool=false, data:Any?="", successful: Bool=false, errorMessage: String?="") {
        self.listenForMessage = listenForMessage
        self.isMove = isMove
        self.hasData = hasData
        self.data = data
        self.successful = successful
        self.errorMessage = errorMessage
    }
}
