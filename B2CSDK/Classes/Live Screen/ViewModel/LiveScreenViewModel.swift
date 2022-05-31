//
//  LiveScreenViewModel.swift
//  B2CSDK
//
//  Created by Raj Kadam on 19/05/22.
//

import Foundation
import UIKit
import ObjectMapper
import Alamofire
final class LiveScreenViewModel: LiveScreenViewModelProtocol {
    
    var viewController: LiveScreenViewControllerProtocol?
    
    func getUserData(for providerId: String) {
        if NetworkManager.isConnectedToInternet {
            var filter = UserFilter.init()
            let param = filter.createUserFilter(id: providerId)
            
            UIUtils.showHUD(view: viewController?.currentView)
            LiveScreenService().getUserDetails(param: param) { [weak self] user, error in
                guard let self = self else { return }
                UIUtils.hideHUD(view: self.viewController?.currentView)
                if let user = user, user.count > 0 {
                    print("User", user[0].email)
                    print("User", user[0])
                    self.viewController?.updateUserData(user: user[0])
                } else {
                    self.viewController?.showError(errorString: error?.message ?? "Something went wrong")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }
    }
    
    // MARK: - Session Details
    func getSessionDetails(liveSessionId: String){
        if NetworkManager.isConnectedToInternet {
            
            UIUtils.showHUD(view: viewController?.currentView)
            LiveScreenService().getSessionDetails(for: liveSessionId) { [weak self] session, error in
                guard let self = self else { return }
                UIUtils.hideHUD(view: self.viewController?.currentView)
                if let liveSession = session, let products = liveSession.products{
                    print("Session Detials", liveSession)
                    self.fetchAllProducts(products: products)
                    
                } else {
                    //self.viewController?.showError(errorString: error?.message ?? "Something went wrong")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }
    }
   
    // MARK: - Get All Messages
    func getMessages(for liveSessionId: String) {
        if NetworkManager.isConnectedToInternet {
            var filter = CommentsFilter.init()
            let param = filter.createFilter(id: liveSessionId)
            
            UIUtils.showHUD(view: viewController?.currentView)
            LiveScreenService().getAllMessages(param: param) { [weak self] messages, error in
                guard let self = self else { return }
                UIUtils.hideHUD(view: self.viewController?.currentView)
                if let messagesArray = messages, messagesArray.count > 0 {
                    print("Comments", messagesArray)
                    self.viewController?.updateCommentsArray(comments: messagesArray)
                } else {
                    //self.viewController?.showError(errorString: error?.message ?? "Something went wrong")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }

    }
    
    // MARK: - Post Message
    func sendMessage(for liveSessionId: String, comment: String) {
        if NetworkManager.isConnectedToInternet {
            let param = createSendMessageRequest(sessionId: liveSessionId, message: comment)
            
            //UIUtils.showHUD(view: viewController?.currentView)
            LiveScreenService().sendMessage(param: param) { [weak self] result, error in
                guard let self = self else { return }
                //UIUtils.hideHUD(view: self.viewController?.currentView)
                if let result = result{
                    print("Message Sent successfully", result)
                    self.sendMessageThroughSocket(request: param)
                    if let message = self.getChatMessageObject(req: param) {
                        self.viewController?.appendNewMessage(message: message)
                    }
                } else {
                    
                    self.viewController?.showError(errorString: error?.message ?? "Something went wrong")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }

    }
    
    func getChatMessageObject(req: [String:Any]) -> ChatMessage? {
       if let chatMessage = Mapper<ChatMessage>().map(JSON: req) {
         return chatMessage
       }else {
           return nil
       }
    }
    
    func createSendMessageRequest(sessionId: String, message: String) -> [String: Any]{
        //"username": B2CUserDefaults.getUserName(),
        let date = Date.init()
        let currentTime = date.serverRequestDateString()
        let req = ["time_stamp": currentTime, "userId": B2CUserDefaults.getUserName(), "message": message, "liveSessionId": sessionId]
        return req as [String : Any] //["data": req]
    }
    
    // MARK: - Get ViewCount
    func getViewCount(for liveSessionId: String) {
        if NetworkManager.isConnectedToInternet {
            var filter = ViewCountFilter.init()
            let param = filter.createFilter(id: liveSessionId)
            
            UIUtils.showHUD(view: viewController?.currentView)
            LiveScreenService().fetchViewCount(param: param) { [weak self] viewCount, error in
                guard let self = self else { return }
                UIUtils.hideHUD(view: self.viewController?.currentView)
                if let vcount = viewCount, let count = vcount.count{
                    print("view Count", count)
                    let req = self.createViewCountObject(sessionId: liveSessionId, count: count)
                   self.sendMessageThroughSocket(name: Socket_IOManager.Events.viewCount.emitterName,request: req)
                    self.viewController?.updateViewCount(viewCount: vcount)
                } else {
                    
                    self.viewController?.showError(errorString: error?.message ?? "Something went wrong")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }

    }
    
    // MARK: - Get All Products
    func fetchAllProducts(products: [String]) {
        if NetworkManager.isConnectedToInternet {
            products.forEach { product in
                LiveScreenService().fetchProduct(by: product) { [weak self] result, error in
                    guard let self = self else { return }
                    if let product = result {
                        self.viewController?.updateProduct(product: product)
                    }
                }
            }
        } else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }
    }

    // MARK: - Post Like
    func likeVideoAPI(for liveSessionID: String) {
        if NetworkManager.isConnectedToInternet {
            let param = createLikeRequest(sessionId: liveSessionID)
            LiveScreenService().postLikeService(param: param) { [weak self] result, error in
                guard let self = self else { return }
                if let result = result{
                    print("Video Like successfully", result)
                    self.viewController?.animateLikeView()
                    self.sendMessageThroughSocket(name: Socket_IOManager.Events.likeEmoji.emitterName,request: param)
                } else {
                    self.viewController?.showError(errorString: error?.message ?? "Something went wrong")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }
    }
    
    func createLikeRequest(sessionId: String) -> [String: Any]{
        let date = Date.init()
        let currentTime = date.serverRequestDateString()
        let req = ["time_stamp": currentTime, "userId": B2CUserDefaults.getUserName(), "source": "web", "liveSessionId": sessionId]
        return req as [String : Any]
    }
    
    
    // MARK: - Post View Count
    func updateViewAPI(for liveSessionID: String) {
        if NetworkManager.isConnectedToInternet {
            let param = createViewCountRequest(sessionId: liveSessionID)
            LiveScreenService().postViewCountService(param: param) { [weak self] result, error in
                guard let self = self else { return }
                if let result = result{
                    print("Video View Count updated successfully", result)
                   // self.viewController?.animateLikeView()
                    self.getViewCount(for: liveSessionID)
                    
                } else {
                    self.viewController?.showError(errorString: error?.message ?? "Something went wrong")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }
    }
    
    func createViewCountObject(sessionId: String, count: Int) -> [String: Any] {
        return ["session_id": sessionId, "count": count] as [String: Any]
    }
    
    func createViewCountRequest(sessionId: String) -> [String: Any]{
        let date = Date.init()
        let currentTime = date.serverRequestDateString()
        let req = ["start": currentTime, "end": currentTime, "source": "web", "liveSessionId": sessionId] //liveSessionId
        return req as [String : Any]
    }
    
}

// MARK: - Socket

extension LiveScreenViewModel {
    
    func sendMessageThroughSocket(name: String = Socket_IOManager.Events.chatMessage.emitterName, request: [String: Any]) {
        Socket_IOManager.shared.socketEmit(emitName: name, params: request)
    }
    func joinRoom(sessionId: String) {
        Socket_IOManager.shared.socketEmit(emitName: Socket_IOManager.Events.joinRoom.emitterName, params: ["room": sessionId])
    }
    
    func leaveRoom(sessionId: String) {
        Socket_IOManager.shared.socketEmit(emitName: Socket_IOManager.Events.leaveRoom.emitterName, params: ["room": sessionId])
    }
}
