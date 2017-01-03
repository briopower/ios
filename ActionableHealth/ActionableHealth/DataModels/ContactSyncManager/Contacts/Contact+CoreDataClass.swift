//
//  Contact+CoreDataClass.swift
//
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

import Foundation
import CoreData

//MARK:- Public Methods
public class Contact: NSManagedObject {

    class func saveContactObj(addressBook:AddressBook, forId: String, contextRef:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) {
        if let context = contextRef{
            var contact:Contact?

            let contactsArr = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(Contact), predicate: NSPredicate(format: "id = %@", forId), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: context) as? [Contact]

            if let temp = contactsArr?.first {
                contact = temp
                for obj in contactsArr ?? [] {
                    if obj != contact {
                        contextRef?.deleteObject(obj)
                    }
                }
            }else{
                contact = Contact(entity: NSEntityDescription.entityForName(String(Contact), inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
                contact?.isAppUser = NSNumber(bool: false)
                contact?.id = forId
            }

            if let temp = contact {
                let set = NSMutableSet(set: addressBook.contacts ?? NSSet())
                set.addObject(temp)
                addressBook.contacts = set
            }

        }
    }

    class func getNameForContact(number:String) -> String? {
        if number == NSUserDefaults.getUserId() {
            return "You"
        }
        let contactsArr = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(Contact), predicate: NSPredicate(format: "id = %@", number), sortingKey: nil, isAcendingSort: true, fetchLimit: nil) as? [Contact]

        if let temp = contactsArr?.first {
            for obj in contactsArr ?? [] {
                if obj != temp {
                    AppDelegate.getAppDelegateObject()?.managedObjectContext.deleteObject(obj)
                }
            }
            return temp.addressBook?.name
        }
        return nil
    }
    
}
