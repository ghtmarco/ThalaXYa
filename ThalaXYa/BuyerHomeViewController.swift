//
//  BuyerHomeViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit

class BuyerHomeViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buyer Dashboard"
        updateBalanceDisplay()
    }
    
    func updateBalanceDisplay() {
        
        balanceLabel.text = "Balance: $0.00"
        
    }

}
