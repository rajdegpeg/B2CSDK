//
//  TrendingVideoCollectionViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 28/04/22.
//

import UIKit

class TrendingVideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelViewCount: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var videoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI(){
        statusView.customRoundCorners(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 5)
        countView.customRoundCorners(corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 5)
    }
}
