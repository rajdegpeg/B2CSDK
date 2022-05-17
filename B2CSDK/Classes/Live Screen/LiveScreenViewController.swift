//
//  LiveScreenViewController.swift
//  B2CFramework
//
//  Created by Raj Kadam on 17/05/22.
//

import UIKit
import AVFoundation
class LiveScreenViewController: B2CBaseViewController {
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelViewCount: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var countView: UIView!
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var commentTextField: TextFieldWithPadding!{
        didSet {
            let redPlaceholderText = NSAttributedString(string: "Post a Comment",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            commentTextField.attributedPlaceholder = redPlaceholderText
        }
    }
    
    var player: AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCells()
    }
    
    
    private func registerCells(){
       let cellBundle = Bundle.resourceBundle(for: Self.self)
        commentTableView.register(TableCellID.ReceiverCell, bundle: cellBundle)
        commentTableView.register(TableCellID.SenderCell, bundle: cellBundle)
        
        collectionView.register(UINib.init(nibName: CollectionCellID.CTACellID, bundle: cellBundle), forCellWithReuseIdentifier: CollectionCellID.CTACellID)
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LiveScreenViewController {
    
    func setupUI() {
        configureUI()
        hideNavigationBar()
        playVideo()
        addObserver()
    }
    
    
    func configureUI(){
        statusView.customRoundCorners(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 5)
        countView.customRoundCorners(corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 5)
        
        commentTextField.layer.cornerRadius = 10
        commentTextField.layer.borderWidth = 1
        commentTextField.layer.borderColor = UIColor.white.cgColor
        
        commentTableView.backgroundColor = .clear
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resetPlayer),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    @objc func resetPlayer() {
        player?.seek(to: CMTimeMakeWithSeconds(Float64(0), 1) )
        player?.play()
    }

    
    func playVideo() {
        let bundle = Bundle.resourceBundle(for: Self.self)
        let videoString:String? = bundle.path(forResource: "splash_video", ofType: "mp4")
        guard let unwrappedVideoPath = videoString else { return }
        player = AVPlayer(url: URL(fileURLWithPath: unwrappedVideoPath))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        player?.play()
    }
    
}

extension LiveScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = 74
        let width = 180
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellID.CTACellID, for: indexPath) as! CTACollectionViewCell
        
        return cell
    }
    
    
}

extension LiveScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 7 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.SenderCell, for: indexPath) as? SenderTableViewCell {
                cell.configureUI()
                cell.messageLabel.text = "Cupon Code ZH100 😆"
                return cell
            }else {
                return UITableViewCell()
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.ReceiverCell, for: indexPath) as? ReceiverTableViewCell {
            cell.configureUI()
            if indexPath.row == 0 {
                cell.messageLabel.text = "Hi, How Are You?"
            }
            if indexPath.row == 1 {
                cell.messageLabel.text = "Hi, How Are You? Good to See u again.."
            }
            return cell
        }else {
            return UITableViewCell()
        }
        
    }
    
    
}
