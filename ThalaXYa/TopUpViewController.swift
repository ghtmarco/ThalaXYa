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
        guard let amountText = amountTextField.text, !amountText.isEmpty else {
            showAlert("Amount cannot be empty")
            return
        }
        
        guard let amount = Double(amountText), amount > 0 else {
            showAlert("Please enter a valid amount")
            return
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: "User")
            
            do {
                let users = try context.fetch(request)
                if let currentUser = users.first(where: { ($0.value(forKey: "role") as? String) == "buyer" }) {
                    let currentBalance = currentUser.value(forKey: "balance") as? Double ?? 0.0
                    let newBalance = currentBalance + amount
                    
                    let manager = CoreDataManager.shared
                    if manager.updateUserBalance(user: currentUser, newBalance: newBalance) {
                        let alert = UIAlertController(title: "Success", message: "Balance updated successfully!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                            self.dismiss(animated: true)
                        })
                        present(alert, animated: true)
                    } else {
                        showAlert("Failed to update balance")
                    }
                }
            } catch {
                showAlert("Error updating balance")
            }
        }
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
