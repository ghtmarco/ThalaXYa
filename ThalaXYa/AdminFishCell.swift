//
//  AdminFishCell.swift
//  ThalaXYa
//
//  Created by Ayonima on 12/14/25.
//

import UIKit
import CoreData

class AdminFishCell: UICollectionViewCell {
    
    @IBOutlet weak var fishImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var onEditTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    func configure(with fish: NSManagedObject) {
        if let nameLabel = nameLabel {
            nameLabel.text = fish.value(forKey: "name") as? String
        }
        
        if let fishImageView = fishImageView {
            if let imageData = fish.value(forKey: "imageData") as? Data {
                fishImageView.image = UIImage(data: imageData)
            } else {
                fishImageView.image = UIImage(systemName: "photo")
            }
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        onEditTapped?()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        onDeleteTapped?()
    }
    
}
