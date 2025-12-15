//
//  TransactionTableViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit
import CoreData

class TransactionTableViewController: UITableViewController {
    
    var transactions: [NSManagedObject] = []
    var isAdmin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transactions"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTransactions()
        tableView.reloadData()
    }
    
    func loadTransactions() {
        let manager = CoreDataManager.shared
        
        if isAdmin {
            transactions = manager.getAllTransactions()
        } else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSManagedObject>(entityName: "User")
                
                do {
                    let users = try context.fetch(request)
                    if let currentUser = users.first(where: { ($0.value(forKey: "role") as? String) == "buyer" }) {
                        transactions = manager.getTransactionsForUser(user: currentUser)
                    }
                } catch {
                    print("Error loading user")
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? UITableViewCell else {
            print("Unable to dequeue UITableViewCell")
            return UITableViewCell()
        }
        
        let transaction = transactions[indexPath.row]
        let fishName = transaction.value(forKey: "fishName") as? String ?? "Unknown"
        let quantity = transaction.value(forKey: "quantity") as? Int16 ?? 0
        let totalPrice = transaction.value(forKey: "totalPrice") as? Double ?? 0.0
        
        if let textLabel = cell.textLabel {
            textLabel.text = "\(fishName) x\(quantity)"
        }
        
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = String(format: "$%.2f", totalPrice)
        }
        
        return cell
    }
}
