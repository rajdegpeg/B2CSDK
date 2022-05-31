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
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var nameImageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI() {
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.clipsToBounds = true
        nameImageLabel.layer.cornerRadius = nameImageLabel.frame.size.height/2
        nameImageLabel.clipsToBounds = true
        statusLabel.layer.cornerRadius = 5
    }
    
    func configureCell(data: RowData) {
        
        if data.status == .live || data.status == .completed{
            playImage.isHidden = false
        }else {
            playImage.isHidden = true
        }
        statusLabel.text = data.status?.status
        titleLabel.text = data.name
        descriptionLabel.text = data.description
        
        brandName.text = data.userName?.capitalized
        if let profileImage = data.userImage {
            nameImageLabel.isHidden = true
            userImage.isHidden = false
            userImage.setKFImage(imageString: profileImage)
        }else {
            nameImageLabel.isHidden = false
            userImage.isHidden = true
            nameImageLabel.text = brandName.text?.nameToInitials()
        }
        if let imageStr = data.imageUrl {
            videoImage.setKFImage(imageString: imageStr)
        }else{
            videoImage.image = UIImage.getPlaceholderImage()
        }
    }
}
