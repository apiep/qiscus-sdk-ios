//
//  AppDelegate.swift
//  Example
//
//  Created by Ahmad Athaullah on 7/17/16.
//  Copyright © 2016 Ahmad Athaullah. All rights reserved.
//

import UIKit
import Qiscus

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, QiscusConfigDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        if !Qiscus.isLoggedIn{
            goToLoginView()
        }else{
            Qiscus.connect(delegate: self)
            goToRoomList()
            //goToChatNavigationView()
        }
        
        Qiscus.registerNotification()
        
        //Chat view styling
        Qiscus.style.color.leftBaloonColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        Qiscus.style.color.welcomeIconColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        Qiscus.style.color.leftBaloonTextColor = UIColor.white
        Qiscus.style.color.rightBaloonColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        Qiscus.style.color.rightBaloonTextColor = UIColor.white
        Qiscus.style.color.rightBaloonLinkColor = UIColor.white
        Qiscus.setGradientChatNavigation(UIColor.black, bottomColor: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), tintColor: UIColor.white)
        Qiscus.iCloudUploadActive(true)
        window?.makeKeyAndVisible()
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Qiscus.didRegisterUserNotification(withToken:deviceToken)
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        //Qiscus.didRegisterUserNotification()
    }
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        Qiscus.didReceiveNotification(notification: notification)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("hellooo ...")
       Qiscus.didReceive(RemoteNotification:userInfo)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("\(error)")
    }
    func goToRoomList(){
        let roomList = RoomListVC()
        self.navigationController = UINavigationController(rootViewController:roomList)
        window?.rootViewController = navigationController
    }
    func goToChatNavigationView(){
        let chatView = goToChatVC()
        self.navigationController = UINavigationController(rootViewController: chatView)
        window?.rootViewController = navigationController
    }
    
    func goToLoginView(){
        let mainView = MainView()
        let navigationController = UINavigationController(rootViewController: mainView)
        window?.rootViewController = navigationController
    }
    
    func qiscusLogin(withAppId: String, userEmail: String, userKey:String, username: String){
        Qiscus.setup(withAppId: withAppId, userEmail: userEmail, userKey: userKey, username: username,delegate: self, secureURl: false)
    }
    
    // MARK: - QiscusConfigDelegate
    func qiscusFailToConnect(_ withMessage:String){
        print(withMessage)
    }
    func qiscusConnected(){
        self.goToRoomList()
        //self.goToChatNavigationView()
    }
    func qiscus(gotSilentNotification comment: QComment) {
        Qiscus.createLocalNotification(forComment: comment)
    }
    func qiscus(didTapLocalNotification comment: QComment, userInfo: [AnyHashable : Any]?) {
        let view = Qiscus.chatView(withRoomId: comment.roomId)
        let chatView = goToChatVC()
        self.navigationController = UINavigationController(rootViewController: chatView)
        window?.rootViewController = navigationController
        view.titleAction = {
            print("title clicked")
        }
        view.forwardAction = {(comment) in
            view.navigationController?.popViewController(animated: true)
            comment.forward(toRoomWithId: 13006)
            let newView = Qiscus.chatView(withRoomId: 13006)
            self.navigationController?.pushViewController(newView, animated: true)
        }
        self.navigationController?.pushViewController(view, animated: true)
    }
}

