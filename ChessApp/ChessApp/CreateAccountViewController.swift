//
//  CreateAccountViewController.swift
//  ChessApp
//
//  Created by Jackson Butler on 5/1/25.
//

import UIKit

class CreateAccountViewController: UIViewController, CreateAccountDelegate{

    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var username_field: UITextField!
    @IBOutlet weak var first_name_field: UITextField!
    @IBOutlet weak var last_name_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var confirm_password_field: UITextField!
    @IBOutlet weak var create_account_button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.createAccountDelegate = self;
    }
    @IBAction func create_account_attempt(_ sender: Any) {
        WebSocketManager.shared.addMessage(["type":"create_account", "username": username_field.text ?? "none",
            "email": email_field.text ?? "none",
            "elo": 600,
            "first_name": first_name_field.text ?? "none",
            "last_name": last_name_field.text ?? "none",
            "password": password_field.text ?? "none",])
    }
    
    func didReceiveCreateAccount() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToLoginScreen", sender: self)
        }
    }
    
    func didReceiveCreateAccountFailure(error: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Create Account", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    
}




