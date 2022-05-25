//
//  LiveScreenViewModel.swift
//  B2CSDK
//
//  Created by Raj Kadam on 19/05/22.
//

import Foundation
import UIKit
import ObjectMapper
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
                    //UIUtils.showDefaultAlertView(title: AlertTitles.Error, message: error?.message ?? "Something went wrong")
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
        /*
         data: {
                     “time_stamp”: “current Time”,
                     “username”: “username who login”,
                     “userId” “”user Id,
                     “message”: “hai”,
                     “liveSessionId”: “session-id”
                       }
         */
        //"username": B2CUserDefaults.getUserName(),
        let date = Date.init()
        let currentTime = date.serverRequestDateString()
        let req = ["time_stamp": currentTime, "userId": B2CUserDefaults.getUserId(), "message": message, "liveSessionId": sessionId]
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
                if let count = viewCount{
                    print("view Count", count)
                    self.viewController?.updateViewCount(viewCount: count)
                } else {
                    
                    self.viewController?.showError(errorString: error?.message ?? "Something went wrong")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }

    }
    
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
    
    
    
}


// MARK: - Socket

extension LiveScreenViewModel {
    
    func sendMessageThroughSocket(request: [String: Any]) {
        Socket_IOManager.shared.socketEmit(emitName: Socket_IOManager.Events.chatMessage.emitterName, params: request)
    }
    func joinRoom(sessionId: String) {
        Socket_IOManager.shared.socketEmit(emitName: Socket_IOManager.Events.joinRoom.emitterName, params: ["room": sessionId])
    }
    
    func leaveRoom(sessionId: String) {
        Socket_IOManager.shared.socketEmit(emitName: Socket_IOManager.Events.leaveRoom.emitterName, params: ["room": sessionId])
    }
}
