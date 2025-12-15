//
//  AddEditFishViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit
import CoreData

class AddEditFishViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var fishImageView: UIImageView!
    
    var fishToEdit: NSManagedObject?
    
    @IBAction func uploadImageTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            fishImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            fishImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
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
        
        // Validasi input Stock (Integer)
        guard let stockText = stockTextField.text, let stock = Int(stockText), stock >= 0 else {
            showAlert("Please enter a valid stock amount")
            return
        }
        
        let imageData = fishImageView.image?.jpegData(compressionQuality: 0.8)
        let manager = CoreDataManager.shared
        
        if let fish = fishToEdit {
            if manager.updateFish(fish: fish, name: name, weight: weight, price: price, stock: stock, imageData: imageData) {
                navigationController?.popViewController(animated: true)
            } else {
                showAlert("Failed to update fish")
            }
        } else {
            if manager.createFish(name: name, weight: weight, price: price, stock: stock, imageData: imageData) {
                navigationController?.popViewController(animated: true)
            } else {
                showAlert("Failed to add fish")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = fishToEdit == nil ? "Add Fish" : "Edit Fish"
        
        setupImageView()
        
        if let fish = fishToEdit {
            nameTextField.text = fish.value(forKey: "name") as? String
            
            if let weight = fish.value(forKey: "weight") as? Double {
                weightTextField.text = String(weight)
            }
            if let price = fish.value(forKey: "price") as? Double {
                priceTextField.text = String(price)
            }
            
            // Ambil data stock dari database
            if let stock = fish.value(forKey: "stock") as? Int {
                stockTextField.text = String(stock)
            } else {
                stockTextField.text = "0"
            }
            
            if let imageData = fish.value(forKey: "imageData") as? Data {
                fishImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    func setupImageView() {
        fishImageView.layer.cornerRadius = 10
        fishImageView.layer.borderWidth = 1
        fishImageView.layer.borderColor = UIColor.lightGray.cgColor
        fishImageView.clipsToBounds = true
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
