//
//  BuyerFishCell.swift
//  ThalaXYa
//
//  Created by Rizki Ramadhan Wira Saputra on 15/12/25.
//

import UIKit
import CoreData

class BuyerFishCell: UICollectionViewCell {
    
    @IBOutlet weak var fishImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fishImageView.layer.cornerRadius = 8
        fishImageView.clipsToBounds = true
        fishImageView.contentMode = .scaleAspectFill
    }
    
    func configure(with fish: NSManagedObject) {
        nameLabel.text = fish.value(forKey: "name") as? String ?? "Unknown"
        
        if let price = fish.value(forKey: "price") as? Double {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.groupingSeparator = "."
            let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) ?? "\(Int(price))"
            priceLabel.text = "Rp. \(formattedPrice)"
        }
        
        if let weight = fish.value(forKey: "weight") as? Double {
            weightLabel.text = String(format: "%.2fKg", weight)
        }
        
        if let dateAdded = fish.value(forKey: "dateAdded") as? Date {
            dateLabel.text = dateFormatter.string(from: dateAdded)
        } else {
            dateLabel.text = "-"
        }
        
        if let imageData = fish.value(forKey: "imageData") as? Data {
            fishImageView.image = UIImage(data: imageData)
        } else {
            fishImageView.image = UIImage(systemName: "photo")
        }
    }
}
