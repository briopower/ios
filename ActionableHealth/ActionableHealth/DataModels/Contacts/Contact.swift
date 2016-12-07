//
//  Contact.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 29/11/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import Foundation
import CoreData
import APAddressBook
import PhoneNumberKit


private let lastSyncedDate = "lastSyncedDate"
private let emailOrPhone = "emailOrPhone"

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

//MARK:- Private Methods
class Contact: NSManagedObject {
    //MARK:- Variables
    static let apAddressBook = APAddressBook()
    static let phoneNumberKit = PhoneNumberKit()

    //MARK:- Methods
    private class func saveContactObj(addressBook:AddressBook, forId: String, contextRef:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) {
        if let context = contextRef{
            var contact:Contact?

            if let temp = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(Contact), predicate: NSPredicate(format: "id = %@", forId), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: context).first as? Contact {
                contact = temp
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

    private class func loadContacts()
    {
        apAddressBook.loadContacts { (contacts:[APContact]?, error:NSError?) in
            if let contacts = contacts{
                performSelectorInBackground(#selector(self.addContacts(_:)), withObject: contacts)
            }else if let desc = error?.localizedDescription{
                UIAlertController.showAlertOfStyle(.Alert, Message: desc, completion: nil)
            }
        }
    }

    @objc private class func addContacts(contacts:[APContact]) {

        if let delegate = AppDelegate.getAppDelegateObject() {

            //            let hud = showHud()
            let prntCxt = delegate.managedObjectContext
            let bgCxt = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
            bgCxt.parentContext = prntCxt

            bgCxt.performBlock({

                for contact in contacts {
                    //                    let progress = CGFloat(contacts.indexOf(contact) ?? 0)/CGFloat(contacts.count)
                    //                    dispatch_async(dispatch_get_main_queue(), {
                    //                        hud?.progress = progress
                    //                    })
                    if let addBkObj = AddressBook.saveAddressBookObj(contact, contextRef: bgCxt){

                        if let phoneNumbers = contact.phones {
                            for phone in phoneNumbers {
                                if let actualNumber = phone.number {
                                    if let phNum = phoneNumberKit.parseMultiple([actualNumber]).first{
                                        saveContactObj(addBkObj, forId: "\(phNum.nationalNumber)", contextRef: bgCxt)
                                    }
                                }
                            }
                        }

//                        if let emails = contact.emails {
//                            for email in emails {
//                                if let em  = email.address?.getValidObject() {
//                                    if em.isValidEmail(){
//                                        saveContactObj(addBkObj, forId: "\(em)", contextRef: bgCxt)
//                                    }
//                                }
//                            }
//                        }
                    }
                }

                do{
                    try bgCxt.save()
                    prntCxt.performBlock({
                        do{
                            try prntCxt.save()
                            NSUserDefaults.setLastSyncDate(NSDate())
                            if contacts.count > 0 {
                                syncCoreDataContacts()
                            }
                            hideHud()
                        }catch{
                            hideHud()
                            debugPrint("Error saving data")
                        }
                    })
                }catch{
                    hideHud()
                    debugPrint("Error saving data")
                }
            })
        }

    }

    private class func processResponse(response:AnyObject?) {
        if let delegate = AppDelegate.getAppDelegateObject() {
            let prntCxt = delegate.managedObjectContext
            let bgCxt = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
            bgCxt.parentContext = prntCxt

            bgCxt.performBlock({
                if let arr = response as? NSArray {
                    for obj in arr {
                        if let tempId = (obj as? NSDictionary)?[emailOrPhone] as? String {
                            setAppUserWithId(tempId)
                        }
                    }
                }
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
        }

    }

    private class func setAppUserWithId(id:String, contextRef:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) {
        if let arr = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(Contact), predicate: NSPredicate(format: "id = %@", id), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: contextRef) as? [Contact] {
            for obj in arr {
                obj.isAppUser = NSNumber(bool: true)
            }
        }
    }

    private class func showHud() -> VNProgreessHUD? {
        if let view = UIApplication.sharedApplication().keyWindow {
            debugPrint(view)
            let hud = VNProgreessHUD.showHUDAddedToView(view, Animated: true)
            dispatch_async(dispatch_get_main_queue(), {
                hud.mode = VNProgressHUDMode.AnnularDeterminate
                hud.labelText = "Syncing Contacts\nPlease wait..."
                hud.progress = 0
            })
            return hud
        }
        return nil
    }

    private class func hideHud() {
        if let view = UIApplication.sharedApplication().keyWindow {
            VNProgreessHUD.hideAllHudsFromView(view, Animated: true)
        }
    }

}


//MARK:- Contacts Syncing Methods
extension Contact{

    class func checkAccess() -> APAddressBookAccess{
        return APAddressBook.access()
    }

    class func syncContacts() {

        apAddressBook.fieldsMask = [.Name, .PhonesOnly, .Dates, .RecordDate]
        apAddressBook.sortDescriptors = [NSSortDescriptor(key: "name.firstName", ascending: true), NSSortDescriptor(key: "name.lastName", ascending: true)]

        apAddressBook.filterBlock =
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

    class func syncCoreDataContacts() {
        if let contacts = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(Contact), predicate: NSPredicate(format: "isAppUser = %@", NSNumber(bool: false)), sortingKey: nil, fetchLimit: nil) as? [Contact] {
            let arr = NSMutableArray()
            for contact in contacts {
                if let uniqueId = contact.id {
                    arr.addObject([emailOrPhone:uniqueId])
                }
            }
            if let splitedArray = arr.splitArrayWithSize(500) as? [NSArray]{
                for obj in splitedArray {
                    syncContactFromServer(NSMutableArray(array: obj))
                }
            }
        }
    }
}

//MARK: Network Methods
extension Contact{
    private class func syncContactFromServer(array:NSMutableArray) {
        if NSUserDefaults.isLoggedIn() {
            NetworkClass.sendRequest(URL: Constants.URLs.appUsers, RequestType: .POST, Parameters: array, Headers: nil) { (status, responseObj, error, statusCode) in
                if status{
                    processResponse(responseObj)
                }else{
                    syncContactFromServer(array)
                }
                debugPrint("\(statusCode),\(responseObj)")
            }
        }
    }
}
