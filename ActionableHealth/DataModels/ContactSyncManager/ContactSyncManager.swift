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
extension UserDefaults{
    class func setLastSyncDate(_ date:Date) -> Bool {
        UserDefaults.standard.set(date, forKey: lastSyncedDate)
        return UserDefaults.standard.synchronize()
    }

    class func getLastSyncDate() -> Date? {
        return UserDefaults.standard.object(forKey: lastSyncedDate) as? Date
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
    fileprivate func loadContacts()
    {
        ContactSyncManager.apAddressBook.loadContacts { (contacts:[APContact]?, error:Error?) in
            if let contacts = contacts{
                self.performSelector(inBackground: #selector(ContactSyncManager.addContacts(_:)), with: contacts)
            }else if let desc = error?.localizedDescription{
                UIView.showToast(desc, theme: Theme.error)
            }else{
                self.syncCompleted(Date(timeIntervalSince1970: 0))
            }
            }
        
    }

    @objc fileprivate func addContacts(_ contacts:[APContact]) {

        if let prntCxt = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext, let bgCxt = (UIApplication.shared.delegate as? AppDelegate)?.abManagedObjectContext, !isSyncing {

            bgCxt.perform({
                self.isSyncing = true
                for contact in contacts {
                    if self.shouldProcess(contact), let addBkObj = AddressBook.saveAddressBookObj(contact, contextRef: bgCxt){
                        Contact.deleteContactsForRecordId(contact.recordID)
                        if let phoneNumbers = contact.phones {
                            for phone in phoneNumbers {
                                if let actualNumber = phone.number {
                                    if let phNum = ContactSyncManager.phoneNumberKit.parse([actualNumber]).first{
                                        Contact.saveContactObj(addBkObj, forId: "\(phNum.nationalNumber)", contextRef: bgCxt)
                                    }
                                }
                            }
                        }
                    }
                }
                do{
                    try bgCxt.save()
                    prntCxt.perform({
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

    fileprivate func shouldProcess(_ contact:APContact) -> Bool {
        debugPrint(contact.phones?[0].number)
        if let modificationDate = contact.recordDate?.modificationDate {
            var shouldProcess = false
            if let lastSycned = UserDefaults.getLastSyncDate() {
                if modificationDate.compare(lastSycned) == ComparisonResult.orderedDescending  {
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
    fileprivate func syncCompleted(_ date:Date = Date()) {
        UserDefaults.setLastSyncDate(date)
        self.syncCoreDataContacts()
        self.isSyncing = false
        NotificationCenter.default.post(name: Notification.Name(rawValue: ContactSyncManager.contactSyncCompleted), object: nil)
    }
    fileprivate func processResponse(_ response:AnyObject?) {
        if let prntCxt = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext, let bgCxt = (UIApplication.shared.delegate as? AppDelegate)?.abManagedObjectContext {
            bgCxt.perform({
                if let arr = response as? NSArray {
                    for obj in arr {
                        if let tempId = (obj as? NSDictionary)?[userId] as? String {
                            self.setAppUserWithId(tempId)
                        }
                    }
                }
                do{
                    try bgCxt.save()
                    prntCxt.perform({
                        do{
                            try prntCxt.save()
                            NotificationCenter.default.post(name: Notification.Name(rawValue: ContactSyncManager.contactSyncCompleted), object: nil)
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

    fileprivate func setAppUserWithId(_ id:String, contextRef:NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext) {
        if let arr = CoreDataOperationsClass.fetchObjectsOfClassWithName("Contact", predicate: NSPredicate(format: "id = %@", id), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: contextRef) as? [Contact] {
            for obj in arr {
                obj.isAppUser = NSNumber(value: true as Bool)
            }
        }
    }

    fileprivate func checkIfUserExists(_ addBook:AddressBook, bgCxt:NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext, prntCxt:NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext) {
        if let rId = addBook.recordId {
            ContactSyncManager.apAddressBook.loadContact(byRecordID: rId, completion: { (contact:APContact?) in
                if contact == nil{
                    self.deleteFromCoreData(addBook, bgCxt: bgCxt, prntCxt: prntCxt)
                }
            })
        }
    }

    fileprivate func deleteFromCoreData(_ addBook:AddressBook, bgCxt:NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext, prntCxt:NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext) {

        bgCxt?.delete(addBook)

        do{
            try bgCxt?.save()
            prntCxt?.perform({
                do{
                    try prntCxt?.save()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: ContactSyncManager.contactSyncCompleted), object: nil)
                }catch{
                    debugPrint("Error saving data")
                }
            })
        }catch{
            debugPrint("Error saving data")
        }
    }

    @objc fileprivate func fetchContactsAndStartSyncing() {
        if let contacts = CoreDataOperationsClass.fetchObjectsOfClassWithName("Contact", predicate: NSPredicate(format: "isAppUser = %@", NSNumber(value: false as Bool)), sortingKey: nil, fetchLimit: nil) as? [Contact] {
            let arr = NSMutableArray()
            for contact in contacts {
                if let uniqueId = contact.id {
                    arr.add([emailOrPhone:uniqueId])
                }
            }
            if let splitedArray = arr.splitArrayWithSize(50) as? [NSArray]{
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
        if ContactSyncManager.sharedInstance.checkAccess() == .granted{
            if !isSyncing {
                ContactSyncManager.apAddressBook.fieldsMask = [.name, .phonesOnly, .dates, .recordDate]
                ContactSyncManager.apAddressBook.sortDescriptors = [NSSortDescriptor(key: "recordDate.modificationDate", ascending: false)]
                loadContacts()
            }
        }else{
//            ContactSyncManager.apAddressBook.requestAccess({ (request:Bool, error:NSError?) in
//                if let error = error{
//                    debugPrint("Contact request access error ----------\(error)----------")
//                }else if request{
//                    self.syncContacts()
//                }
//            } as! (Bool, Error?) -> Void)
            ContactSyncManager.apAddressBook.requestAccess { (request: Bool, error: Error?) in
                if let error = error{
                    debugPrint("Contact request access error ----------\(error)----------")
                }else if request{
                    self.syncContacts()
                }
            }
            self.syncCompleted(Date(timeIntervalSince1970: 0))
        }

    }

    func syncCoreDataContacts() {
        if UserDefaults.isLoggedIn() {
            performSelector(inBackground: #selector(ContactSyncManager.fetchContactsAndStartSyncing), with: nil)
        }
    }

    func checkForDeletedContacts() {
        if ContactSyncManager.sharedInstance.checkAccess() == .granted{
            if let prntCxt = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext, let bgCxt = (UIApplication.shared.delegate as? AppDelegate)?.abManagedObjectContext, !isDeleting {
                self.isDeleting = true

                bgCxt.perform({
                    if let arr = CoreDataOperationsClass.fetchObjectsOfClassWithName("AddressBook", predicate: nil, sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: bgCxt) as? [AddressBook] {
                        for obj in arr {
                            self.checkIfUserExists(obj, bgCxt: bgCxt, prntCxt: prntCxt)
                        }
                    }
                    self.isDeleting = false
                })
            }
        }else{

            ContactSyncManager.apAddressBook.requestAccess { (request: Bool, error: Error?) in
                if let error = error{
                    debugPrint("Contact request access error ----------\(error)----------")
                }else if request{
                    self.checkForDeletedContacts()
                }
            }
        }
    }
}

//MARK: Network Methods
extension ContactSyncManager{

    fileprivate func syncContactFromServer(_ array:NSMutableArray) {
        NetworkClass.sendRequest(URL: Constants.URLs.appUsers, RequestType: .post, Parameters: array, Headers: nil, networkActivityIndicatorVisible: false) { (status, responseObj, error, statusCode) in
            if status{
                self.processResponse(responseObj)
            }else{
                self.syncContactFromServer(array)
            }
        }
    }
}
