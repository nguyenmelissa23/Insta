//
//  AppDelegate.swift
//  Insta
//
//  Created by Melissa Phuong Nguyen on 2/26/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "instav"
                configuration.clientKey = "djvnd39dd0f;f_ffffff2d#%"
                configuration.server = "https://instav.herokuapp.com/parse"
            })
        )
        
        if PFUser.current() != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            view controller currently being set in Storyboard as default will be overridden
            let tabbarVC = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            //            print("tabbarVC", tabbarVC)
            //            print("tabbarVC [0]", tabbarVC.viewControllers![0])
//            let navVC = tabbarVC.viewControllers![0] as! UINavigationController
//            let postsVC = navVC as! PostsViewController
            window?.rootViewController = tabbarVC
            
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("didLogout"), object: nil, queue: OperationQueue.main) { (Notification) in
            print("Logout notification received")

        }
        
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
        
        return true
    }

    func logout(){
        PFUser.logOutInBackground(block: { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Successful loggout")
                // Load and show the login view controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController")
                self.window?.rootViewController = loginViewController
            }
        })
    }
    
//    func returnToHome(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let homeViewController = storyboard.instantiateViewController(withIdentifier: "postsViewController")
//
//        self.window?.rootViewController = homeViewController
//    }
    
    
    
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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

