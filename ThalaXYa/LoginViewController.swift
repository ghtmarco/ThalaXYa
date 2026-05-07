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
    @IBOutlet weak var registerLabel: UILabel!
    
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
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.currentUser = user
            }
            
            let role = user.value(forKey: "role") as? String ?? "buyer"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if role == "admin" {
                if let navController = storyboard.instantiateViewController(withIdentifier: "AdminNavController") as? UINavigationController {
                    navController.modalPresentationStyle = .fullScreen
                    present(navController, animated: true)
                }
            } else {
                if let buyerVC = storyboard.instantiateViewController(withIdentifier: "BuyerHomeViewController") as? BuyerHomeViewController {
                    buyerVC.modalPresentationStyle = .fullScreen
                    present(buyerVC, animated: true)
                }
            }
        } else {
            showAlert("Invalid email or password")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        AdminAccount()
        setupRegisterLabel()
    }

    func setupUI() {


        if let emailField = emailTextField {
            emailField.backgroundColor = .secondarySystemBackground
            emailField.layer.cornerRadius = 8
            emailField.layer.borderWidth = 1
            emailField.layer.borderColor = UIColor.separator.cgColor
            emailField.placeholder = "Email Address"
            emailField.keyboardType = .emailAddress
            emailField.autocapitalizationType = .none
            emailField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }

        if let passwordField = passwordTextField {
            passwordField.backgroundColor = .secondarySystemBackground
            passwordField.layer.cornerRadius = 8
            passwordField.layer.borderWidth = 1
            passwordField.layer.borderColor = UIColor.separator.cgColor
            passwordField.placeholder = "Password"
            passwordField.isSecureTextEntry = true
            passwordField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    func setupRegisterLabel() {
        guard let registerLabel = registerLabel else {
            return
        }
        registerLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(registerLabelTapped))
        registerLabel.addGestureRecognizer(tap)
    }
    
    @objc func registerLabelTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
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
        }
    }
}
