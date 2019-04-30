//
//  JMRouterFoundation.swift
//  JMRouter
//
//  Created by yangyuan on 2017/7/3.
//  Copyright © 2017年 huan. All rights reserved.
//

import UIKit

// MARK: - 跳转方式
public extension JMRouter {
    enum Animation {
        case push(animated: Bool)
        case present(animated: Bool)
    }
}

// MARK: - 表示一个页面的协议，rawValue是为了enum的支持
public protocol JMRoutePage {
    var rawValue: String { get }
}

// MARK: - 路由协议 controller实现这个协议，表示支持路由跳转
public protocol JMRoutable {
    /// 路由界面唯一标志
    static var routePage: JMRoutePage { get }
    
    /// 路由界面出现的动画方式，目前只有 push, present，默认为push(animated:true)
    static var routeAnimation: JMRouter.Animation { get }
    
    /// 路由界面如何生成
    static func routePageCreated(with scheme: String?, parameters: [String : String]?, object: Any?) -> UIViewController?
}

/// 一些默认值
public extension JMRoutable {
    static var routeAnimation: JMRouter.Animation {
        return .push(animated:true)
    }
}



// MARK: - Extensions

extension String {
    var isNotBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty
    }
    
    func urlEncoded() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    func urlDecoded() -> String? {
        return removingPercentEncoding
    }
    
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    func toClass() -> AnyClass? {
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            
            let classStringName = "_TtC\(appName.count)\(appName)\(self.count)\(self)"
            let cls: AnyClass?  = NSClassFromString(classStringName)
            return cls
        }
        return nil;
    }
}

extension URL {
    var queryParameters: [String: String]? {
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
    static var appTopViewController: UIViewController? {
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
    var topVC: UIViewController? {
        if self.isKind(of: UINavigationController.self) {
            return (self as! UINavigationController).topViewController?.topVC
        } else if self.isKind(of: UITabBarController.self) {
            return (self as! UITabBarController).selectedViewController?.topVC
        } else {
            return self
        }
    }
}

extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
}
