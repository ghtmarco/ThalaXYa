//
//  FishListTableViewController.swift
//  ThalaXYa
//
//  Created by Hush on 30/09/25.
//

import UIKit
import CoreData

class FishListTableViewController: UITableViewController {
    
    var fishList: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fish Market"
        loadFishData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFishData()
        tableView.reloadData()
    }
    
    func loadFishData() {
        let manager = CoreDataManager.shared
        fishList = manager.getAllFish()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fishList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FishCell", for: indexPath)
        
        let fish = fishList[indexPath.row]
        let name = fish.value(forKey: "name") as? String ?? "Unknown"
        let weight = fish.value(forKey: "weight") as? Double ?? 0.0
        let price = fish.value(forKey: "price") as? Double ?? 0.0
        
        cell.textLabel?.text = "\(name) - \(weight)kg"
        cell.detailTextLabel?.text = String(format: "$%.2f", price)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let fish = fishList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editVC = storyboard.instantiateViewController(withIdentifier: "AddEditFishViewController") as? AddEditFishViewController {
            editVC.fishToEdit = fish
            navigationController?.pushViewController(editVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fish = fishList[indexPath.row]
            let manager = CoreDataManager.shared
            
            if manager.deleteFish(fish: fish) {
                fishList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
