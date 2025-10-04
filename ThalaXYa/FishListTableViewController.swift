//
//  FishListTableViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit
import CoreData

class FishListTableViewController: UITableViewController {
    
    var fishList: [NSManagedObject] = []
    var isBuyerMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fish Market"
        loadFishData()
        
        if isBuyerMode {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFishData()
        tableView.reloadData()
    }
    
    func loadFishData() {
        let manager = CoreDataManager.shared
        fishList = manager.getAllFish()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fishList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FishCell", for: indexPath)
        
        let fish = fishList[indexPath.row]
        let name = fish.value(forKey: "name") as? String ?? "Unknown"
        let weight = fish.value(forKey: "weight") as? Double ?? 0.0
        let price = fish.value(forKey: "price") as? Double ?? 0.0
        
        cell.textLabel?.text = "\(name) - \(weight)kg"
        cell.detailTextLabel?.text = String(format: "$%.2f", price)
        
        return cell
    }
    
    func showBuyAlert(for fish: NSManagedObject) {
        let fishName = fish.value(forKey: "name") as? String ?? "Fish"
        let price = fish.value(forKey: "price") as? Double ?? 0.0
        
        let alert = UIAlertController(title: "Buy \(fishName)", message: String(format: "Price: $%.2f\nEnter quantity:", price), preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Quantity"
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Buy", style: .default) { _ in
            guard let quantityText = alert.textFields?.first?.text,
                  let quantity = Int(quantityText), quantity > 0 else {
                self.showError("Invalid quantity")
                return
            }
            
            self.processPurchase(fish: fish, quantity: quantity)
        })
        
        present(alert, animated: true)
    }

    func processPurchase(fish: NSManagedObject, quantity: Int) {
        let fishName = fish.value(forKey: "name") as? String ?? "Fish"
        let fishWeight = fish.value(forKey: "weight") as? Double ?? 0.0
        let fishPrice = fish.value(forKey: "price") as? Double ?? 0.0
        let totalPrice = fishPrice * Double(quantity)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: "User")
            
            do {
                let users = try context.fetch(request)
                if let currentUser = users.first(where: { ($0.value(forKey: "role") as? String) == "buyer" }) {
                    let currentBalance = currentUser.value(forKey: "balance") as? Double ?? 0.0
                    
                    if currentBalance < totalPrice {
                        showError("Insufficient balance")
                        return
                    }
                    
                    let newBalance = currentBalance - totalPrice
                    let manager = CoreDataManager.shared
                    
                    if manager.updateUserBalance(user: currentUser, newBalance: newBalance),
                       manager.createTransaction(fishName: fishName, fishWeight: fishWeight, fishPrice: fishPrice, quantity: quantity, totalPrice: totalPrice, buyer: currentUser) {
                        showSuccess("Purchase successful!")
                    } else {
                        showError("Purchase failed")
                    }
                }
            } catch {
                showError("Error processing purchase")
            }
        }
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func showSuccess(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let fish = fishList[indexPath.row]
        
        if isBuyerMode {
            showBuyAlert(for: fish)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let editVC = storyboard.instantiateViewController(withIdentifier: "AddEditFishViewController") as? AddEditFishViewController {
                editVC.fishToEdit = fish
                navigationController?.pushViewController(editVC, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fish = fishList[indexPath.row]
            let manager = CoreDataManager.shared
            
            if manager.deleteFish(fish: fish) {
                fishList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
