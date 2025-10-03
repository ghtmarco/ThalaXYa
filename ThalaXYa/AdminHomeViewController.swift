//
//  AdminHomeViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit

class AdminHomeViewController: UIViewController {
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Admin Dashboard"
    }
}
