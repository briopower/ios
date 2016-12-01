//
//  AddressBook.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 29/11/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import Foundation
import CoreData
import APAddressBook


//MARK:- Public methods
class AddressBook: NSManagedObject {

    //MARK:- Variables
    static let apAddressBook = APAddressBook()

    //MARK:- Methods
    class func saveAddressBookObj(contact:APContact, contextRef:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) -> AddressBook? {
        if let context = contextRef{
            var addBook:AddressBook?

            if let temp = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(AddressBook), predicate: NSPredicate(format: "recordId = %@", contact.recordID), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: contextRef).first as? AddressBook{
                addBook = temp
            }else{
                addBook = AddressBook(entity: NSEntityDescription.entityForName(String(AddressBook), inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
                addBook?.recordId = contact.recordID
            }

            addBook?.name = contact.name?.compositeName
            return addBook
        }
        return nil
    }

    class func checkForDeletedContacts() {
        if let delegate = AppDelegate.getAppDelegateObject() {
            let prntCxt = delegate.managedObjectContext
            let bgCxt = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
            bgCxt.parentContext = prntCxt

            bgCxt.performBlock({
                if let arr = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(AddressBook), predicate: nil, sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: bgCxt) as? [AddressBook] {
                    for obj in arr {
                        checkIfUserExists(obj, bgCxt: bgCxt, prntCxt: prntCxt)
                    }
                }
            })
        }

    }
}

//MARK:- Priavate methods
extension AddressBook{
    private class func checkIfUserExists(addBook:AddressBook, bgCxt:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext, prntCxt:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) {
        if let rId = addBook.recordId {
            apAddressBook.loadContactByRecordID(rId, completion: { (contact:APContact?) in
                if contact == nil{
                    deleteFromCoreData(addBook, bgCxt: bgCxt, prntCxt: prntCxt)
                }
            })
        }
    }

    private class func deleteFromCoreData(addBook:AddressBook, bgCxt:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext, prntCxt:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) {

        bgCxt?.deleteObject(addBook)

        do{
            try bgCxt?.save()
            prntCxt?.performBlock({
                do{
                    try prntCxt?.save()
                }catch{
                    debugPrint("Error saving data")
                }
            })
        }catch{
            debugPrint("Error saving data")
        }
    }
}

