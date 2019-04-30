//
//  JMRouterPage.swift
//  JMRouter
//
//  Created by yangyuan on 2017/7/5.
//  Copyright © 2017年 huan. All rights reserved.
//

import UIKit

// MARK: - YYPage的实现
extension String: JMRoutePage {
    public var rawValue: String {
        return self
    }
}

// MARK: - Page相关
public extension JMRouter {
    /// 检查urlString是否是合法page schema
    static func validatePageUrl(_ urlString: String) -> Bool {
        guard let url = urlString.toURL(),
            let scheme = url.scheme,
            schemes.contains(scheme),
            url.host == JMRouter.pageHost else {
                return false
        }
        
        return true
    }
    
    /// 通过枚举来跳转对应页面
    @discardableResult
    static func goto(_ page: JMRoutePage,
                     url: String? = nil,
                     parameters: [String : String]? = nil,
                     object: Any? = nil,
                     from vc: UIViewController? = nil,
                     completion: Completion? = nil) -> UIViewController? {
        /// 将completion回调的执行放到defer中
        var result: UIViewController? = nil
        var excuteCompletion = true
        defer {
            if let completion = completion, excuteCompletion {
                completion(result != nil, result)
            }
        }
        
        /// 找到要跳转的vc
        guard let page = page.toRoutePage(),
            let toVC = page.routePageCreated(with: url ?? "", parameters: parameters, object: object) else {
                return nil
        }
        
        /// 优先使用传入的vc，否则使用app top
        guard let finalViewController = vc ?? UIViewController.appTopViewController else {
            return nil
        }
        
        switch page.routeAnimation {
        case .push(let animated):
            guard let navigationVC = (finalViewController as? UINavigationController) ?? finalViewController.navigationController else {
                completion?(false, nil)
                return nil
            }
            
            if animated {
                excuteCompletion = false
                navigationVC.pushViewController(toVC) {
                    completion?(true, toVC)
                }
            } else {
                navigationVC.pushViewController(toVC, animated: false)
            }
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

extension JMRouter {
    typealias ClassName = String
    typealias PageName = String
    /// 类名和枚举值的映射表
    static var pagePathMap = [PageName: ClassName]()
    
    /// 遍历所有的类，检测是否实现Routable，存入字典作为映射表，使用Router前必须先调用
    static func registerPathMap(with appDelegate: UIApplicationDelegate) {
        var count: UInt32 = 0
        guard let image = class_getImageName(object_getClass(appDelegate)),
            let classes = objc_copyClassNamesForImage(image, &count) else {
                print("JMRouter registerPathMap failed!!!!!!!!!!!!!!!!!!")
                return
        }
        
        for i in 0 ..< Int(count) {
            if let clsName = String(cString: classes[i], encoding: .utf8)?.components(separatedBy: ".").last {
                if let cls = clsName.toClass() as? JMRoutable.Type {
                    pagePathMap.updateValue(clsName, forKey: cls.routePage.rawValue)
                }
            }
        }
    }
}

extension JMRoutePage {
    /// 转换成实现协议的类
    func toRoutePage() -> JMRoutable.Type? {
        guard let className = JMRouter.pagePathMap[rawValue] else {
            return nil
        }
        
        return className.toClass() as? JMRoutable.Type
    }
}













