//
//  AppDelegate.swift
//  CoreML-Vision-Demo
//
//  Created by 小豌先生 on 2024/4/18.
//  Copyright © 2024 小豌先生. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()

        let vc  = ViewController()
        let nav = UINavigationController.init(rootViewController:vc)
        self.window?.rootViewController =  nav
        return true
    }
}
