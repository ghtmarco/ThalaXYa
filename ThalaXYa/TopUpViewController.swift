//
//  TopUpViewController.swift
//  ThalaXYa
//
//  Created by Hush on 02/10/25.
//

import UIKit

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
