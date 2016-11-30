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
private let apAddressBook = APAddressBook()
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

class Contact: NSManagedObject {

    class func saveContactObj(addressBook:APContact, forId: String, contextRef:NSManagedObjectContext? = nil) {
        if let context = contextRef ?? AppDelegate.getAppDelegateObject()?.managedObjectContext{
            var contact:Contact?

            if let temp = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(Contact), predicate: NSPredicate(format: "id = %@", forId), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: context).first as? Contact {
                contact = temp
            }else{
                contact = Contact(entity: NSEntityDescription.entityForName(String(Contact), inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
                contact?.isAppUser = NSNumber(bool: false)
                contact?.id = forId
                contact?.recordId = "\(addressBook.recordID)"
            }
            contact?.name = addressBook.name?.compositeName
        }
    }
}


//MARK:- Contacts Syncing Methods
extension Contact{

    class func checkAccess() {
        switch APAddressBook.access() {
        case .Denied:
            print("Denied")
        case .Granted:
            print("Granted")
        case .Unknown:
            print("Unknown")
        }
    }

    class func syncContacts() {

        apAddressBook.fieldsMask = [.Name, .PhonesOnly, .EmailsOnly, .Dates, .RecordDate]
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
                        if let phones = contact.phones, let emails = contact.emails {
                            return phones.count > 0 || emails.count > 0
                        }else if let phones = contact.phones
                        {
                            return phones.count > 0
                        }else if let emails = contact.emails
                        {
                            return emails.count > 0
                        }
                    }
                }
                return false
        }
        loadContacts()
    }

    class func loadContacts()
    {
        apAddressBook.loadContacts { (contacts:[APContact]?, error:NSError?) in
            if let contacts = contacts{
                performSelectorInBackground(#selector(self.addContacts(_:)), withObject: contacts)
            }else if let desc = error?.localizedDescription{
                UIAlertController.showAlertOfStyle(.Alert, Message: desc, completion: nil)
            }
        }
    }

    class func addContacts(contacts:[APContact]) {

        if let delegate = AppDelegate.getAppDelegateObject() {
            let hud = VNProgreessHUD.showHUDAddedToView(UIApplication.sharedApplication().keyWindow ?? UIView(), Animated: true)
            dispatch_async(dispatch_get_main_queue(), {
                hud.mode = VNProgressHUDMode.AnnularDeterminate
                hud.labelText = "Syncing Contacts\nPlease wait..."
                hud.progress = 0
            })

            let bgCxt = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
            let prntCxt = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)

            prntCxt.persistentStoreCoordinator = delegate.persistentStoreCoordinator
            bgCxt.parentContext = prntCxt

            bgCxt.performBlock({
                let phoneNumberKit = PhoneNumberKit()

                for contact in contacts {
                    let progress = CGFloat(contacts.indexOf(contact) ?? 0)/CGFloat(contacts.count)
                    dispatch_async(dispatch_get_main_queue(), {
                        hud.progress = progress
                    })
                    if let phoneNumbers = contact.phones {
                        for phone in phoneNumbers {
                            if let actualNumber = phone.number {
                                if let phNum = phoneNumberKit.parseMultiple([actualNumber]).first{
                                    saveContactObj(contact, forId: "\(phNum.nationalNumber)", contextRef: bgCxt)
                                }
                            }
                        }
                    }

                    if let emails = contact.emails {
                        for email in emails {
                            if let em  = email.address {
                                saveContactObj(contact, forId: "\(em)", contextRef: bgCxt)
                            }
                        }
                    }
                }

                do{
                    try bgCxt.save()
                    prntCxt.performBlock({
                        do{
                            try prntCxt.save()
                            //                            NSUserDefaults.setLastSyncDate(NSDate())
                            syncCoreDataContacts()
                            hud.hide(true)
                        }catch{
                            hud.hide(true)
                            print("Error saving data")
                        }
                    })
                }catch{
                    hud.hide(true)
                    print("Error saving data")
                }
            })
        }

    }

    class func syncCoreDataContacts() {
        if let contacts = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(Contact), predicate: NSPredicate(format: "isAppUser = %@", NSNumber(bool: false)), sortingKey: nil, fetchLimit: nil) as? [Contact] {
            let arr = NSMutableArray()
            for contact in contacts {
                if let uniqueId = contact.id {
                    arr.addObject([emailOrPhone:uniqueId])
                }
            }
            if arr.count > 0{
                syncContactFromServer(arr)
            }
        }
    }
    
    //MARK: Network Methods
    class func syncContactFromServer(array:NSMutableArray) {
        print(array)
        NetworkClass.sendRequest(URL: Constants.URLs.appUsers, RequestType: .POST, Parameters: array, Headers: nil) { (status, responseObj, error, statusCode) in


            print(responseObj)
        }
    }
}