//
//  AdminHomeViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit
import CoreData

class AdminHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fishList: [NSManagedObject] = []
    var selectedFish: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        title = "Admin Dashboard"

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        if let cv = collectionView {
            cv.backgroundColor = .systemBackground
            cv.showsVerticalScrollIndicator = false
        }

        guard collectionView != nil else {
            return
        }

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout from Admin Dashboard?",
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                window.rootViewController = loginVC
                window.makeKeyAndVisible()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFishData()
    }
    
    func fetchFishData() {
        let manager = CoreDataManager.shared
        fishList = manager.getAllFish()

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fishList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FishCell", for: indexPath) as? AdminFishCell else {
            return UICollectionViewCell()
        }
        
        let fish = fishList[indexPath.row]
        cell.configure(with: fish)
        
        cell.onEditTapped = { [weak self] in
            self?.navigateToEdit(fish: fish)
        }
        
        cell.onDeleteTapped = { [weak self] in
            let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self?.deleteFish(fish: fish)
            }))
            self?.present(alert, animated: true)
        }
        
        return cell
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        navigateToAdd()
    }
    
    @IBAction func transactionButtonTapped(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTransactions" {
            if let destinationVC = segue.destination as? TransactionTableViewController {
                destinationVC.isAdmin = true
            }
        }
    }
    
    func deleteFish(fish: NSManagedObject) {
        let manager = CoreDataManager.shared

        if manager.deleteFish(fish: fish) {
            fetchFishData()
        } else {
            print("Failed to delete fish")
        }
    }
    
    func navigateToAdd() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddEditFishViewController") as? AddEditFishViewController {
            vc.fishToEdit = nil
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    func navigateToEdit(fish: NSManagedObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddEditFishViewController") as? AddEditFishViewController {
            vc.fishToEdit = fish
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}