//
//  BuyerFishCell.swift
//  ThalaXYa
//
//  Created by Rizki Ramadhan Wira Saputra on 15/12/25.
//

import UIKit

class BuyerFishCell: UICollectionViewCell {
    
    @IBOutlet weak var fishImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Styling agar cantik
            fishImageView.layer.cornerRadius = 8
            fishImageView.clipsToBounds = true
            fishImageView.contentMode = .scaleAspectFill
        }
    
}
