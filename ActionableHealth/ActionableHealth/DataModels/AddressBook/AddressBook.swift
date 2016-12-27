//
//  AddressBook.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 29/11/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import Foundation
import CoreData

//MARK:- Public methods
class AddressBook: NSManagedObject {

    class func saveAddressBookObj(contact:APContact, contextRef:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) -> AddressBook? {
        if let context = contextRef{

            var addBook:AddressBook?
            let addBookArr = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(AddressBook), predicate: NSPredicate(format: "recordId = %@", contact.recordID), sortingKey: ["name"], isAcendingSort: true, fetchLimit: nil, context: contextRef) as? [AddressBook]

            if let temp = addBookArr?.first{
                addBook = temp
                for obj in addBookArr ?? [] {
                    if obj != addBook {
                        contextRef?.deleteObject(obj)
                    }
                }
            }else{
                addBook = AddressBook(entity: NSEntityDescription.entityForName(String(AddressBook), inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
                addBook?.recordId = contact.recordID
            }

            addBook?.name = contact.name?.compositeName
            return addBook
        }
        return nil
    }

    
}


