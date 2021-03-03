//
//  AppDelegate.swift
//  Pharmacy
//  Created by osx on 13/01/20.
//  Copyright © 2020 osx. All rights reserved.


import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import FirebaseMessaging

@available(iOS 13.0, *)
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    var window: UIWindow?
    var deviceTokenString = ""
    var gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = UIColor.white
        
        IQKeyboardManager.shared.enable = true
        
        GMSServices.provideAPIKey("AIzaSyCHLhPXla2B8BZESBtz3cgmbgwkijKIWVc")
        GMSPlacesClient.provideAPIKey("AIzaSyCHLhPXla2B8BZESBtz3cgmbgwkijKIWVc")
        
        ConnectSocket.shared.addHandler()
        FirebaseApp.configure()
        
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
             Messaging.messaging().delegate = self
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        ConnectSocket.shared.connectSocket()
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
          print(deviceTokenString)
          UserDefaults.standard.setValue(deviceToken, forKey: deviceTokenString)
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
          print("i am not available in simulator :( \(error)")
    }
    
      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
          // If you are receiving a notification message while your app is in the background,
          // this callback will not be fired till the user taps on the notification launching the application.
          // TODO: Handle data of notification
          // With swizzling disabled you must let Messaging know about the message, for Analytics
          // Messaging.messaging().appDidReceiveMessage(userInfo)
        
          // Print message ID.
          if let messageID = userInfo[gcmMessageIDKey] {
              print("Message ID: \(messageID)")
          }
        
            //Print full message.
            print(userInfo)
      }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        let title = userInfo["title"] as! String
        self.scheduleNotification(title:title)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func scheduleNotification(title:String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest.init(identifier: "request", content:content, trigger: nil)
        UNUserNotificationCenter.current().add((request), withCompletionHandler: {error in
            print(error as Any)
        })
    }
    
      func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
          print("Firebase registration token: \(fcmToken)")
                          
          UserDefaults.standard.setValue(fcmToken, forKey: "fcmToken")
          let dataDict:[String: String] = ["device_token": fcmToken]
        
        //NetworkingService.shared.getData_HeaderParameter(PostName: Constants.notificationPush, parameters: dataDict) { (response) in
        //print(response)
        // }
        
          NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
          // TODO: If necessary send token to application server.
          // Note: This callback is fired at each app startup and whenever a new token is generated.
      }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
          let userInfo = notification.request.content.userInfo
          // With swizzling disabled you must let Messaging know about the message, for Analytics
          // Messaging.messaging().appDidReceiveMessage(userInfo)
          // Print message ID.
          if let messageID = userInfo[gcmMessageIDKey] {
              print("Message ID: \(messageID)")
          }
        
        
          // Print full message.
          print(userInfo)
          // Change this to your preferred presentation option
          completionHandler([.alert,.sound,.badge])
      }
      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
          let userInfo = response.notification.request.content.userInfo
          // Print message ID.
          if let messageID = userInfo[gcmMessageIDKey] {
              print("Message ID: \(messageID)")
          }
          // Print full message.
          print(userInfo)
          completionHandler()
      }
}

 
