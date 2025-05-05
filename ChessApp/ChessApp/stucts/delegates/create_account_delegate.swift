//
//  create_account_delegate.swift
//  ChessApp
//
//  Created by Jackson Butler on 5/1/25.
//

protocol CreateAccountDelegate: AnyObject {
    func didReceiveCreateAccount()
    func didReceiveCreateAccountFailure(error: String)
}
