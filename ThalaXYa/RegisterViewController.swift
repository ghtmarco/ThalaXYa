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
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert("Name cannot be empty")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert("Email cannot be empty")
            return
        }
        
        guard email.contains("@"), email.contains(".") else {
            showAlert("Invalid email format")
            return
        }
        
        guard let password = passwordTextField.text, password.count >= 6 else {
            showAlert("Password must be at least 6 characters")
            return
        }
        
        let manager = CoreDataManager.shared
        
        if manager.checkUserExists(email: email) {
            showAlert("Email already registered")
            return
        }
        
        if manager.createUser(email: email, password: password, name: name, role: "buyer") {
            showAlert("Registration successful! Please login.")
            dismiss(animated: true)
        } else {
            showAlert("Registration failed. Please try again.")
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
