//
//  LiveScreenProtocols.swift
//  B2CSDK
//
//  Created by Raj Kadam on 20/05/22.
//

import Foundation
import UIKit

protocol LiveScreenActionProtocols {
    func productBuyAction(product: Product?)
}


// MARK: LiveScreen
protocol LiveScreenViewControllerProtocol: AnyObject {
    var viewModel: LiveScreenViewModelProtocol? { get set }
    var currentView: UIView? {get set}
    func updateUserData(user: UserDetails)
    func updateCommentsArray(comments: [CommentsModel])
    func updateViewCount(viewCount: ViewCountModel)
    func updateProduct(product: Product)
    func showError(errorString: String)
    
}

protocol LiveScreenViewModelProtocol: AnyObject {
    var viewController: LiveScreenViewControllerProtocol? { get set }
    func getUserData(for providerId: String)
    func getComments(for liveSessionId: String)
    func getViewCount(for liveSessionId: String)
    func postComment(for liveSessionId: String, comment: String)
    func getSessionDetails(liveSessionId: String)
}
