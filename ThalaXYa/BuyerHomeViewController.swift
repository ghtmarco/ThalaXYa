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
        
        // Cek koneksi collectionView
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
    
    // MARK: - Fetch Data Logic
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

    // MARK: - Balance Logic
    func updateBalanceDisplay() {
        guard let balanceLabel = balanceLabel else { return }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: "User")
            
            do {
                let users = try context.fetch(request)
                if let currentUser = users.first(where: { ($0.value(forKey: "role") as? String) == "buyer" }) {
                    let balance = currentUser.value(forKey: "balance") as? Double ?? 0.0
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.groupingSeparator = "."
                    let formattedBalance = formatter.string(from: NSNumber(value: balance)) ?? "\(Int(balance))"
                    
                    balanceLabel.text = "Rp. \(formattedBalance)"
                }
            } catch {
                balanceLabel.text = "Rp. 0"
            }
        }
    }
    
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fishList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyerFishCell", for: indexPath) as? BuyerFishCell else {
            return UICollectionViewCell()
        }
        
        let fish = fishList[indexPath.row]
        
        // --- Manual Setup (Agar tidak error 'value has no member configure') ---
        cell.nameLabel.text = fish.value(forKey: "name") as? String
        
        if let price = fish.value(forKey: "price") as? Double {
            cell.priceLabel.text = "Rp \(Int(price))"
        }
        
        if let imageData = fish.value(forKey: "imageData") as? Data {
            cell.fishImageView.image = UIImage(data: imageData)
        } else {
            cell.fishImageView.image = UIImage(systemName: "photo")
        }
        
        // Optional: Set date label jika ada
        cell.dateLabel.text = "Available"
        
        return cell
    }
    
    // MARK: - CollectionView Delegate (Action Klik)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("✅ Cell di baris \(indexPath.row) ditekan!") // Debugging
        
        // 1. Ambil data ikan yang diklik
        let selectedFish = fishList[indexPath.row]
        
        // 2. Siapkan Detail Page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "FishDetailViewController") as? FishDetailViewController {
            
            // 3. Kirim Data
            detailVC.fish = selectedFish
            
            // 4. LOGIKA NAVIGASI AMAN (Hybrid)
            if let navigationController = self.navigationController {
                // Jika ada Navigation Controller, pakai Push (Geser)
                navigationController.pushViewController(detailVC, animated: true)
            } else {
                // Jika tidak ada (karena login pakai present), pakai Present (Muncul dari bawah)
                // Opsional: Pakai .pageSheet agar user bisa swipe close
                detailVC.modalPresentationStyle = .pageSheet
                present(detailVC, animated: true, completion: nil)
            }
        } else {
            print("❌ Gagal menemukan FishDetailViewController dengan ID tersebut di Storyboard")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let fishListVC = segue.destination as? FishListTableViewController {
            fishListVC.isBuyerMode = true
        }
    }
}
