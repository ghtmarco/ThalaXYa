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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transactions"
        loadTransactions()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTransactions()
        tableView.reloadData()
        
    }
    
    func loadTransactions() {
        transactions = []
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return transactions.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        
        return cell
        
    }

}
