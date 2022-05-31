//
//  CategoryCollectionViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 28/04/22.
//

import UIKit
import Kingfisher
class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI() {
        categoryImage.layer.cornerRadius = 5
        categoryImage.clipsToBounds = true
    }
    
    func configureCell(data: RowData) {
        
        labelCategory.text = data.name        
        if let imageStr = data.imageUrl {
            categoryImage.setKFImage(imageString: imageStr, cornerRadius: 5)
        }else{
            categoryImage.image = UIImage.getPlaceholderImage()
        }
    }
}
