//
//  LoginViewController.swift
//  ChessApp
//
//  Created by Jackson Butler on 3/17/25.
//

import UIKit

class LoginViewController: UIViewController, LoginDelegate{

    
    @IBOutlet weak var username_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var login_button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.loginDelegate = self;
    }
    @IBAction func login_attempt(_ sender: Any) {
        WebSocketManager.shared.addMessage(["type":"auth", "username": username_field.text ?? "none", "password": password_field.text ?? "none"])
//        WebSocketManager.shared.receiveMessage();
    }
    func didReceiveLoginSuccess() {
        WebSocketManager.shared.username = username_field.text ?? "jackcameback";
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToHomeScreen", sender: self)
            }
        }
    
    func didReceiveLoginFailure(error: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Login Failed", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    
}

