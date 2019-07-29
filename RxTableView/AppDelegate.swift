//
//  AppDelegate.swift
//  RxTableView
//
//  Created by Milkyo on 29/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window

        let startViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: startViewController)

        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
}
