//
//  BuyerHomeViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit
import CoreData

class BuyerHomeViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buyer Dashboard"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBalanceDisplay()
    }

    func updateBalanceDisplay() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: "User")
            
            do {
                let users = try context.fetch(request)
                if let currentUser = users.first(where: { ($0.value(forKey: "role") as? String) == "buyer" }) {
                    let balance = currentUser.value(forKey: "balance") as? Double ?? 0.0
                    balanceLabel.text = String(format: "Balance: $%.2f", balance)
                }
            } catch {
                balanceLabel.text = "Balance: $0.00"
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let fishListVC = segue.destination as? FishListTableViewController {
            fishListVC.isBuyerMode = true
        }
    }

}
