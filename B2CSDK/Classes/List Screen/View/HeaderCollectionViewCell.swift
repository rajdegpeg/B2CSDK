//
//  HeaderCollectionViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import UIKit
import Kingfisher
class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI() {
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.clipsToBounds = true
    }
    
    func configureCell(data: RowData) {
        
        titleLabel.text = data.name
        descriptionLabel.text = data.description
        
        if let imageStr = data.imageUrl {
            setProfileImage(imageString: imageStr)
        }
    }
    
    func setProfileImage(imageString: String) {
        let url = URL(string: imageString)
        let processor = DownsamplingImageProcessor(size: videoImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        videoImage.kf.indicatorType = .activity
        videoImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
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
