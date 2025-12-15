//
//  AdminFishCell.swift
//  ThalaXYa
//
//  Created by Ayonima on 12/14/25.
//

import UIKit

class AdminFishCell: UICollectionViewCell {
    
    @IBOutlet weak var fishImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var onEditTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        onEditTapped?()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        onDeleteTapped?()
    }
    
    @IBAction func Add(_ sender: Any) {
    }
}
