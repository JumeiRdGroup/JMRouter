//
//  JMRouterFoundation.swift
//  JMRouter
//
//  Created by yangyuan on 2017/7/3.
//  Copyright © 2017年 huan. All rights reserved.
//

import UIKit

/// 路由协议 controller实现这个协议，表示支持路由跳转
public protocol Routable {
    /// 路由界面出现的动画方式，目前只有 push, present，默认为push(animated:true)
    static var routeAnimation: JMRouter.Animation { get }
    
    /// 路由完整路径，默认为pageRoot + routePath
    static var routeUrl: String { get }
    
    /// 路由界面唯一标志
    static var routePath: JMRouter.Page { get }
    
    /// 路由界面如何生成
    static func routePageCreate(url: String, parameters: [String : String]?, object: Any?) -> UIViewController?
}

/// 一些默认值
public extension Routable {
    static var routeUrl: String { return JMRouter.pageRoot + routePath.rawValue + "/"}
    static var routeAnimation: JMRouter.Animation { return .push(animated:true) }
}


// MARK: - Extensions

extension String {
    public var isNotBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty
    }
    
    public func urlEncoded() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    public func urlDecoded() -> String? {
        return removingPercentEncoding
    }
    
    public func toURL() -> URL? {
        if let urlString = urlEncoded() {
            return URL(string: urlString)
        }
        return nil
    }
    
    public func toClass() -> AnyClass? {
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            
            let classStringName = "_TtC\(appName.count)\(appName)\(self.count)\(self)"
            let cls: AnyClass?  = NSClassFromString(classStringName)
            return cls
        }
        return nil;
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}

extension UIViewController {
    //获取app当前最顶层的ViewController
    public static var appTopVC: UIViewController? {
        var resultVC: UIViewController?
        resultVC = UIApplication.shared.keyWindow?.rootViewController?.topVC
        while resultVC?.presentedViewController != nil {
            resultVC = resultVC?.presentedViewController?.topVC
        }
        return resultVC
    }
    
    /**< 3种情况
     1. UINavigationController.topViewController
     2. UITabBarController.selectedViewController
     3. UIViewController 自己
     */
    public var topVC: UIViewController? {
        if self.isKind(of: UINavigationController.self) {
            return (self as! UINavigationController).topViewController?.topVC
        } else if self.isKind(of: UITabBarController.self) {
            return (self as! UITabBarController).selectedViewController?.topVC
        } else {
            return self
        }
    }
}

public extension JMRouter {
    static func makePhoneCall(_ number: String?) {
        guard let number = number, number.isNotBlank else { return }
        let url = "tel://" + number
        openUrl(url)
    }
    
    static func openUrl(_ url: String) {
        guard let url = url.toURL() else { return }
        let application = UIApplication.shared
        if !application.canOpenURL(url) {
            print("无法打开\(url) 请确保此应用已经正确安装")
            return
        }
        
        if #available(iOS 10.0, *) {
            application.open(url, options: [:]) { (_) in
                
            }
        } else {
            application.openURL(url)
        }
    }
}
