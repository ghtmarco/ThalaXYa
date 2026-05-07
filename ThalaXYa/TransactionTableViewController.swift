//
//  TransactionTableViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit
import CoreData

class TransactionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var transactions: [NSManagedObject] = []
    var isAdmin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transactions"
        
        if let tv = tableView {
            tv.delegate = self
            tv.dataSource = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTransactions()
        
        if let tv = tableView {
            tv.reloadData()
        }
    }
    
    func loadTransactions() {
        let manager = CoreDataManager.shared
        
        if isAdmin {
            transactions = manager.getAllTransactions()
        } else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let currentUser = appDelegate.currentUser {
                
                appDelegate.persistentContainer.viewContext.refresh(currentUser, mergeChanges: true)
                transactions = manager.getTransactionsForUser(user: currentUser)
            } else {
                transactions = []
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? UITableViewCell else {
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
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "id_ID")
            formatter.maximumFractionDigits = 0
            detailTextLabel.text = formatter.string(from: NSNumber(value: totalPrice))
        }
        
        return cell
    }
}
