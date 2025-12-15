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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard collectionView != nil else {
            print("⚠️ collectionView is not connected in the storyboard for AdminHomeViewController")
            return
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFishData()
    }
    
    func fetchFishData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fish")
        
        do {
            fishList = try managedContext.fetch(fetchRequest)
            collectionView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fishList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FishCell", for: indexPath) as? AdminFishCell else {
                print("Unable to dequeue AdminFishCell")
                return UICollectionViewCell()
            }
            
            let fish = fishList[indexPath.row]
            cell.configure(with: fish)
            
            // 3. Logika Edit
            cell.onEditTapped = { [weak self] in
                self?.navigateToEdit(fish: fish)
            }
            
            // 4. Logika Delete
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
    
    func deleteFish(fish: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(fish)
        
        do {
            try managedContext.save()
            fetchFishData() // Refresh data setelah hapus
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
