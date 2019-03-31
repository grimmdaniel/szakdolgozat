//
//  AppDelegate.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 07..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import SwiftyBeaver
import FirebaseCore
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import RealmSwift
import SVProgressHUD

let log = SwiftyBeaver.self
var FCMTOKEN = ""
let gcmMessageIDKey = "gcm.message_id"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let console = ConsoleDestination()
        log.addDestination(console)
        log.info("Application started")
        FirebaseApp.configure()

        setUpRealm()
        
        if #available(iOS 10.0, *) {
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in self.getToken()})
            
            Messaging.messaging().delegate = self
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        getToken()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        let urlString = url.absoluteString
        if urlString.hasSuffix(".pgn"){
            let fileName = url.lastPathComponent == "" ? "temp_\(Date().timeIntervalSince1970).pgn" : url.lastPathComponent
            
            let realm = try! Realm()
            if realm.object(ofType: PGNDatabaseMetadata.self, forPrimaryKey: fileName) == nil{
                do {
                    let fm = FileManager()
                    print(fm.fileExists(atPath: url.path))
                    print(url.startAccessingSecurityScopedResource())
                    if (!fm.fileExists(atPath: url.path)){
                        if fm.isUbiquitousItem(at: url) {
                            print("downloadfrom icloud")
                            do {
                                try fm.startDownloadingUbiquitousItem(at: url)
                                _ = url.startAccessingSecurityScopedResource()
                            } catch{
                                print("Error while loading Backup File \(error)")
                            }
                            if !fm.fileExists(atPath: url.path){
                                return false
                            }
                        }else{
                            print("cant reach file")
                        }
                    }
                    let dataFromFile = fm.contents(atPath: url.path)
                    var content = String(data: dataFromFile!,encoding: .utf8)
                    if content == nil{
                        content = String(data: dataFromFile!,encoding: .windowsCP1252)
                    }
                    if content == nil{
                        let alertController = UIAlertController(title: "Error", message: "File encoding must be UTF-8, or Windows 1252", preferredStyle: .alert)
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                        alertController.addAction(okAction)
                        window!.rootViewController?.present(alertController, animated: true, completion: nil)
                        url.stopAccessingSecurityScopedResource()
                        return true
                    }
                    
                    url.stopAccessingSecurityScopedResource()
                    
                    let date = Date()
                    SVProgressHUD.setForegroundColor(ColorTheme.barczaOrange)
                    SVProgressHUD.show()
                    
                    var metaData: PGNDatabaseMetadata?
                    var pgnDatabase: PGNDatabase?
                    
                    DispatchQueue.background(background: {
                        // do something in background
                        let parser = PGNParser.parser
                        let data = parser.parsePGN(content ?? "")
                        metaData = PGNDatabaseMetadata(name: fileName,creationTime: date)
                        pgnDatabase = PGNDatabase(name: fileName,creationTime: date, database: data)
                    }, completion:{
                        // when background job finished, do something in main thread
                        if let meta = metaData, let database = pgnDatabase{
                            PGNParser.writePGNDatabaseToRealm(metadata: meta, database: database)
                            SVProgressHUD.dismiss()
                            let alertController = UIAlertController(title: "Success", message: "Database added successfully", preferredStyle: .alert)
                            
                            // Create the actions
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                            alertController.addAction(okAction)
                            self.window!.rootViewController?.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
            }else{
                //database already exists
                let alertController = UIAlertController(title: "Error", message: "Database already exists", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alertController.addAction(okAction)
                window!.rootViewController?.present(alertController, animated: true, completion: nil)
            }
            
        }else{
            // file is not pgn
            let alertController = UIAlertController(title: "Error", message: "File format must be pgn", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            window!.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        return true
    }
    
    private func setUpRealm(){
        let cachesDirectoryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        let cachesDirectoryURL = NSURL(fileURLWithPath: cachesDirectoryPath)
        let fileURL = cachesDirectoryURL.appendingPathComponent("Default.realm")
        
        let config = Realm.Configuration(fileURL: fileURL)
        Realm.Configuration.defaultConfiguration = config
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
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func getToken(){
        InstanceID.instanceID().instanceID { (result, error) in
            if (error != nil){
                log.error("Firebase error occurred: \(error!)")
            }else{
                if let result = result{
                    FCMTOKEN = result.token
                }
            }
        }
        return
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    
    // Receive displayed notifications for iOS 10 devices.
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
        print("got message in the foreground iOS10")
        print(userInfo)
        completionHandler([.alert,.badge,.sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        print("got message in the background iOS 10")
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension UIApplication{
    
    var statusBarView: UIView?{
        return value(forKey: "statusBar") as? UIView
    }
}
