//
//  ContactSyncManager.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 27/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
import APAddressBook
import PhoneNumberKit
import CoreData


private let lastSyncedDate = "lastSyncedDate"
private let emailOrPhone = "emailOrPhone"
private let userId = "userId"

//MARK:- NSUserDefaults for last sync date
extension NSUserDefaults{
    class func setLastSyncDate(date:NSDate) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(date, forKey: lastSyncedDate)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }

    class func getLastSyncDate() -> NSDate? {
        return NSUserDefaults.standardUserDefaults().objectForKey(lastSyncedDate) as? NSDate
    }
}

class ContactSyncManager: NSObject {

    //MARK:- Variables
    static let sharedInstance = ContactSyncManager()
    static let apAddressBook = APAddressBook()
    static let phoneNumberKit = PhoneNumberKit()
    static let contactSyncCompleted = "ContactSyncCompleted"

    var isSyncing = false
    var isDeleting = false

    //MARK:- Private Methods
    private func loadContacts()
    {
        ContactSyncManager.apAddressBook.loadContacts { (contacts:[APContact]?, error:NSError?) in
            if let contacts = contacts{
                self.performSelectorInBackground(#selector(ContactSyncManager.addContacts(_:)), withObject: contacts)
            }else if let desc = error?.localizedDescription{
                // UIAlertController.showAlertOfStyle(.Alert, Message: desc, completion: nil)
                UIView.showToast(desc, theme: Theme.Error)
            }else{
                self.syncCompleted()
            }
        }
    }

    @objc private func addContacts(contacts:[APContact]) {

        if let prntCxt = AppDelegate.getAppDelegateObject()?.managedObjectContext, let bgCxt = AppDelegate.getAppDelegateObject()?.abManagedObjectContext where !isSyncing {

            bgCxt.performBlock({
                self.isSyncing = true
                for contact in contacts {
                    if let addBkObj = AddressBook.saveAddressBookObj(contact, contextRef: bgCxt){

                        if let phoneNumbers = contact.phones {
                            for phone in phoneNumbers {
                                if let actualNumber = phone.number {
                                    if let phNum = ContactSyncManager.phoneNumberKit.parseMultiple([actualNumber]).first{
                                        Contact.saveContactObj(addBkObj, forId: "\(phNum.nationalNumber)", contextRef: bgCxt)
                                    }
                                }
                            }
                        }
                    }
                }

                do{
                    try bgCxt.save()
                    prntCxt.performBlock({
                        do{
                            try prntCxt.save()
                            self.syncCompleted()
                        }catch{
                            self.isSyncing = false
                            debugPrint("Error saving data")
                        }
                    })
                }catch{
                    self.isSyncing = false
                    debugPrint("Error saving data")
                }
            })
        }

    }

    private func syncCompleted() {
        NSUserDefaults.setLastSyncDate(NSDate())
        self.syncCoreDataContacts()
        self.isSyncing = false
        NSNotificationCenter.defaultCenter().postNotificationName(ContactSyncManager.contactSyncCompleted, object: nil)
    }
    private func processResponse(response:AnyObject?) {
        if let prntCxt = AppDelegate.getAppDelegateObject()?.managedObjectContext, let bgCxt = AppDelegate.getAppDelegateObject()?.abManagedObjectContext {
            bgCxt.performBlock({
                if let arr = response as? NSArray {
                    for obj in arr {
                        if let tempId = (obj as? NSDictionary)?[userId] as? String {
                            self.setAppUserWithId(tempId)
                        }
                    }
                }
                do{
                    try bgCxt.save()
                    prntCxt.performBlock({
                        do{
                            try prntCxt.save()
                            NSNotificationCenter.defaultCenter().postNotificationName(ContactSyncManager.contactSyncCompleted, object: nil)
                        }catch{
                            debugPrint("Error saving data")
                        }
                    })
                }catch{
                    debugPrint("Error saving data")
                }
            })
        }

    }

    private func setAppUserWithId(id:String, contextRef:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) {
        if let arr = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(Contact), predicate: NSPredicate(format: "id = %@", id), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: contextRef) as? [Contact] {
            for obj in arr {
                obj.isAppUser = NSNumber(bool: true)
            }
        }
    }

    private func checkIfUserExists(addBook:AddressBook, bgCxt:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext, prntCxt:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) {
        if let rId = addBook.recordId {
            ContactSyncManager.apAddressBook.loadContactByRecordID(rId, completion: { (contact:APContact?) in
                if contact == nil{
                    self.deleteFromCoreData(addBook, bgCxt: bgCxt, prntCxt: prntCxt)
                }
            })
        }
    }

    private func deleteFromCoreData(addBook:AddressBook, bgCxt:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext, prntCxt:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) {

        bgCxt?.deleteObject(addBook)

        do{
            try bgCxt?.save()
            prntCxt?.performBlock({
                do{
                    try prntCxt?.save()
                    NSNotificationCenter.defaultCenter().postNotificationName(ContactSyncManager.contactSyncCompleted, object: nil)
                }catch{
                    debugPrint("Error saving data")
                }
            })
        }catch{
            debugPrint("Error saving data")
        }
    }

    @objc private func fetchContactsAndStartSyncing() {
        if let contacts = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(Contact), predicate: NSPredicate(format: "isAppUser = %@", NSNumber(bool: false)), sortingKey: nil, fetchLimit: nil) as? [Contact] {
            let arr = NSMutableArray()
            for contact in contacts {
                if let uniqueId = contact.id {
                    arr.addObject([emailOrPhone:uniqueId])
                }
            }
            if let splitedArray = arr.splitArrayWithSize(500) as? [NSArray]{
                for obj in splitedArray {
                    let arr:Array<UIColor> = []
                    arr
                    syncContactFromServer(NSMutableArray(array: obj))
                }
            }
        }
    }
}

//MARK:- Contacts Syncing Methods
extension ContactSyncManager{

    func checkAccess() -> APAddressBookAccess{
        return APAddressBook.access()
    }

    func syncContacts() {

        if ContactSyncManager.sharedInstance.checkAccess() != .Denied{
            if !isSyncing {
                ContactSyncManager.apAddressBook.fieldsMask = [.Name, .PhonesOnly, .Dates, .RecordDate]

                ContactSyncManager.apAddressBook.filterBlock =
                    {
                        (contact: APContact) -> Bool in
                        if let modificationDate = contact.recordDate?.modificationDate {
                            var shouldProcess = false
                            if let lastSycned = NSUserDefaults.getLastSyncDate() {
                                if modificationDate.compare(lastSycned) == NSComparisonResult.OrderedDescending  {
                                    shouldProcess = true
                                }
                            }else{
                                shouldProcess = true
                            }
                            if shouldProcess {
                                if let phones = contact.phones
                                {
                                    return phones.count > 0
                                }
                            }
                        }
                        return false
                }
                loadContacts()
            }
        }else{
            ContactSyncManager.apAddressBook.requestAccess({ (request:Bool, error:NSError?) in
                if let error = error{
                    debugPrint("Contact request access error ----------\(error)----------")
                }
            })
            NSUserDefaults.setLastSyncDate(NSDate())
        }

    }

    func syncCoreDataContacts() {
        if NSUserDefaults.isLoggedIn() {
            performSelectorInBackground(#selector(ContactSyncManager.fetchContactsAndStartSyncing), withObject: nil)
        }
    }

    func checkForDeletedContacts() {
        if ContactSyncManager.sharedInstance.checkAccess() == .Granted{
            if let prntCxt = AppDelegate.getAppDelegateObject()?.managedObjectContext, let bgCxt = AppDelegate.getAppDelegateObject()?.abManagedObjectContext where !isDeleting {
                self.isDeleting = true

                bgCxt.performBlock({
                    if let arr = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(AddressBook), predicate: nil, sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: bgCxt) as? [AddressBook] {
                        for obj in arr {
                            self.checkIfUserExists(obj, bgCxt: bgCxt, prntCxt: prntCxt)
                        }
                    }
                    self.isDeleting = false
                })
            }
        }
    }
}

//MARK: Network Methods
extension ContactSyncManager{

    private func syncContactFromServer(array:NSMutableArray) {
        NetworkClass.sendRequest(URL: Constants.URLs.appUsers, RequestType: .POST, Parameters: array, Headers: nil) { (status, responseObj, error, statusCode) in
            if status{
                self.processResponse(responseObj)
            }else{
                self.syncContactFromServer(array)
            }
        }
    }
}
