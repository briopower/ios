//
//  Contact+CoreDataProperties.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 29/11/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {

    @NSManaged var isAppUser: Bool
    @NSManaged var id: String?
    @NSManaged var addressBook: AddressBook?

}
