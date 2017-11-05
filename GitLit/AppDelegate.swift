//
//  AppDelegate.swift
//  GitLit
//
//  Created by Emil Astanov on 21.10.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        checkAuth()
        return true
    }
    func checkAuth(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if UserDefaults.standard.string(forKey: "token") != nil{
            print("User already login")
            self.window?.rootViewController = sb.instantiateViewController(withIdentifier: "Handler")
        } else {
            print("Undefined user")
            self.window?.rootViewController = sb.instantiateViewController(withIdentifier: "AuthVC")
        }
    }
}

