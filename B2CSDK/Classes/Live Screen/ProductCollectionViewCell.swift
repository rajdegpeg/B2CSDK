//
//  ProductCollectionViewCell.swift
//  B2CSDK
//
//  Created by Raj Kadam on 20/05/22.
//

import UIKit
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
        delegate?.buyProductAction(product: product)
    }
    func configureCell(data: Product) {
        self.product = data
        productName.text = data.name
        productPrice.text = "  \(data.currency ?? "") \(data.price ?? "")  "
        if let imageStr = data.image_url {
            productImage.setKFImage(imageString: imageStr, cornerRadius: 5)
        }else{
            productImage.image = UIImage.getPlaceholderImage()
        }
    }

}
