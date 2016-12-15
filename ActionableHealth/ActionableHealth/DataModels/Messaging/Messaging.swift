//
//  Messaging.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum PresenceType:String {
    case online, offline, typing
}
//MARK:- Network Methods
class Messaging: NSObject {

    class func openChatSession() {
        NetworkClass.sendRequest(URL: Constants.URLs.openChatSession, RequestType: .GET) { (status, responseObj, error, statusCode) in
            if let token = responseObj?["token"] as? String, let chatId = responseObj?["chatId"] as? String {
                NSUserDefaults.setMessagingToken(token)
                NSUserDefaults.setChatId(chatId)
            }else{
                self.openChatSession()
            }
        }
    }

    class func closeChatSession() {
        NetworkClass.sendRequest(URL: Constants.URLs.closeChatSession, RequestType: .GET) { (status, responseObj, error, statusCode) in
            debugPrint(responseObj)
            NSUserDefaults.setMessagingToken(nil)
            NSUserDefaults.setChatId(nil)
        }
    }

    class func broadCastPresence(presence:PresenceType) {
        NetworkClass.sendRequest(URL: Constants.URLs.broadCastPresence + presence.rawValue, RequestType: .GET) { (status, responseObj, error, statusCode) in
            debugPrint(responseObj)
        }
    }

    func sendMessage(message:String?, to: String?)  {
        
    }
}
