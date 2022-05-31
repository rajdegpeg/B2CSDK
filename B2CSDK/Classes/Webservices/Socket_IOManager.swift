//
//  Socket_IOManager.swift
//  B2CSDK
//
//  Created by Raj Kadam on 22/05/22.
//

import Foundation
import SocketIO
import ObjectMapper

protocol SocketDelegate: AnyObject {
    func socketConnected()
    func receivedNewChatMessage(chat: ChatMessage)
    func updateViewCount(views: ViewCountModel)
    func updateLike(like: ViewCountModel)
}

extension SocketDelegate {
    func receivedNewChatMessage(chat: ChatMessage) { }
    func socketConnected() { }
}

class Socket_IOManager {
    
    static let shared = Socket_IOManager()
    var socket: SocketIOClient?
    weak var liveStreamViewControllerDelegate: SocketDelegate?
    private var socketManager: SocketManager?
    
    //MARK:- Socket connect
    func connect() {
            disconnectSocket()
            socketManager = SocketManager(socketURL: URL(string: generateURL())!, config: [.log(false), .compress, .forcePolling(false)])
            socketManager?.setConfigs([.connectParams(getConnectionParams(for: DEFAULT_ContentPublisherId)), .forcePolling(false)])
            socket = socketManager!.socket(forNamespace: "/content-publisher")
            //socket = socketManager!.socket(forNamespace: (userDetails.userRole == .contentProvider) ? "/content-provider" : "/influencer")
            socketListeners(socket: socket!)
            socket?.connect()
        
    }
    
    func getConnectionParams(for id: String) -> [String: Any] {
        //        if (user.userRole == .contentProvider) {
        //            return ["contentProviderId" : user.contentProviderId ?? ""]
        //        }
        return ["contentPublisherId": id]//["influencerId": influencerID]
    }
    
    func generateURL() -> String {
        
        let base_url = APIConstants.BaseUrl.socketURL + "content-publisher" //"influencer"//
        
        return base_url
    }
    
    func disconnectSocket() {
        socket?.removeAllHandlers()
        socket?.disconnect()
        Logs.print("socket Disconnected")
    }
    
    
    func checkConnection() -> Bool {
        if socket?.manager?.status == .connected {
            return true
        }
        return false
        
    }
    
    private func socketListeners(socket: SocketIOClient) {
        
        Logs.print("Listening something!!!")
        
        socket.on(clientEvent: .connect, callback: { [weak self] (data, ack) in
            Logs.print("Socket connected")
            guard let self = self else { return }
            self.liveStreamViewControllerDelegate?.socketConnected()
        })
        
        socket.on("iOS Client Port") { data, ack in
            Logs.print("Received listen")
        }
        
        socket.on(clientEvent: .disconnect, callback: { (data, ack) in
            Logs.print("Socket disconnected")
        })
        
        socket.on(clientEvent: .error, callback: { (data, ack) in
            Logs.print("Socket error: \(data)")
        })
        
        socket.on(clientEvent: .reconnect) { data, ack in
            Logs.print("Socket reconnect")
        }
        
        socket.on(clientEvent: .statusChange) { data, ack in
            Logs.print("Socket Status changes")
        }
        
        socket.on(Events.chatMessage.listnerName) { [weak self] data, ack in
            guard let self = self else { return }
            Logs.print("Chat message received")
            Logs.print(data)
            if let response = self.getResponseData(data: data),
               let chatMessage = Mapper<ChatMessage>().map(JSON: response) {
                self.liveStreamViewControllerDelegate?.receivedNewChatMessage(chat: chatMessage)
            }
        }
        
        socket.on(Events.likeEmoji.listnerName) { [weak self] data, ack in
            guard let self = self else { return }
            Logs.print("Live emoji received")
            Logs.print(data)
            if let response = self.getResponseData(data: data),
               let like = Mapper<ViewCountModel>().map(JSON: response) {
                self.liveStreamViewControllerDelegate?.updateLike(like: like)
            }
        }
        
        socket.on(Events.viewCount.listnerName) { [weak self] data, ack in
            guard let self = self else { return }
            Logs.print("Live view count received")
            Logs.print(data)
            if let response = self.getResponseData(data: data),
               let views = Mapper<ViewCountModel>().map(JSON: response) {
                self.liveStreamViewControllerDelegate?.updateViewCount(views: views)
            }
        }
        
    }
    
    func socketEmit(emitName: String, params: [String: Any]) {
        
        if let socket = socket, socket.status == .connected {
            Logs.print("Emit: \(emitName)\nParams: \(params)")
            socket.emit(emitName, params) {
                Logs.print("Message Emit")
            }
        }
    }
    
    //MARK:- Socket response data
    func getResponseData(data: [Any]) -> [String: Any]? {
        if let result = data.first as? [String: Any] {
            return result
        }
        return nil
    }
    
    
    
    enum Events {
        
        case chatMessage
        case likeEmoji
        case viewCount
        case joinRoom
        case leaveRoom
        
        var emitterName: String {
            switch self {
            case .chatMessage:
                return "chat_message"
            case .likeEmoji:
                return "update_like"
            case .viewCount:
                return "update_view"
            case .joinRoom:
                return "join"
            case .leaveRoom:
                return "leave"
            }
            
        }
        
        var listnerName: String {
            switch self {
            case .chatMessage:
                return "chat_message"
            case .likeEmoji:
                return "like_count_updated"
            case .viewCount:
                return "update_view_count"
            case .joinRoom:
                return "join"
            case .leaveRoom:
                return "leave"
            }
        }
        
        func emit(params: [String : Any]) {
            Logs.print("Socket emit: ", emitterName)
            Logs.print("Params: ", params)
            Socket_IOManager.shared.socket?.emit(emitterName, params)
        }
        
        func off() {
            Socket_IOManager.shared.socket?.off(listnerName)
        }
    }
    
}

