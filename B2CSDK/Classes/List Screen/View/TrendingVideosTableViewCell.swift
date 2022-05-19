//
//  TrendingVideosTableViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 28/04/22.
//

import UIKit

class TrendingVideosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trendingButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var cellDataArray: [RowData] = [RowData]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func registerCell(bundle: Bundle?){
        collectionView.register(UINib.init(nibName: CollectionCellID.TrendingCellID, bundle: bundle), forCellWithReuseIdentifier: CollectionCellID.TrendingCellID)
    }
    
    func configureCell(data: [RowData]?) {
        if let sellData = data {
            self.cellDataArray = sellData
            collectionView.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension TrendingVideosTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height
        let width = (height/5)*4
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellID.TrendingCellID, for: indexPath) as! TrendingVideoCollectionViewCell
        cell.configureUI()
        cell.configureCell(data: cellDataArray[indexPath.row])
        return cell
    }
    
    
}
