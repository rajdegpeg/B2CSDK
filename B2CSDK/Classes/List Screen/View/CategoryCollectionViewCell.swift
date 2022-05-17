//
//  CategoryCollectionViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 28/04/22.
//

import UIKit

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
    
}
