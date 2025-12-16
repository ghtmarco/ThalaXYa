//
//  FishDetailViewController.swift
//  ThalaXYa
//
//  Created by Rizki Ramadhan Wira Saputra on 02/11/25.
//

import UIKit
import CoreData

class FishDetailViewController: UIViewController {

    @IBOutlet weak var fishImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var fish: NSManagedObject?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
        }
        
    func setupUI() {
        view.backgroundColor = .systemBackground

        guard let fish = fish else {
            return
        }

        setupStoryboardComponents(with: fish)
    }

    func setupStoryboardComponents(with fish: NSManagedObject) {
        if let imgView = fishImageView {
            imgView.layer.cornerRadius = 12
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleAspectFill
            imgView.backgroundColor = .systemGray6

            if let imageData = fish.value(forKey: "imageData") as? Data {
                imgView.image = UIImage(data: imageData)
            } else {
                imgView.image = UIImage(systemName: "photo")
                imgView.tintColor = .systemGray
            }
        }

        if let nameLbl = nameLabel {
            nameLbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            nameLbl.textColor = .label
            nameLbl.text = fish.value(forKey: "name") as? String ?? "Unknown Fish"
        }

        if let priceLbl = priceLabel {
            priceLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            priceLbl.textColor = .systemBlue
            if let price = fish.value(forKey: "price") as? Double {
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = Locale(identifier: "id_ID")
                formatter.maximumFractionDigits = 0
                priceLbl.text = formatter.string(from: NSNumber(value: price)) ?? "Rp \(Int(price))"
            }
        }

        if let weightLbl = weightLabel {
            weightLbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            weightLbl.textColor = .secondaryLabel
            if let weight = fish.value(forKey: "weight") as? Double {
                weightLbl.text = "Weight: \(weight) kg"
            }
        }

        if let stockLbl = stockLabel {
            stockLbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            if let stock = fish.value(forKey: "stock") as? Int {
                if stock > 0 {
                    stockLbl.text = "Available: \(stock) in stock"
                    stockLbl.textColor = .systemGreen
                } else {
                    stockLbl.text = "Currently Out of Stock"
                    stockLbl.textColor = .systemRed
                }
            }
        }

        if let dateLbl = dateLabel {
            dateLbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            dateLbl.textColor = .secondaryLabel
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            if let dateAdded = fish.value(forKey: "dateAdded") as? Date {
                dateLbl.text = "Added: \(dateFormatter.string(from: dateAdded))"
            } else {
                dateLbl.text = "Added: Today"
            }
        }

        if let descLbl = descriptionLabel {
            descLbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            descLbl.textColor = .secondaryLabel
            descLbl.numberOfLines = 0
            if let desc = fish.value(forKey: "desc") as? String, !desc.isEmpty {
                descLbl.text = desc
            } else {
                descLbl.text = "Fresh fish sourced directly from local fishermen. Premium quality for your culinary needs."
            }
        }
    }

    @IBAction func buyButtonTapped(_ sender: UIButton) {
        guard let fish = fish else {
            showAlert(title: "Error", message: "Fish data not available")
            return
        }

        guard let fishName = fish.value(forKey: "name") as? String,
              let fishPrice = fish.value(forKey: "price") as? Double,
              let fishWeight = fish.value(forKey: "weight") as? Double else {
            showAlert(title: "Error", message: "Invalid fish data")
            return
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let currentUser = appDelegate.currentUser else {
            showAlert(title: "Error", message: "Please login first")
            return
        }
        
        let manager = CoreDataManager.shared
        
        appDelegate.persistentContainer.viewContext.refresh(currentUser, mergeChanges: true)

        let currentBalance = currentUser.value(forKey: "balance") as? Double ?? 0.0
        
        let currentStock = fish.value(forKey: "stock") as? Int ?? 0
        if currentStock <= 0 {
            showAlert(title: "Out of Stock", message: "Sorry, this item is currently unavailable.")
            return
        }

        if currentBalance < fishPrice {
            showAlert(title: "Insufficient Balance", message: "Your balance is Rp \(Int(currentBalance)). Top up your balance first.")
            return
        }

        let alert = UIAlertController(
            title: "Confirm Purchase",
            message: "Buy \(fishName) for Rp \(Int(fishPrice))?\nYour balance: Rp \(Int(currentBalance))",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Buy", style: .default) { _ in
            self.completePurchase(fishName: fishName, fishPrice: fishPrice, fishWeight: fishWeight, buyer: currentUser, manager: manager, currentStock: currentStock)
        })

        present(alert, animated: true)
    }

    private func completePurchase(fishName: String, fishPrice: Double, fishWeight: Double, buyer: NSManagedObject, manager: CoreDataManager, currentStock: Int) {
        let currentBalance = buyer.value(forKey: "balance") as? Double ?? 0.0
        let newBalance = currentBalance - fishPrice

        if manager.updateUserBalance(user: buyer, newBalance: newBalance) {
            
            if let fishToUpdate = self.fish {
                fishToUpdate.setValue(currentStock - 1, forKey: "stock")
                _ = manager.saveContext()
            }
            
            if manager.createTransaction(
                fishName: fishName,
                fishWeight: fishWeight,
                fishPrice: fishPrice,
                quantity: 1,
                totalPrice: fishPrice,
                buyer: buyer
            ) {
                NotificationCenter.default.post(name: NSNotification.Name("BalanceUpdated"), object: nil)
                
                self.setupStoryboardComponents(with: self.fish!)
                
                showAlert(title: "Success", message: "Purchase successful! New balance: Rp \(Int(newBalance))")
            } else {
                showAlert(title: "Error", message: "Failed to record transaction")
            }
        } else {
            showAlert(title: "Error", message: "Failed to process payment")
        }
    }

    @IBAction func backButton(_ sender: UIButton) {
        goBack()
    }
    
    func goBack() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            if presentingViewController is AdminHomeViewController {
                presentingViewController?.viewWillAppear(false)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
