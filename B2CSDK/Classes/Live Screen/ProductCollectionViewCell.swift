//
//  ProductCollectionViewCell.swift
//  B2CSDK
//
//  Created by Raj Kadam on 20/05/22.
//

import UIKit
import Kingfisher
class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var buyNowButton: UIButton!
    var delegate: LiveScreenActionProtocols?
    var product: Product?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI(){
        mainView.layer.cornerRadius = 8
        mainView.clipsToBounds = true
        buyNowButton.clipsToBounds = true
        buyNowButton.customRoundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 8)
        mainView.setupShadow()
    }
    
    @IBAction func productBuyAction() {
        delegate?.productBuyAction(product: product)
    }
    func configureCell(data: Product) {
        self.product = data
        productName.text = data.name
        productPrice.text = "  \(data.currency ?? "") \(data.price ?? "")  "
        if let imageStr = data.image_url {
            setVideoImage(imageString: imageStr)
        }else{
            productImage.image = UIImage.getPlaceholderImage()
        }
    }

    func setVideoImage(imageString: String) {
        let url = URL(string: imageString)
        let processor = DownsamplingImageProcessor(size: productImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 5)
        productImage.kf.indicatorType = .activity
        productImage.kf.setImage(
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
