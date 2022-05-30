//
//  LiveScreenProtocols.swift
//  B2CSDK
//
//  Created by Raj Kadam on 20/05/22.
//

import Foundation
import UIKit

protocol LiveScreenActionProtocols {
    func buyProductAction(product: Product?)
}


// MARK: LiveScreen
protocol LiveScreenViewControllerProtocol: AnyObject {
    var viewModel: LiveScreenViewModelProtocol? { get set }
    var currentView: UIView? {get set}
    func updateUserData(user: UserDetails)
    func updateCommentsArray(comments: [ChatMessage])
    func appendNewMessage(message: ChatMessage)
    func updateViewCount(viewCount: ViewCountModel)
    func updateProduct(product: Product)
    func showError(errorString: String)
    func animateLikeView()
    
}

protocol LiveScreenViewModelProtocol: AnyObject {
    var viewController: LiveScreenViewControllerProtocol? { get set }
    func getUserData(for providerId: String)
    func getMessages(for liveSessionId: String)
    func getViewCount(for liveSessionId: String)
    func sendMessage(for liveSessionId: String, comment: String)
    //func getSessionDetails(liveSessionId: String)
    func fetchAllProducts(products: [String])
    func likeVideoAPI(for liveSessionID: String)
    func updateViewAPI(for liveSessionID: String)
    // MARK: - Socket
    func joinRoom(sessionId: String)
    func leaveRoom(sessionId: String)
}
