//
//  AppDelegate.swift
//  Morari Bapu
//
//  Created by Bhavin Chauhan on 01/10/18.
//  Copyright © 2018 Bhavin Chauhan. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import SwiftyJSON
import AudioPlayerManager


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var reachability: Reachability?

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
      //IQKeyboardManager Library
      IQKeyboardManager.shared.enable = true

      
      if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: {_, _ in })
      } else {
        let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
      }
      
      application.registerForRemoteNotifications()
      
      //Internet checking
      self.reachability = Reachability()

      do
      {
        try reachability?.startNotifier()
      }
      catch
      {
        print( "ERROR: Could not start reachability notifier.")
      }
      
        return true
    }
  
  
    class func sharedAppDelegate() -> AppDelegate?
    {
      return UIApplication.shared.delegate as? AppDelegate
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
      
      UserDefaults.standard.set("", forKey: "playposition")
      UserDefaults.standard.set("", forKey: "screentype")
      
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Morari_Bapu")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
  {
    var token = ""
    for i in 0..<deviceToken.count {
      token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
    }
    print(token)
    
    UserDefaults.standard.set(token, forKey: "fcmToken")

    print("deviceToken: \(token)")
    
  }

  // MARK: - Remote control
  
  override func  remoteControlReceived(with event: UIEvent?) {
    AudioPlayerManager.shared.remoteControlReceivedWithEvent(event)
  }
  
}


// [START ios_10_message_handling]
extension AppDelegate : UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
  {
    let userInfo = notification.request.content.userInfo
    
    
    completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    
    let jsonResponce = JSON(userInfo)
    
    print("Notification Responce:\(jsonResponce)")
    
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    
    
    //Notification Badges Count
    
    let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
    UIApplication.shared.applicationIconBadgeNumber = currentBadgeNumber + 1
    
    let jsonResponce = JSON(userInfo)
    
   
    if UIApplication.shared.applicationState == UIApplication.State.active {
      
      DispatchQueue.main.async {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifications"), object: jsonResponce)
      }
      
    }
    else if UIApplication.shared.applicationState == UIApplication.State.inactive{
      
      DispatchQueue.main.async {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifications"), object: jsonResponce)
      }
      
    }
    else if UIApplication.shared.applicationState == UIApplication.State.background{
      DispatchQueue.main.async {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifications"), object: jsonResponce)
      }
    }
    
    print("Notification Responce:\(jsonResponce)")
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
    
    //Notification Badges Count
    let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
    UIApplication.shared.applicationIconBadgeNumber = currentBadgeNumber + 1
    
    let jsonResponce = JSON(userInfo)
    
    print("Notification Responce:\(jsonResponce)")

    
  }
  
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    
    
    let jsonResponce = JSON(userInfo)
    
    print("Notification Responce:\(jsonResponce)")
    
    if UIApplication.shared.applicationState == UIApplication.State.active {
      completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])

    }
    
    
    completionHandler([])
      
    }
  
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    let jsonResponce = JSON(userInfo)
    
    print("Notification Responce:\(jsonResponce)")
    
    
    if UIApplication.shared.applicationState == UIApplication.State.active {
      
        DispatchQueue.main.async {
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifications"), object: jsonResponce)
        }
      
    }
    else if UIApplication.shared.applicationState == UIApplication.State.inactive{
      
      DispatchQueue.main.async {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifications"), object: jsonResponce)
      }
    
    }
    
    
    completionHandler()
  }
  
}



