//
//  Person+CoreDataClass.swift
//
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

import Foundation
import CoreData

//MARK:- Public Methods
open class Person: NSManagedObject {
    func getUnreadMessageCount() -> Int {
        return messages?.filtered(using: NSPredicate(format: "self.status = %@", MessageStatus.Recieved.rawValue)).count ?? 0
    }

    func markAllAsRead() {
        
        if let set = messages?.filtered(using: NSPredicate(format: "self.status = %@", MessageStatus.Recieved.rawValue)) {
            if let arr = Array(set) as? [Messages]{
                for msg in arr {
                    msg.status = MessageStatus.Read.rawValue
                }
            }
        }
    }

    func updateProfileImage() {
        NetworkClass.sendRequest(URL: "\(Constants.URLs.profileImageURL)\(personId ?? "")", RequestType: .get) {
            (status, responseObj, error, statusCode) in
            if status, let imageUrl = responseObj?["profileURL"] as? String{
                self.personImage = imageUrl
            }
        }
    }

    class func getPersonWith(_ id:String, contextRef:NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext) -> Person? {

        if let context = contextRef{

            var personObj:Person?
            let presonArr = CoreDataOperationsClass.fetchObjectsOfClassWithName("Person", predicate: NSPredicate(format: "personId = %@", id), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: context) as? [Person]

            if let temp = presonArr?.first{
                personObj = temp
                for obj in presonArr ?? [] {
                    if obj != personObj {
                        context.delete(obj)
                    }
                }
            }else{
                personObj = Person(entity: NSEntityDescription.entity(forEntityName: String(describing: Person.self), in: context)!, insertInto: context)
            }
            personObj?.personId = id
            personObj?.personName = Contact.getNameForContact(id)
            personObj?.updateProfileImage()
            return personObj
        }
        return nil
    }
}
