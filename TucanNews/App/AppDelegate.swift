//
//  AppDelegate.swift
//  TucanNews
//
//  Created by Illia Wezarino on 13.09.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      window = UIWindow(frame: UIScreen.main.bounds)
        
      window?.backgroundColor = .black
      window?.rootViewController = UINavigationController(rootViewController: NewsListController())
      window?.makeKeyAndVisible()
      
      return true
    }

}
