//
//  RegisterViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title:"Error",message:"Name cannot be empty")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title:"Error",message:"Email cannot be empty")
            return
        }
        
        guard email.contains("@"), email.contains(".") else {
            showAlert(title:"Error",message:"Invalid email format")
            return
        }
        
        guard let password = passwordTextField.text, password.count >= 6 else {
            showAlert(title:"Error",message:"Password must be at least 6 characters")
            return
        }
        
        let manager = CoreDataManager.shared
        
        if manager.checkUserExists(email: email) {
            showAlert(title:"Error",message:"Email already registered")
            return
        }
        
        if manager.createUser(email: email, password: password, name: name, role: "buyer") {
            showAlert(title: "Success", message: "Registration successful! Please login.") {
                self.dismiss(animated: true)
            }
        } else {
            showAlert(title: "Error", message: "Registration failed. Please try again.")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginLabel()
    }
    
    func setupLoginLabel() {
        guard let loginLabel = loginLabel else {
            return
        }
        loginLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped))
        loginLabel.addGestureRecognizer(tap)
    }
    
    @objc func loginLabelTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            } else {
                print("LoginViewController not found in Storyboard")
            }
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
