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
            setCategoryImage(imageString: imageStr)
        }else{
            categoryImage.image = UIImage.getPlaceholderImage()
        }
    }
    
    func setCategoryImage(imageString: String) {
        let url = URL(string: imageString)
        let processor = DownsamplingImageProcessor(size: categoryImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 5)
        categoryImage.kf.indicatorType = .activity
        categoryImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: ImageConstants.placeholderImage),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
}
