//
//  FishDetailViewController.swift
//  ThalaXYa
//
//  Created by Rizki Ramadhan Wira Saputra on 02/11/25.
//

import UIKit
import CoreData

class FishDetailViewController: UIViewController {

    @IBOutlet weak var fishImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var fish: NSManagedObject?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
        }
        
    func setupUI() {
        // Cek apakah ada data ikan yang dikirim?
        guard let fish = fish else {
            print("⚠️ Tidak ada data ikan yang diterima")
            return
        }
        
        // --- Set Data ke Label ---
        
        // Nama
        nameLabel.text = fish.value(forKey: "name") as? String ?? "Unknown Fish"
        
        // Harga (Format Rp)
        if let price = fish.value(forKey: "price") as? Double {
            priceLabel.text = "Rp \(Int(price))"
        }
        
        // Berat
        if let weight = fish.value(forKey: "weight") as? Double {
            weightLabel.text = "\(weight) kg"
        }
        
        // Stok
        if let stock = fish.value(forKey: "stock") as? Int {
            stockLabel.text = "Stok: \(stock)"
            
            // Opsional: Ubah warna jika stok habis
            if stock == 0 {
                stockLabel.text = "Out of Stock"
                stockLabel.textColor = .red
            }
        }
        
        // Gambar
        if let imageData = fish.value(forKey: "imageData") as? Data {
            fishImageView.image = UIImage(data: imageData)
        } else {
            fishImageView.image = UIImage(systemName: "photo") // Gambar default
        }
        
        // Styling Gambar agar rapi
        fishImageView.layer.cornerRadius = 12
        fishImageView.clipsToBounds = true
        fishImageView.contentMode = .scaleAspectFill
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = "Posted: \(dateFormatter.string(from: Date()))"
        if let desc = fish.value(forKey: "description") as? String {
            descriptionLabel.text = desc
        } else {
            descriptionLabel.text = "Segar langsung dari nelayan. Kualitas terbaik untuk masakan anda."
        }
    }
}
