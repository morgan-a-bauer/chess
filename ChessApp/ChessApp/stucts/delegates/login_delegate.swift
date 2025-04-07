//
//  login_delegate.swift
//  ChessApp
//
//  Created by Jackson Butler on 3/23/25.
//

protocol LoginDelegate: AnyObject {
    func didReceiveLoginSuccess()
    func didReceiveLoginFailure(error: String)
}
