//
//  AppDelegate.swift
//  CityList-Swift
//
//  Created by 苏沫离 on 2020/9/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        let vc = CityListViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        nav.navigationBar.isTranslucent = false
        window.rootViewController = nav
        
        return true
    }
}

