//
//  CategoryTableViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 28/04/22.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func registerCell(bundle: Bundle?){
        collectionView.register(UINib.init(nibName: CollectionCellID.CategoryCellID, bundle: bundle), forCellWithReuseIdentifier: CollectionCellID.CategoryCellID)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = 105
        let width = 140
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellID.CategoryCellID, for: indexPath) as! CategoryCollectionViewCell
        cell.configureUI()
        if indexPath.row % 2 == 0 {
            cell.labelCategory.text = "Comedy"
            cell.categoryImage.backgroundColor = UIColor.init(red: 237.0/255.0, green: 63.0/255.0, blue: 77.0/255.0, alpha: 1)
        }else {
            cell.labelCategory.text = "Life Style"
            cell.categoryImage.backgroundColor = UIColor.init(red: 133.0/255.0, green: 106.0/255.0, blue: 94.0/255.0, alpha: 1)
        }
        return cell
    }
    
    
}
