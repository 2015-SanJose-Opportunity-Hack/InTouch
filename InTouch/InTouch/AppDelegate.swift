//
//  AppDelegate.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/3/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        self.window?.tintColor = UIColor(red:0, green:0.6, blue:0.89, alpha:1)
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("NhJGrdxkmmGolldGpNjToTZY009P6DdNEgGYVl3J",
            clientKey: "oGftYfAmbKCRVNSGk8qjOqYwsIgzkkjJdjO4yzew")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFInstallation.currentInstallation().saveInBackground()



        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeFloatLabeledTextField] = FloatLabeledTextFieldCell.self

        self.setupNotificationSettings(application)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.chunweichen.InTouch" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("InTouch", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as? NSError
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
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
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
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        PFInstallation.currentInstallation().setDeviceTokenFromData(deviceToken)
        PFInstallation.currentInstallation().saveInBackground()
    }
    
    func imageWithColor(color:UIColor) -> UIImage{
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func setupNotificationSettings(application:UIApplication) {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if (notificationSettings.types == UIUserNotificationType.None){
            // Specify the notification types.
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Sound]
            
            
            // Specify the notification actions.
            let affirmAction = UIMutableUserNotificationAction()
            affirmAction.identifier = "affirm"
            affirmAction.title = "Yes"
            affirmAction.activationMode = UIUserNotificationActivationMode.Background
            affirmAction.destructive = false
            affirmAction.authenticationRequired = false
            
            let affirmAndTextAction = UIMutableUserNotificationAction()
            affirmAndTextAction.identifier = "affirmAndText"
            affirmAndTextAction.title = "Yes and..."
            affirmAndTextAction.activationMode = UIUserNotificationActivationMode.Background
            affirmAndTextAction.destructive = false
            affirmAndTextAction.authenticationRequired = false
            affirmAndTextAction.behavior = UIUserNotificationActionBehavior.TextInput
            
//            var trashAction = UIMutableUserNotificationAction()
//            trashAction.identifier = "trashAction"
//            trashAction.title = "Delete list"
//            trashAction.activationMode = UIUserNotificationActivationMode.Background
//            trashAction.destructive = true
//            trashAction.authenticationRequired = true
            
            let actionsArray = NSArray(objects: affirmAndTextAction, affirmAction)
            let actionsArrayMinimal = NSArray(objects: affirmAndTextAction, affirmAction)
            
            // Specify the category related to the above actions.
            let inTouchCategory = UIMutableUserNotificationCategory()
            inTouchCategory.identifier = "inTouchCategory"
            inTouchCategory.setActions(actionsArray as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
            inTouchCategory.setActions(actionsArrayMinimal as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
            
            
            let categoriesForSettings = NSSet(objects: inTouchCategory)
            
            
            // Register the notification settings.
            let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as? Set<UIUserNotificationCategory>)
            UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if (identifier == "affirm"){
            let taskId = userInfo["taskId"] as! String
            let taskQuery = PFQuery(className: "Task")
            taskQuery.whereKey("objectId", equalTo: taskId)
            taskQuery.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
                let task = objects![0]
                print("affirm with response info")
                task["responded"] = true
                task.saveInBackgroundWithBlock({(success, error) -> Void in
                    completionHandler()
                })
            })

        }
        else if (identifier == "affirmAndText"){
            let taskId = userInfo["taskId"] as! String
            let taskQuery = PFQuery(className: "Task")
            taskQuery.whereKey("objectId", equalTo: taskId)
            taskQuery.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
                let task = objects![0]
                print("affirmAndText with response info \(responseInfo[UIUserNotificationActionResponseTypedTextKey]!) and taskId is \(taskId)")
                task["responded"] = true
                task["responseMessage"] = responseInfo[UIUserNotificationActionResponseTypedTextKey]!
                let taskName = task["name"] as! String
                let data = [
                    "alert" : "\(PFUser.currentUser()?.username) Did \(taskName) and \(responseInfo[UIUserNotificationActionResponseTypedTextKey]!)",
                    "badge" : 1,
                    "category" : "inTouchCategory"
                ]
                let push = PFPush()
                push.setQuery(PFQuery(className: "Installation").whereKey("currentUser", equalTo: task["caregiver"]))
                push.setData(data as? [NSObject : AnyObject])
                task.saveInBackgroundWithBlock({(success, error) -> Void in
                    push.sendPushInBackgroundWithBlock({(success, error) -> Void in
                        completionHandler()
                    })
                })
            })
        }
        else{
            completionHandler()
        }
    }
}

