//
//  HeaderCollectionViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var placeholderImage: UIImageView!
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

}
