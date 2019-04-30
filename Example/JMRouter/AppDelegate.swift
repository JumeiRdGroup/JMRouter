//
//  AppDelegate.swift
//  JMRouter
//
//  Created by yuany on 04/30/2019.
//  Copyright (c) 2019 yuany. All rights reserved.
//

import UIKit
@_exported import JMRouter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
         JMRouter.setup(with: self, schemes: ["scheme1", "scheme2", "scheme3"])
        
        return true
    }
}

/// 声明哪些controller支持路由跳转
enum Page: String, JMRoutePage {
    case home
    case vc1 //key和约定的字符串一致时
    case vc2 = "nibVc" //key和约定的字符串不一致时
}
