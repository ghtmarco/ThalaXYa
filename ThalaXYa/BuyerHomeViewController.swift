//
//  BuyerHomeViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit
import CoreData

class BuyerHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var balanceLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var fishList: [NSManagedObject] = []
    
    override func viewDidLoad() {
            super.viewDidLoad()
            title = "Buyer Dashboard"
            
            if collectionView != nil {
                collectionView.delegate = self
                collectionView.dataSource = self
            } else {
                print("⚠️ ERROR: collectionView belum disambungkan di Storyboard!")
            }
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBalanceDisplay()
        fetchFishData()
    }
    
    func fetchFishData() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fish")
            
            do {
                fishList = try managedContext.fetch(fetchRequest)
                collectionView?.reloadData()
            } catch let error as NSError {
                print("Could not fetch fish. \(error), \(error.userInfo)")
            }
        }

    func updateBalanceDisplay() {
        guard let balanceLabel = balanceLabel else {
            print("⚠️ balanceLabel is not connected in the storyboard for BuyerHomeViewController")
            return
        }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return fishList.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            // Gunakan Identifier "BuyerFishCell" sesuai settingan Storyboard
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyerFishCell", for: indexPath) as? BuyerFishCell else {
                return UICollectionViewCell()
            }
            
            let fish = fishList[indexPath.row]
            
            // Set Nama
            cell.nameLabel.text = fish.value(forKey: "name") as? String
            
            // Set Harga
            if let price = fish.value(forKey: "price") as? Double {
                cell.priceLabel.text = "Rp \(Int(price))"
            }
            
            // Set Gambar
            if let imageData = fish.value(forKey: "imageData") as? Data {
                cell.fishImageView.image = UIImage(data: imageData)
            } else {
                cell.fishImageView.image = UIImage(systemName: "photo")
            }
            
            cell.dateLabel.text = "Available"
            
            return cell
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let fishListVC = segue.destination as? FishListTableViewController {
            fishListVC.isBuyerMode = true
        }
    }

}
