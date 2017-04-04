//
//  AppDelegate.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.setupViews();
        return true
    }

    func setupViews() {
        //default setup for navigation bar.
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white;
        navigationBarAppearace.setBackgroundImage(UIImage(),
                                                  for: .any,
                                                  barMetrics: .default);
        navigationBarAppearace.barTintColor = UIColor().myGifGreenColor();
        navigationBarAppearace.backgroundColor = UIColor.white;
        navigationBarAppearace.shadowImage = UIImage();
        navigationBarAppearace.isTranslucent = false;
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white];
    }
}

