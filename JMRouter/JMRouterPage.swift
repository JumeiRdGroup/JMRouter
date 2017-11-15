//
//  JMRouterPage.swift
//  JMRouter
//
//  Created by yangyuan on 2017/7/5.
//  Copyright © 2017年 huan. All rights reserved.
//

import UIKit

// MARK: - Page相关

public extension JMRouter {
    public static let pageHost = "page"
    public static let pageRoot = schemes.first ?? "router" + "://" + JMRouter.pageHost + "/"
    
    /// 类名和枚举值的映射表
    public static var pagePathMap:[JMRouter.Page: String] = [:]
    
    /// 遍历所有的类，检测是否实现Routable，存入字典作为映射表，使用Router前必须先调用
    public static func registerPagePathMap() {
        var cout = UInt32(0)
        guard let classes = objc_copyClassNamesForImage(class_getImageName(AppDelegate.self)!, &cout) else {
            return
        }
        for i in 0 ..< Int(cout) {
            if let clsName = String(cString: classes[i], encoding: .utf8)?.components(separatedBy: ".").last {
                if let clss = clsName.toClass() as? Routable.Type {
                    pagePathMap.updateValue(clsName, forKey: clss.routePath)
                }
            }
        }
    }
    
    /// 检查urlString是否是合法page schema
    public static func validateUrlPageable(_ urlString: String?) -> Bool {
        guard let url = urlString?.toURL(),
            let scheme = url.scheme,
            schemes.contains(scheme),
            url.host == pageHost else {
                return false
        }
        return true
    }
    
    /// 通过枚举来跳转对应页面
    @discardableResult
    public static func goto(_ page: JMRouter.Page, url: String? = nil, parameters: [String : String]? = nil, object: Any? = nil, from vc: UIViewController? = nil, completion: JMRouterCompletionClosure? = nil) -> UIViewController? {
        
        /// 将completion回调的执行放到defer中
        var result: UIViewController? = nil
        var delayCompletion = false
        var excuteCompletion = true
        defer {
            if let completion = completion, excuteCompletion {
                if delayCompletion {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35, execute: {
                        completion(result != nil, result)
                    })
                } else {
                    completion(result != nil, result)
                }
            }
        }
        
        /// 找到要跳转的vc
        guard let page = page.toRoutePage(),
            let toVC = page.routePageCreate(url: url ?? page.routeUrl, parameters: parameters, object: object) else {
                return nil
        }
        
        /// 优先使用传入的vc，否则使用app top
        guard let finalViewController = vc ?? UIViewController.appTopVC else {
            return nil
        }
        
        switch page.routeAnimation {
        case .push(let animated):
            guard let navigationVC = (finalViewController as? UINavigationController) ?? finalViewController.navigationController else {
                completion?(false, nil)
                return nil
            }
            navigationVC.pushViewController(toVC, animated: animated)
            
            delayCompletion = animated /// 如果是push动画方式，0.35秒后执行completion
            
        case .present(let animated):
            excuteCompletion = false
            
            finalViewController.present(toVC, animated: animated) {
                completion?(true, toVC)
            }
        }
        
        result = toVC
        return toVC
    }
}


// MARK: - 支持的pages

extension JMRouter {
    /// 声明哪些controller支持路由跳转
    public enum Page: String {
        case home
        case vc1 //key和约定的字符串一致时
        case vc2 = "nibVc" //key和约定的字符串不一致时
    }
}

extension JMRouter.Page {
    /// 转换成实现协议的类
    public func toRoutePage() -> Routable.Type? {
        guard let className = JMRouter.pagePathMap[self] else {
            return nil
        }
        return className.toClass() as? Routable.Type
    }
}







