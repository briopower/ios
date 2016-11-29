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

private let lastSyncedDate = "lastSyncedDate"
private let apAddressBook = APAddressBook()

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
                    print(modificationDate)
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
                addContacts(contacts)
            }else if let desc = error?.localizedDescription{
                UIAlertController.showAlertOfStyle(.Alert, Message: desc, completion: nil)
            }
        }
    }

    class func addContacts(contacts:[APContact]) {
        NSUserDefaults.setLastSyncDate(NSDate())
        print(contacts)
    }
}