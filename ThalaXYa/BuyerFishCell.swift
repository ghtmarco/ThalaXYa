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
        
        self.contentView.backgroundColor = .secondarySystemGroupedBackground
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.1
        self.layer.masksToBounds = false
    }
    
    func configure(with fish: NSManagedObject) {
        nameLabel.text = fish.value(forKey: "name") as? String ?? "Unknown"
        
        if let price = fish.value(forKey: "price") as? Double {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = Locale(identifier: "id_ID")
            numberFormatter.maximumFractionDigits = 0
            
            if let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) {
                priceLabel.text = formattedPrice
            } else {
                priceLabel.text = "Rp \(Int(price))"
            }
        }
        
        if let weight = fish.value(forKey: "weight") as? Double {
            weightLabel.text = String(format: "%.1f Kg", weight)
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
            fishImageView.tintColor = .systemGray3
        }
    }
}