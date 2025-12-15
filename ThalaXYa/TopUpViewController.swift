//
//  TopUpViewController.swift
//  ThalaXYa
//
//  Created by Hush on 02/10/25.
//

import UIKit
import CoreData

class TopUpViewController: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        guard let amountTextField = amountTextField else {
            return
        }
        guard let amountText = amountTextField.text, !amountText.isEmpty else {
            showAlert("Amount cannot be empty")
            return
        }
        
        guard let amount = Double(amountText), amount > 0 else {
            showAlert("Please enter a valid amount")
            return
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let currentUser = appDelegate.currentUser {
            
            let currentBalance = currentUser.value(forKey: "balance") as? Double ?? 0.0
            let newBalance = currentBalance + amount
            
            currentUser.setValue(newBalance, forKey: "balance")
            
            let manager = CoreDataManager.shared
            if manager.updateUserBalance(user: currentUser, newBalance: newBalance) {
                let alert = UIAlertController(title: "Success", message: "Balance updated successfully!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    appDelegate.persistentContainer.viewContext.refresh(currentUser, mergeChanges: true)
                    
                    NotificationCenter.default.post(name: NSNotification.Name("BalanceUpdated"), object: nil)
                    
                    self.dismiss(animated: true)
                })
                present(alert, animated: true)
            } else {
                showAlert("Failed to update balance")
            }
        } else {
            showAlert("No user logged in")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        title = "Top Up Balance"

        view.backgroundColor = .systemBackground

        if let amountField = amountTextField {
            amountField.backgroundColor = .secondarySystemBackground
            amountField.layer.cornerRadius = 12
            amountField.layer.borderWidth = 1
            amountField.layer.borderColor = UIColor.separator.cgColor
            amountField.placeholder = "0"
            amountField.textAlignment = .center
            amountField.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            amountField.textColor = .systemBlue
            amountField.keyboardType = .numberPad
        }
    }

    func showAlert(_ message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}
