//
//  TrendingVideoCollectionViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 28/04/22.
//

import UIKit
import Kingfisher
class TrendingVideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelViewCount: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var videoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI(){
        statusView.customRoundCorners(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 5)
        countView.customRoundCorners(corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 5)
        videoImage.layer.cornerRadius = 5
    }
    
    func configureCell(data: RowData) {
        
        if let status = data.status, status.lowercased() == "live" {
            labelStatus.text = data.status
            statusView.isHidden = false
            countView.isHidden = false
            labelViewCount.isHidden = false
            eyeImage.isHidden = false
        }else {
            statusView.isHidden = true
            countView.isHidden = true
            labelViewCount.isHidden = true
            eyeImage.isHidden = true
        }
        
        if let imageStr = data.imageUrl {
            setVideoImage(imageString: imageStr)
        }else{
            videoImage.image = UIImage(named: ImageConstants.placeholderImage)
        }
    }
    
    
    func setVideoImage(imageString: String) {
        let url = URL(string: imageString)
        let processor = DownsamplingImageProcessor(size: videoImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 5)
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
