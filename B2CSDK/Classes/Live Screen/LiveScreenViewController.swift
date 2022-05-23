//
//  LiveScreenViewController.swift
//  B2CFramework
//
//  Created by Raj Kadam on 17/05/22.
//
import Foundation
import UIKit
import AVFoundation
import GrowingTextView

class LiveScreenViewController: B2CBaseViewController {
    var viewModel: LiveScreenViewModelProtocol?
    var currentView: UIView?
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelViewCount: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var countView: UIView!
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var messageInputTextView: GrowingTextView!
    
    var screenData: RowData?
    var commentsArray = [CommentsModel]()
    var productList: [Product] = [Product]()
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
        configureVM()
   }
   
    func configureVM(){
        viewModel = LiveScreenViewModel()
        viewModel?.viewController = self
        currentView = self.view
        
        if let providerId = screenData?.contentProviderId {
            viewModel?.getUserData(for: providerId)
        }
        
        if let sessionId = screenData?.id {
            viewModel?.getComments(for: sessionId)
            viewModel?.getSessionDetails(liveSessionId: sessionId)
            viewModel?.getViewCount(for: sessionId)
        }
        
        
    }
    
    
    private func registerCells(){
        let cellBundle = Bundle.resourceBundle(for: Self.self)
        messageTableView.register(TableCellID.ReceiverCell, bundle: cellBundle)
        messageTableView.register(TableCellID.SenderCell, bundle: cellBundle)
        
        collectionView.register(UINib.init(nibName: CollectionCellID.ProductCellID, bundle: cellBundle), forCellWithReuseIdentifier: CollectionCellID.ProductCellID)
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        player?.seek(to: CMTimeMakeWithSeconds(Float64(0), 1) )
        player?.pause()
        removeObserver()
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
// MARK: - UI Setup
extension LiveScreenViewController {
    
    func setupUI() {
        //setupInputTextView()
        configureUI()
        hideNavigationBar()
        playVideo()
        addObserver()
    }
   /* private func setupInputTextView(){
        //automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            messageTableView.contentInsetAdjustmentBehavior = .never
            messageInputTextView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        messageInputTextView.delegate = self
        //messageInputTextView.maxLength = 440
        messageInputTextView.trimWhiteSpaceWhenEndEditing = false
        messageInputTextView.placeholder = "Post a comment"
        messageInputTextView.placeholderColor = UIColor(white: 10.8, alpha: 1.0)
        messageInputTextView.minHeight = 40.0
        messageInputTextView.maxHeight = 250.0
        messageInputTextView.backgroundColor = UIColor.clear
        messageInputTextView.layer.cornerRadius = 4.0
    }*/
    
    func configureUI(){
        statusView.customRoundCorners(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 5)
        countView.customRoundCorners(corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 5)
        
        commentTextField.layer.cornerRadius = 10
        commentTextField.layer.borderWidth = 1
        commentTextField.layer.borderColor = UIColor.white.cgColor
        commentTextField.delegate = self
        messageTableView.backgroundColor = .clear
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
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
      
        guard let videoString = screenData?.videoUrl, let videoURL = URL.init(string: videoString) else { return }
        player = AVPlayer.init(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        player?.play()
    }
    
}

// MARK: - Collection Delegate and Datasource
extension LiveScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = 84
        let width = 190
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellID.ProductCellID, for: indexPath) as! ProductCollectionViewCell
        cell.configureUI()
        cell.delegate = self
        cell.configureCell(data: productList[indexPath.row])
        return cell
    }
    
    
}

// MARK: - TableView Delegate and Datasource
extension LiveScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row == 3 {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.SenderCell, for: indexPath) as? SenderTableViewCell {
//                cell.configureUI()
//                cell.messageLabel.text = "Cupon Code ZH100 😆"
//                return cell
//            }else {
//                return UITableViewCell()
//            }
//        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.ReceiverCell, for: indexPath) as? ReceiverTableViewCell {
            cell.configureUI()
            cell.setupCellData(comment: commentsArray[indexPath.row])
            return cell
        }else {
            return UITableViewCell()
        }
        
    }
    
    
}
import Kingfisher
// MARK: - LiveScreenViewControllerProtocol
extension LiveScreenViewController: LiveScreenViewControllerProtocol {
    
    func updateProduct(product: Product) {
        if productList.count == 0 {
            productList.append(product)
        } else {
            productList = [product]
        }
        collectionView.reloadData()
    }
    
    
    func updateViewCount(viewCount: ViewCountModel)
    {
        if let count = viewCount.count {
            self.labelViewCount.text = "\(count.formatUsingAbbrevation())  "
        }
        
    }
    func updateCommentsArray(comments: [CommentsModel]) {
        commentsArray = comments
//        if commentsArray.count =
        messageTableView.reloadData()
    }
    
   
    func updateUserData(user: UserDetails) {
        
        name.text = user.firstName
        if let imageStr = user.displayPicture {
            setProfileImage(imageString: imageStr)
        }else{
            profileImage.image = UIImage(named: ImageConstants.placeholderImage)
        }
    }
    
    func showError(errorString: String) {
        showAlertView(title: AlertTitles.Error, message: errorString)
    }
    
    func setProfileImage(imageString: String) {
        let url = URL(string: imageString)
        let processor = DownsamplingImageProcessor(size: profileImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: profileImage.frame.size.height/2)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(
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

extension LiveScreenViewController: LiveScreenActionProtocols {
    func productBuyAction(product: Product?) {
        
        if let product = product, let urlString = product.purchase_link, let productUrl = URL.init(string: urlString) {
            openSocialLinks(url: productUrl)
        }
    }
    
    func openSocialLinks(url: URL){
        
        if UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:]) { (flag) in
                
            }
        }
    }
    
}

/*

// MARK: Growing TextView
extension LiveScreenViewController:  GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        messageInputTextView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        
        var inputText = messageInputTextView.text ?? ""
        inputText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)//replacingOccurrences(of: " ", with: "")
        //inputText = inputText.replacingOccurrences(of: "\n", with: "")
        
        if inputText.count == 0 { //&& text.count < 2
            btnSend.isHidden = true
            let range = text.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines)
            //string.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet)
            if range != nil || text.count == 0{
                print("whitespace found")
                btnSend.isHidden = true
                return true
            }else {
                
                if text.count > 0 {
                    btnSend.isHidden = false
                    return true
                }
                btnSend.isHidden = true
                print("whitespace not found")
                return true
            }
        }
        else if inputText.count == 1 {
            
            if text == "" {
                let updatedText = String(textView.text.dropLast())
                if updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    btnSend.isHidden = true
                    return true
                }else{
                    return true
                }
                
            }
            
        }
        btnSend.isHidden = false
        return true
    }
    
    
    
}
*/

extension LiveScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        messageInputTextView.resignFirstResponder()
        return true
    }
    
    
}
