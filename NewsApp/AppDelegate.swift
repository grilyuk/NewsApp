//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Григорий Данилюк on 07.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow.init(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

