//
//  CoreDataOperationsClass.swift
//  Sustainable Fitness Solution
//
//  Created by Deepak Singh on 03/11/16.
//  Copyright © 2016 Finoit. All rights reserved.
//

import UIKit
import CoreData

class CoreDataOperationsClass: NSObject {
    //MARK:  data fetching methods via NSFetchRequest
    class  func fetchObjectsOfClassWithName(className : String, predicate : NSPredicate? , sortingKey : [String]? , isAcendingSort : Bool = false , fetchLimit :Int?, context:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) -> Array<AnyObject>{
        let fetchRequest = NSFetchRequest(entityName: className)
        fetchRequest.predicate = predicate
        
        //set fetchLimit
        if let limit = fetchLimit
        {
            fetchRequest.fetchLimit = limit
        }
        
        //if there is sort key
        if let sortKey = sortingKey
        {
            fetchRequest.sortDescriptors = []
            for key in sortKey {
                let sortDescriptor = NSSortDescriptor(key: key, ascending: isAcendingSort)
                fetchRequest.sortDescriptors?.append(sortDescriptor)
            }
        }
        
        do{
            let managedObjectContext = context
            let fetchedObjects = try managedObjectContext?.executeFetchRequest(fetchRequest)
            return fetchedObjects ?? []
        }
        catch
        {
            return []
        }
    }
    
    class func getTopMostFetchedObjectOfClassWithName(className : String, predicate : NSPredicate? , sortingKey : [String]? , isAcendingSort : Bool = false) -> AnyObject?
    {
        let fetchedObjectsArray = self.fetchObjectsOfClassWithName(className, predicate: predicate, sortingKey: sortingKey, isAcendingSort: isAcendingSort , fetchLimit: 1)
        
        return  fetchedObjectsArray.count > 0 ? fetchedObjectsArray.first : nil
    }
    
    
    //MARK:  fetchResultsController setup method
    class func getFectechedResultsControllerWithEntityName(className : String, predicate : NSPredicate? ,sectionNameKeyPath : String?, sortingKey : [String]? , isAcendingSort : Bool = false) -> NSFetchedResultsController{
        let managedObjectContext = AppDelegate.getAppDelegateObject()?.managedObjectContext ?? NSManagedObjectContext()
        let fetchRequest = NSFetchRequest()
        let entityDesc = NSEntityDescription.entityForName(className, inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDesc
        //if there is sort key
        if let sortKey = sortingKey
        {
            fetchRequest.sortDescriptors = []
            for key in sortKey {
                let sortDescriptor = NSSortDescriptor(key: key, ascending: isAcendingSort)
                fetchRequest.sortDescriptors?.append(sortDescriptor)
            }
        }
        
        // if predicate exists
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 50
        fetchRequest.returnsObjectsAsFaults = false
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        
        //perform fetch
        do{
            try fetchedResultsController.performFetch()
        }
        catch
        {
            NSLog("unable to fetch objects")
        }
        return fetchedResultsController;
        
    }
}
