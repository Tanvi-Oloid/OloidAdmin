//
//  AppDelegate.swift
//  OloidAdmin
//
//  Created by Tanvi Mittal on 29/05/20.
//  Copyright © 2020 Tanvi Mittal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       //moveDirectRootPage()
        
        return true
    }
    
    func moveDirectRootPage()
    {
        DispatchQueue.main.async {
            
            let storyBoard = UIStoryboard.init(name: "Admin", bundle:.main)
            
            let navVC = storyBoard.instantiateInitialViewController() as! UINavigationController
            
            let loginVc = navVC.viewControllers.first as! AdminLoginViewController
            
            
            self.window?.rootViewController = loginVc
        }
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

