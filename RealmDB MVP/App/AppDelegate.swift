//
//  AppDelegate.swift
//  RealmDB MVP
//
//  Created by Alisher Tulembekov on 10.04.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let vc = RealmVc()
        let presenter = FullNamesPresentor()
        vc.presentor = presenter
        presenter.view = vc
        window?.rootViewController = UINavigationController(rootViewController: vc)
        
        window?.makeKeyAndVisible()
        return true
    }




}
