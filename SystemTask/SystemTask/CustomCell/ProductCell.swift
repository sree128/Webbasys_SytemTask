//
//  ProductCell.swift
//  SystemTask
//
//  Created by Kanchireddy sreelatha on 08/07/24.
//

import UIKit

class ProductCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductCell"
    @IBOutlet weak var imgVU: UIImageView!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
   
    
  
    
    func configure(with product: Post) {
        notesLabel.text = product.notes
        descriptionLabel.text = product.description
        // Load the first attachment as image
        if let imageUrl = product.attachments?.first?.url {
            self.loadImg(urlstring: imageUrl)
        }
    }
    func loadImg(urlstring: String){
        
        if let url = URL(string: urlstring) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.imgVU.image = image
                   
                }
            }
            
            task.resume()
        }
    }
}

