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
    @IBOutlet weak var videoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI() {
        videoImage.layer.cornerRadius = 5
        videoImage.clipsToBounds = true
        statusView.customRoundCorners(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 5)
        countView.customRoundCorners(corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 5)
    }
    
}
