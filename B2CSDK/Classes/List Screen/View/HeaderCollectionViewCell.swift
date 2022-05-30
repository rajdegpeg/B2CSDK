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
        
        statusLabel.text = data.status?.status
        titleLabel.text = data.name
        descriptionLabel.text = data.description
        
        brandName.text = data.userName?.capitalized
        if let profileImage = data.userImage {
            nameImageLabel.isHidden = true
            userImage.isHidden = false
            setProfileImage(imageString: profileImage)
        }else {
            nameImageLabel.isHidden = false
            userImage.isHidden = true
            nameImageLabel.text = brandName.text?.nameToInitials()
        }
        if let imageStr = data.imageUrl {
            setVideoImage(imageString: imageStr)
        }else{
            videoImage.image = UIImage.getPlaceholderImage()
        }
    }
    
    func setProfileImage(imageString: String) {
        let url = URL(string: imageString)
        let processor = DownsamplingImageProcessor(size: userImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        userImage.kf.indicatorType = .activity
        userImage.kf.setImage(
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
    
    func setVideoImage(imageString: String) {
        let url = URL(string: imageString)
        let processor = DownsamplingImageProcessor(size: videoImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        videoImage.kf.indicatorType = .activity
        videoImage.kf.setImage(
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
