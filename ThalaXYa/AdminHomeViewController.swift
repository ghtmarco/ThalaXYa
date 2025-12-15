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
        title = "Admin Dashboard"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.size.width - 40) / 2
        layout.itemSize = CGSize(width: width, height: 220)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFishData()
    }
    
    func loadFishData() {
        let manager = CoreDataManager.shared
        fishList = manager.getAllFish()
        collectionView.reloadData()
    }
    
    @IBAction func addNewFishTapped(_ sender: UIButton) {
        selectedFish = nil
        performSegue(withIdentifier: "goToAddEdit", sender: self)
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fishList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdminFishCell", for: indexPath) as! AdminFishCell
        
        let fish = fishList[indexPath.row]
        
        cell.nameLabel.text = fish.value(forKey: "name") as? String ?? "Unknown"
        
        if let imageData = fish.value(forKey: "imageData") as? Data {
            cell.fishImageView.image = UIImage(data: imageData)
        } else {
            cell.fishImageView.image = UIImage(systemName: "photo")
        }
        
        cell.onEditTapped = { [weak self] in
            self?.selectedFish = fish
            self?.performSegue(withIdentifier: "goToAddEdit", sender: self)
        }
        
        cell.onDeleteTapped = { [weak self] in
            self?.showDeleteConfirmation(for: fish)
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddEdit" {
            if let destVC = segue.destination as? AddEditFishViewController {
                destVC.fishToEdit = selectedFish
            }
        }
    }
    
    func showDeleteConfirmation(for fish: NSManagedObject) {
        let alert = UIAlertController(title: "Delete Fish", message: "Are you sure you want to delete this fish?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            let manager = CoreDataManager.shared
            if manager.deleteFish(fish: fish) {
                self.loadFishData()
            }
        }))
        
        present(alert, animated: true)
    }
}
