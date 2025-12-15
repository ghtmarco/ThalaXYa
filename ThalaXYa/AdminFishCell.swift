//
//  AdminFishCell.swift
//  ThalaXYa
//
//  Created by Hush on 12/12/25.
//

import UIKit
import CoreData

class AdminFishCell: UICollectionViewCell {
    
    @IBOutlet weak var fishImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var onEditTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
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
            fishImageView.contentMode = .scaleAspectFill
            fishImageView.clipsToBounds = true
            fishImageView.layer.cornerRadius = 8
        }
        
        if let dateLabel = dateLabel {
            if let dateAdded = fish.value(forKey: "dateAdded") as? Date {
                dateLabel.text = dateFormatter.string(from: dateAdded)
            } else {
                dateLabel.text = "-"
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
