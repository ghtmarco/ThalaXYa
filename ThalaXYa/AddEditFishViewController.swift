//
//  AddEditFishViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit
import CoreData

class AddEditFishViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    var fishToEdit: NSManagedObject?
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert("Fish name cannot be empty")
            return
        }
        
        guard let weightText = weightTextField.text, let weight = Double(weightText), weight > 0 else {
            showAlert("Please enter a valid weight")
            return
        }
        
        guard let priceText = priceTextField.text, let price = Double(priceText), price > 0 else {
            showAlert("Please enter a valid price")
            return
        }
        
        let manager = CoreDataManager.shared
        
        if let fish = fishToEdit {
            if manager.updateFish(fish: fish, name: name, weight: weight, price: price) {
                navigationController?.popViewController(animated: true)
            } else {
                showAlert("Failed to update fish")
            }
        } else {
            if manager.createFish(name: name, weight: weight, price: price) {
                navigationController?.popViewController(animated: true)
            } else {
                showAlert("Failed to add fish")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = fishToEdit == nil ? "Add Fish" : "Edit Fish"
        
        dateTextField.text = getCurrentDate()
        dateTextField.isEnabled = false
        
        if let fish = fishToEdit {
            nameTextField.text = fish.value(forKey: "name") as? String
            if let weight = fish.value(forKey: "weight") as? Double {
                weightTextField.text = String(weight)
            }
            if let price = fish.value(forKey: "price") as? Double {
                priceTextField.text = String(price)
            }
        }
    }
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
