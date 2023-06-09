//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Григорий Данилюк on 07.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    lazy var presentationAssembly = PresentationAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let assembly = PresentationAssembly()
        let navigationController = UINavigationController()
        let router = Router(presentationAssembly: assembly, navigationController: navigationController)
        router.initialController()
        window?.rootViewController = navigationController
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        return true
    }
}
