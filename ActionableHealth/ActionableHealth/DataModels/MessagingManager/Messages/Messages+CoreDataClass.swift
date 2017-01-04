//
//  Messages+CoreDataClass.swift
//
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

import Foundation
import CoreData

enum MessageStatus:String {
    case Sent, Recieved, Read
}

@objc(Messages)

//MARK:- Public Methods
public class Messages: NSManagedObject {

    class func saveMessageFor(key:String, value:[String:AnyObject]){
        if let prntCxt = AppDelegate.getAppDelegateObject()?.managedObjectContext, let bgCxt = AppDelegate.getAppDelegateObject()?.bgManagedObjectContext {

            let message = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(Messages), predicate: NSPredicate(format: "messageId = %@", key), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: bgCxt) as? [Messages]

            if message?.count ?? 0 == 0 {
                bgCxt.performBlock({
                    insertMessageInDB(key, value: value, context: bgCxt)
                    do{
                        try bgCxt.save()
                        prntCxt.performBlock({
                            do{
                                try prntCxt.save()
                            }catch{
                                debugPrint("Error saving data")
                            }
                        })
                    }catch{
                        debugPrint("Error saving data")
                    }
                })
            }else{
                debugPrint("Message already exists")
            }
        }
    }

    private class func insertMessageInDB(key:String, value:[String:AnyObject], context:NSManagedObjectContext) {
        if let fromId = value["from"] as? String {
            let messageObject = Messages(entity: NSEntityDescription.entityForName(String(Messages), inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)

            messageObject.messageId = key
            messageObject.key = value["data"]?["key"] as? String
            messageObject.message = value["data"]?["message"] as? String
            messageObject.type = value["data"]?["type"] as? String
            messageObject.priority = value["priority"] as? String
            messageObject.timestamp = value["timeStamp"] as? NSNumber
            if fromId == NSUserDefaults.getUserId() {
                if let toId = messageObject.key {
                    if let person = Person.getPersonWith(toId, contextRef: context) {
                        person.markAllAsRead()
                        messageObject.person = person
                    }
                }
                messageObject.status = MessageStatus.Sent.rawValue
            }else{
                messageObject.status = MessageStatus.Recieved.rawValue
                if let person = Person.getPersonWith(fromId, contextRef: context) {
                    messageObject.person = person
                }
            }
            messageObject.person?.lastMessage = messageObject
            messageObject.person?.addToMessages(messageObject)
        }
    }
}
