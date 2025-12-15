//
//  BuyerHomeViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit
import CoreData

class BuyerHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fishList: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleBalanceUpdate), name: NSNotification.Name("BalanceUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleBalanceUpdate() {
        DispatchQueue.main.async {
            self.updateBalanceDisplay()
        }
    }

    func setupUI() {
        title = "Fish Market"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        if let balanceLbl = balanceLabel {
            balanceLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            balanceLbl.textColor = .systemBlue
            balanceLbl.textAlignment = .center
        }
        
        if let userLbl = usernameLabel {
            userLbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            userLbl.textColor = .label
        }

        if let cv = collectionView {
            cv.backgroundColor = .systemBackground
            cv.showsVerticalScrollIndicator = false
            cv.delegate = self
            cv.dataSource = self
            
            if let layout = cv.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 20, right: 16)
                layout.minimumLineSpacing = 16
                layout.minimumInteritemSpacing = 16
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBalanceDisplay()
        fetchFishData()
    }
    
    func fetchFishData() {
        let manager = CoreDataManager.shared
        fishList = manager.getAllFish()
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }

    func updateBalanceDisplay() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let currentUser = appDelegate.currentUser {
            
            appDelegate.persistentContainer.viewContext.refresh(currentUser, mergeChanges: true)
            
            if let name = currentUser.value(forKey: "name") as? String {
                usernameLabel?.text = "Hi, \(name)"
            }
            
            let balance = currentUser.value(forKey: "balance") as? Double ?? 0.0
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "id_ID")
            balanceLabel?.text = formatter.string(from: NSNumber(value: balance)) ?? "Rp 0"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fishList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyerFishCell", for: indexPath) as? BuyerFishCell else {
            return UICollectionViewCell()
        }
        
        let fish = fishList[indexPath.row]
        cell.configure(with: fish)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFish = fishList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "FishDetailViewController") as? FishDetailViewController {
            detailVC.fish = selectedFish
            
            if let navigationController = self.navigationController {
                navigationController.pushViewController(detailVC, animated: true)
            } else {
                detailVC.modalPresentationStyle = .pageSheet
                present(detailVC, animated: true)
            }
        }
    }
    
    @IBAction func transactionButtonTapped(_ sender: Any) {
         
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.performLogout()
        })

        present(alert, animated: true)
    }
    
    func performLogout() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.currentUser = nil
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                    window.rootViewController = loginVC
                }, completion: nil)
                window.makeKeyAndVisible()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTransactions" {
            if let destinationVC = segue.destination as? TransactionTableViewController {
                destinationVC.isAdmin = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 16
        let paddingRight: CGFloat = 16
        
        let totalWidth = collectionView.bounds.width
        let availableWidth = totalWidth - (padding + spacing + paddingRight)
        let itemWidth = availableWidth / 2
        
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }
}
