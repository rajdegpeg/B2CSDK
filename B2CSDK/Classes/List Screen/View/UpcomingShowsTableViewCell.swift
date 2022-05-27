//
//  UpcomingShowsTableViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 28/04/22.
//

import UIKit

class UpcomingShowsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var upcomingShowButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var cellDataArray: [RowData] = [RowData]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func registerCell(bundle: Bundle?){
        collectionView.register(UINib.init(nibName: CollectionCellID.UpcomingShowCellID, bundle: bundle), forCellWithReuseIdentifier: CollectionCellID.UpcomingShowCellID)
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

extension UpcomingShowsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = 180
        let width = 180
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellID.UpcomingShowCellID, for: indexPath) as! UpcomingShowCollectionViewCell
        cell.configureUI()
        cell.configureCell(data: cellDataArray[indexPath.row])
        return cell
    }
    
    
}

