//
//  UpcomingShowCollectionViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 28/04/22.
//

import UIKit
class UpcomingShowCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelShwoTime: UILabel!
    @IBOutlet weak var labelShowName: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelViewCount: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI() {
        videoImage.layer.cornerRadius = 5
        videoImage.clipsToBounds = true
        statusView.customRoundCorners(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 5)
        countView.customRoundCorners(corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 5)
        statusLabel.layer.cornerRadius = 5
        
    }
    
    func configureCell(data: RowData) {
        if let status = data.status, status == .live {
            labelStatus.text = status.status
            statusView.isHidden = false
            countView.isHidden = false
            labelViewCount.isHidden = false
            eyeImage.isHidden = false
            statusLabel.isHidden = true
        }else {
            statusLabel.isHidden = true
            statusView.isHidden = true
            countView.isHidden = true
            labelViewCount.isHidden = true
            eyeImage.isHidden = true
        }
        
        if data.status == .completed {
            statusLabel.isHidden = false
            statusLabel.text = data.status?.status
        }
        
        labelShwoTime.text = data.sessionDate.dateToString()
        labelShowName.text = data.name
        if let imageStr = data.imageUrl {
            videoImage.setKFImage(imageString: imageStr, cornerRadius: 5)
        }else{
            videoImage.image = UIImage.getPlaceholderImage()
        }
    }
     
}
