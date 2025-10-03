//
//  LoginViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert("Email cannot be empty")
            return
        }
        
        guard email.contains("@"), email.contains(".") else {
            showAlert("Invalid email format")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert("Password cannot be empty")
            return
        }
        
        let manager = CoreDataManager.shared
        
        if let user = manager.loginUser(email: email, password: password) {
            let role = user.value(forKey: "role") as? String ?? "buyer"
            
            if role == "admin" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let adminVC = storyboard.instantiateViewController(withIdentifier: "AdminHomeViewController") as? AdminHomeViewController {
                    navigationController?.pushViewController(adminVC, animated: true)
                }
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let buyerVC = storyboard.instantiateViewController(withIdentifier: "BuyerHomeViewController") as? BuyerHomeViewController {
                    navigationController?.pushViewController(buyerVC, animated: true)
                }
            }
        } else {
            showAlert("Invalid email or password")
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdminAccount()
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func AdminAccount() {
        let manager = CoreDataManager.shared
        if !manager.checkUserExists(email: "admin@fish.com") {
            _ = manager.createUser(email: "admin@fish.com", password: "admin123", name: "Admin", role: "admin")
            print("Admin account created")
        }
    }
}
