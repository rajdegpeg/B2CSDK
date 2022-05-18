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
        messageTableView.register(TableCellID.ReceiverCell, bundle: cellBundle)
        messageTableView.register(TableCellID.SenderCell, bundle: cellBundle)
        
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
        
        if indexPath.row == 3 {
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
