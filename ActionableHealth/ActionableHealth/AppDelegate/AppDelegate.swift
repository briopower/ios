//
//  AppDelegate.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 04/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    var currentPlacemark:CLPlacemark?
    var imageView = UIImageView(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        if !UserDefaults.isLoggedIn() {
//        }
        FirebaseApp.configure()
        forEasyLoading()

        setupOnAppLauch()

        if let myDict = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            MessagingManager.sharedInstance.receivedPushNotification(myDict)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Messaging.messaging().shouldEstablishDirectChannel = false
        debugPrint("Disconnected from FCM.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        MessagingManager.sharedInstance.connectToFcm()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        startSyncing()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.finoit.ActionableHealth" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var applicationLibraryDirectory: URL = {
        let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "ActionableHealth", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationLibraryDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            if let tempError = error as? NSError{
                dict[NSUnderlyingErrorKey] = tempError
            }
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    lazy var bgManagedObjectContext: NSManagedObjectContext = {
        var bgContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        bgContext.parent = AppDelegate.getAppDelegateObject()?.managedObjectContext
        return bgContext
    }()

    lazy var abManagedObjectContext: NSManagedObjectContext = {
        var bgContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        bgContext.parent = AppDelegate.getAppDelegateObject()?.managedObjectContext
        return bgContext
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

//MARK: - Notification Methods
extension AppDelegate{

    func registerForPushNotifications() {
        let application = UIApplication.shared

        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (val, error) in

            })
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self

        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        
        // TODO
        //InstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        MessagingManager.sharedInstance.receivedPushNotification(userInfo)
    }
}

//MARK:- Additonal methods
extension AppDelegate{
    func forEasyLoading() {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.commentsView) as? CommentsViewController {
            viewCont.view.isUserInteractionEnabled = true
        }

        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.trackFileView) as? TrackFilesViewController {
            viewCont.view.isUserInteractionEnabled = true
        }
    }

    func startSyncing(){
        ContactSyncManager.sharedInstance.checkForDeletedContacts()
        ContactSyncManager.sharedInstance.syncContacts()
    }

    func setupOnAppLauch() {
        
        if UserDefaults.isLoggedIn() {
            // Add observer for InstanceID token refresh callback.
            NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(_:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
            registerForPushNotifications()
            MessagingManager.sharedInstance.openChatSession()
        }else{
            MessagingManager.sharedInstance.closeChatSession()
        }
    }

    func addLaunchScreen() {
        imageView.image = UIImage(named: "Splash")
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = UIColor.white
        UIApplication.shared.keyWindow?.addSubview(imageView)
    }

    func removeLaunchScreen() {
        imageView.removeFromSuperview()
    }
}

//MARK:- UNUserNotificationCenterDelegate
extension AppDelegate:UNUserNotificationCenterDelegate{

}
//MARK:- FIRMessagingDelegate
extension AppDelegate:MessagingDelegate{
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage){
        MessagingManager.sharedInstance.receivedPushNotification(remoteMessage.appData)
    }
}

//MARK:- Notification Methods
extension AppDelegate{
    func tokenRefreshNotification(_ not:Notification) {
        MessagingManager.sharedInstance.connectToFcm()        
    }
}
