//
//  LiveScreenVC+Delegates.swift
//  B2CSDK
//
//  Created by Raj Kadam on 24/05/22.
//

import Foundation
import Kingfisher
// MARK: - LiveScreenViewControllerProtocol
extension LiveScreenViewController: LiveScreenViewControllerProtocol {
    
    func appendNewMessage(message: ChatMessage) {
        btnSend.isUserInteractionEnabled = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateChatList(with: message)
        }
    }
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
    func updateCommentsArray(comments: [ChatMessage]) {
        messageArray = comments
        messageTableView.reloadData()
        self.scrollToBottomCell()
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

// MARK: - Live screen Action delegates
extension LiveScreenViewController: LiveScreenActionProtocols {
    func buyProductAction(product: Product?) {
        
        if let product = product, let urlString = product.purchase_link {
            if !urlString.hasPrefix("http") {
                openSocialLinks(urlString: "https://\(urlString)")
            }else{
                openSocialLinks(urlString: urlString)
            }
        }
    }
    
    func openSocialLinks(urlString: String){
        
        if let url = URL.init(string: urlString), UIApplication.shared.canOpenURL(url)
        {
            fromCTA = true
            UIApplication.shared.open(url, options: [:]) { (flag) in
                
            }
        }
    }
    
}

//MARK: SocketDelegate
extension LiveScreenViewController: SocketDelegate {
    
    /// Method to receive new chat message
    /// - Parameter chat: Denotes new chat message
    func receivedNewChatMessage(chat: ChatMessage) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateChatList(with: chat)
        }
    }
    
    /// Method to notify socket connected
    func socketConnected() {
        //presenter?.subScribeChannels(sessionId: sessionDetsils?.id ?? "")
        viewModel?.joinRoom(sessionId: screenData?.id ?? "")
    }
    
    /// Socket method to update like count
    /// - Parameter like: ViewCount
    func updateLike(like: ViewCountModel) {
//        if let emoji = "❤".emojiToImage() {
//            emojiAnimationView.animate(icon: emoji)
//        }
    }
    
    /// Socket Method to update view count
    /// - Parameter views: ViewCount
    func updateViewCount(views: ViewCountModel) {
        updateViewCount(viewCount: views)
    }
}

extension LiveScreenViewController {
    func updateChatList(with chat: ChatMessage) {
        if self.messageArray.count > 0 {
            self.messageArray.append(chat)
            self.insertRowsInTableView(indexPaths: [.init(row: (self.messageArray.count) - 1, section: 0)])
            self.scrollToBottomCell()
        } else {
            self.messageArray = [chat]
            self.messageTableView.reloadData()
        }
    }
    
    //MARK:- TableView insert/reload rows
    func insertRowsInTableView(indexPaths: [IndexPath]) {
        messageTableView.beginUpdates()
        messageTableView.insertRows(at: indexPaths, with: .bottom)
        messageTableView.endUpdates()
    }
    
    //Scroll to bottom of chat message cell
    func scrollToBottomCell(animated: Bool = true) {
        if  messageArray.count > 0 {
            let lastCellIndexPath = IndexPath(row: (messageArray.count - 1), section: 0)
            messageTableView.scrollToRow(at: lastCellIndexPath, at: .bottom, animated: animated)
        }
    }
}
