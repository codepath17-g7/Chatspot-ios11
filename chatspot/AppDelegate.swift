//
//  AppDelegate.swift
//  chatspot
//
//  Created by Syed Hakeem Abbas on 10/8/17.
//  Copyright © 2017 g7. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import Firebase
import FirebaseAuthUI
import GTMSessionFetcher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init() {
        FirebaseApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Successfully running this sample requires an app in Firebase and an
        // accompanying valid GoogleService-Info.plist file.
        // handleUserAuthentication()
        GTMSessionFetcher.setLoggingEnabled(true)
        UIApplication.shared.statusBarStyle = .lightContent
        
        // check if app (terminated by system) was launched in background as a result of location change
        if launchOptions?[UIApplicationLaunchOptionsKey.location] != nil {
            print("app killed by sytem launched by a location update")
            LocationManager.instance.listenForSignificantLocationChanges()
        }
        /** Commented as we are listening for location in AuthVC incase a logged in user is found **/
        //else if Auth.auth().currentUser != nil {
            // when current user is not nil start listening to realtime location update
        //    print("found a logged in user, starting realtime location")
        //    LocationManager.instance.listenForRealtimeLocationChanges()
        //}
        
        
        UINavigationBar.appearance().barTintColor = UIColor.ChatSpotColors.Red
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Libertad-Bold", size: 20)!]

        UINavigationBar.appearance().tintColor = .white
        UITabBar.appearance().tintColor = UIColor.ChatSpotColors.Red
        UITabBar.appearance().barTintColor = UIColor.white
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
       // return self.handleOpenUrl(url, sourceApplication: sourceApplication)
       return  (FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication))!
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //return self.handleOpenUrl(url, sourceApplication: sourceApplication)
        return (FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication))!
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(notification)
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
        }
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
        LocationManager.instance.stopListeningSignificantChanges()
        LocationManager.instance.listenForRealtimeLocationChanges()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        LocationManager.instance.listenForSignificantLocationChanges()
    }
    
    func handleOpenUrl(_ url: URL, sourceApplication: String?) -> Bool {
        print("url: \(url)")
       
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func handleUserAuthentication() {
        if Auth.auth().currentUser != nil {
            print("There is a current user")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! ChatListVC
            window?.rootViewController = vc
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "authViewController") as! ChatListVC
            window?.rootViewController = vc
            print("There is no current user")
        }
    }
}

