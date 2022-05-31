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
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelViewCount: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var countView: UIView!
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var likeAnimationView: EmojiAnimationView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var messageInputTextView: GrowingTextView!
    @IBOutlet weak var inputTextContainerView: UIView!
    
    var PRODUCT_CELL_HEIGHT: CGFloat = 90
    var screenData: RowData?
    var messageArray = [ChatMessage]()
    var productList: [Product] = [Product]()
    var fromCTA = false
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
        fromCTA = false
   }
   
    func configureVM(){
        viewModel = LiveScreenViewModel()
        viewModel?.viewController = self
        currentView = self.view
        
        if let providerId = screenData?.contentProviderId {
            viewModel?.getUserData(for: providerId)
        }
        
        if let sessionId = screenData?.id {
            viewModel?.getMessages(for: sessionId)
            //viewModel?.getSessionDetails(liveSessionId: sessionId)
            viewModel?.getViewCount(for: sessionId)
            viewModel?.updateViewAPI(for: sessionId)
        }
        if let products = screenData?.products {
            viewModel?.fetchAllProducts(products: products)
            collectionViewHeightConstraint.constant = PRODUCT_CELL_HEIGHT
        }else{
            collectionViewHeightConstraint.constant = 0
        }
        
        
    }
    
    
    private func registerCells(){
        let cellBundle = Bundle.resourceBundle(for: Self.self)
        messageTableView.register(TableCellID.ReceiverCell, bundle: cellBundle)
        messageTableView.register(TableCellID.SenderCell, bundle: cellBundle)
        
        collectionView.register(UINib.init(nibName: CollectionCellID.ProductCellID, bundle: cellBundle), forCellWithReuseIdentifier: CollectionCellID.ProductCellID)
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        player?.seek(to: .zero)
        player?.pause()
        removeObserver()
        viewModel?.leaveRoom(sessionId: screenData?.id ?? "")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessageAction(_ sender: UIButton) {
        viewModel?.sendMessage(for: screenData?.id ?? "", comment: messageInputTextView.text ?? "")
        messageInputTextView.text = ""
        btnSend.isHidden = true
        btnSend.isUserInteractionEnabled = false
    }
    
    @IBAction func shareAction()
    {
        let stringDate = screenData?.sessionDate.dateToString() ?? ""
        let message = "Hey join this event:\(screenData?.name ?? "")\nOn \(stringDate)\n"
        guard let urlStr = screenData?.videoUrl, let url = URL.init(string: urlStr) else {
            showAlertView(title: AlertTitles.Error, message: "Video URL not found!")
            return
        }
        let objectsToShare = [message, url] as [Any]
        self.showSharePopoup(shareObject: objectsToShare)
    }
    
    @IBAction func likeAction(_ sender: UIButton)
    {
        if let sessionId = screenData?.id {
            viewModel?.likeVideoAPI(for: sessionId)
        }
    }
    
    @IBAction func bagAction(_ sender: UIButton)
    {
        closeButtonAction(sender)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)

    }
    
    @objc func didReceiveForegroundNotification() {
       player?.play()
        
    }
    
    @objc func didReceiveBackgroundNotification() {
       player?.pause()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.pause()
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
        setupInputTextView()
        configureUI()
        setUpSocketIO()
        hideNavigationBar()
        addObserver()
        
    }
    
    /// Method to setup socket connection
    func setUpSocketIO() {
        Socket_IOManager.shared.connect()
        Socket_IOManager.shared.liveStreamViewControllerDelegate = self
    }
    
   private func setupInputTextView(){
        //automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            messageTableView.contentInsetAdjustmentBehavior = .never
            messageInputTextView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        messageInputTextView.delegate = self
        messageInputTextView.trimWhiteSpaceWhenEndEditing = false
        messageInputTextView.placeholder = "Post a Comment"
        messageInputTextView.placeholderColor = UIColor(white: 10.8, alpha: 1.0)
        messageInputTextView.minHeight = 34.0
        messageInputTextView.maxHeight = 160.0
        messageInputTextView.backgroundColor = UIColor.clear
        
       messageInputTextView.textColor = .white
       messageInputTextView.font = B2CFonts.semiBoldFont(size: 16)
       
       inputTextContainerView.layer.cornerRadius = 10.0
       inputTextContainerView.layer.borderWidth = 1
       inputTextContainerView.layer.borderColor = UIColor.white.cgColor
       inputTextContainerView.backgroundColor = UIColor.clear
       
    }
    
    func configureUI(){
        statusView.customRoundCorners(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 5)
        countView.customRoundCorners(corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 5)
        commentTextField.isHidden = true
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
        player?.seek(to: .zero)
        player?.play()
    }
    
    
    func playVideo() {
      //screenData?.videoUrl
        //let videoString = "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
        //let videoString = "https://d3t9ogvkwmi4es.cloudfront.net/live/l3sdmv/index.m3u8"
        
        guard let videoString = screenData?.videoUrl, let videoURL = URL.init(string: videoString) else { return }
        //let videoURL = URL.init(fileURLWithPath: videoString)
        player = AVPlayer.init(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
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
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let message = messageArray[indexPath.row]
        
        if message.userId == B2CUserDefaults.getUserId() {
            // Sender message cell
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.SenderCell, for: indexPath) as? SenderTableViewCell {
                cell.configureUI()
                cell.setupCellData(message: messageArray[indexPath.row])
                return cell
            }else {
                return UITableViewCell()
            }
        }else {
            // Receiver Cell
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.ReceiverCell, for: indexPath) as? ReceiverTableViewCell {
                cell.configureUI()
                cell.setupCellData(message: messageArray[indexPath.row])
                return cell
            }else {
                return UITableViewCell()
            }
        }
        
        
    }
    
    
}



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
                    btnSend.isUserInteractionEnabled = true
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
        btnSend.isUserInteractionEnabled = true
        btnSend.isHidden = false
        return true
    }
    
    
    
}

extension LiveScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        commentTextField.resignFirstResponder()
        return true
    }
    
    
}
