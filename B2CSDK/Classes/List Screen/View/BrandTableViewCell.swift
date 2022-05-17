//
//  BrandTableViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 28/04/22.
//

import UIKit

class BrandTableViewCell: UITableViewCell {
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func registerCell(bundle: Bundle?){
        collectionView.register(UINib.init(nibName: CollectionCellID.BrandCellID, bundle: bundle), forCellWithReuseIdentifier: CollectionCellID.BrandCellID)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension BrandTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = 60
        let width = 100
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellID.BrandCellID, for: indexPath) as! BrandCollectionViewCell
        //cell.configureUI()
//        if indexPath.row % 2 == 0 {
//            cell.brandImage.image = UIImage.init(named: "wow")
//        }else {
//            cell.brandImage.image = UIImage.init(named: "mi")
//        }
        return cell
    }
    
    
}

