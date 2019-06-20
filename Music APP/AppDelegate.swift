//
//  AppDelegate.swift
//  Music APP
//
//  Created by Ashutosh Jani on 19/09/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import FBSDKLoginKit
import GoogleSignIn
import FirebaseMessaging
import UserNotifications
import FirebaseInstanceID
import GoogleMobileAds



let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    var timer = Timer()
    var FcmId : String? {
        return InstanceID.instanceID().token()
    }

    var apiString = "http://3.82.73.198/radiorevolution/api/"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        GIDSignIn.sharedInstance().clientID = "271052699806-bk7j2b1pninujk2pg9g4ujs69bsciqls.apps.googleusercontent.com"
        SVProgressHUD.setDefaultMaskType(.clear)

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
//            let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
//                                                    title: "Accept",
//                                                    options: UNNotificationActionOptions(rawValue: 0))
//            let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
//                                                     title: "Decline",
//                                                     options: UNNotificationActionOptions(rawValue: 0))
            if #available(iOS 11.0, *) {
//                let UserRequest =
//                    UNNotificationCategory(identifier: "user_request",
//                                           actions: [acceptAction, declineAction],
//                                           intentIdentifiers: [],
//                                           hiddenPreviewsBodyPlaceholder: "",
//                                           options: .customDismissAction)
//                UNUserNotificationCenter.current().setNotificationCategories([UserRequest])
                
            } else {
                // Fallback on earlier versions
            }
            Messaging.messaging().delegate = self
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-2864538952219635~1076394322")
        //GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544~1458002511")
        guard let gai = GAI.sharedInstance() else
        {
            assert(false, "Google Analytics not configured correctly")
            return true
        }
        gai.tracker(withTrackingId: "YOUR_TRACKING_ID")
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true

        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }


    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        FBSDKAppEvents.activateApp()
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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        Messaging.messaging().apnsToken = deviceToken
        print(deviceTokenString)
        if let refreshedToken = InstanceID.instanceID().token()
        {
            print(refreshedToken)
            
        }
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
        UNUserNotificationCenter.current().getNotificationSettings(){ (settings) in
            
            switch settings.soundSetting{
            case .enabled:
                
                print("enabled sound setting")
                
            case .disabled:
                
                print("setting has been disabled")
                
            case .notSupported:
                print("something vital went wrong here")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo["reference_id"] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        
        let userInfo = response.notification.request.content.userInfo
        let dict = userInfo["aps"] as! NSDictionary
        
        var messageBody:String?
        var messageTitle:String = "Alert"
        
        if let alertDict = dict["alert"] as? Dictionary<String, String> {
            messageBody = alertDict["body"]!
            if alertDict["title"] != nil { messageTitle  = alertDict["title"]! }
            
        } else {
            messageBody = dict["alert"] as? String
        }
        print(messageTitle)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        switch response.actionIdentifier
        {
        case "ACCEPT_ACTION":
            //acceptRequestAPI(friendId: (userInfo["friend_request_id"] as! String))
            print("accepted")
        case "DECLINE_ACTION":
            //declineRequestAPI(friendId: (userInfo["friend_request_id"] as! String))
            print("declined")
        default:
            
            print("no option selected")
            
        }
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        let dict = notification.request.content.userInfo["aps"] as! NSDictionary
        
        var messageBody:String?
        var messageTitle:String = "Alert"
        
        if let alertDict = dict["alert"] as? Dictionary<String, String> {
            messageBody = alertDict["body"]!
            if alertDict["title"] != nil { messageTitle  = alertDict["title"]! }
            
        } else {
            messageBody = dict["alert"] as? String
        }
        
        print("Message body is \(messageBody!) ")
        print("Message messageTitle is \(messageTitle) ")
        
        
        
        print(userInfo)
        completionHandler([.alert, .sound])
        
    }
    func application(received remoteMessage: MessagingRemoteMessage)
    {
        print(remoteMessage.appData)
        Messaging.messaging().appDidReceiveMessage(remoteMessage.appData)
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String)
    {
        Messaging.messaging().shouldEstablishDirectChannel = true
        
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage)
    {
        print(remoteMessage.appData)
    }


}

