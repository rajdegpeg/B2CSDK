//
//  HeaderSectionTableViewCell.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import UIKit

public class HeaderSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: RKSlidePageControl!
    
    var cellDataArray: [RowData] = [RowData]()
    var delegate: LiveScreenRedirectionProtocol?
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func registerCell(bundle: Bundle?){
        collectionView.register(UINib.init(nibName: CollectionCellID.HeaderCellID, bundle: bundle), forCellWithReuseIdentifier: CollectionCellID.HeaderCellID)
    }
    
    func configureCell(data: [RowData]?) {
        if let sellData = data {
            self.cellDataArray = sellData
            collectionView.reloadData()
        }
        pageControl.numberOfPages = cellDataArray.count
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension HeaderSectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDataArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellID.HeaderCellID, for: indexPath) as! HeaderCollectionViewCell
        cell.configureUI()
        cell.configureCell(data: cellDataArray[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = cellDataArray[indexPath.row]
        if video.status == .scheduled || video.status == .planned {
            
        }else {
            delegate?.redirectToLiveScreen(data: cellDataArray[indexPath.row])
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.progress = Double(scrollView.contentOffset.x) / Double(scrollView.frame.width)
    }
    
}
