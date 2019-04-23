//
//  JMRouter+Page.swift
//  JMProject
//
//  Created by yangyuan on 2018/11/8.
//  Copyright © 2018 huan. All rights reserved.
//

import UIKit

// MARK: - JMPage的实现
public extension JMRouter {
    struct Page: JMPage {
        static let host = "page"
        
        public let rawValue: String
        public init(_ name: String) {
            self.rawValue = name
        }
    }
}

private extension JMPage {
    func toRoutePage() -> JMRoutable.Type? {
        guard let className = JMRouter.pagePathMap[rawValue] else {
            return nil
        }
        
        return className.toClass() as? JMRoutable.Type
    }
}

extension JMRouter {
    /// 类名和枚举值的映射表
    static var pagePathMap = [String: String]()
    
    /// 遍历所有的类，检测是否实现Routable，存入字典作为映射表，使用Router前必须先调用
    static func registerPathMap(with appDelegate: UIApplicationDelegate) {
        var count: UInt32 = 0
        
        guard let classes = objc_copyClassNamesForImage(class_getImageName(object_getClass(appDelegate))!, &count) else {
            return
        }
        
        for i in 0 ..< Int(count) {
            if let clsName = String(cString: classes[i], encoding: .utf8)?.components(separatedBy: ".").last {
                if let cls = clsName.toClass() as? JMRoutable.Type {
                    pagePathMap.updateValue(clsName, forKey: cls.routePath.rawValue)
                }
            }
        }
    }
}

public extension JMRouter {
    static func validatePageUrl(_ urlString: String) -> Bool {
        guard let url = urlString.toURL(),
            let scheme = url.scheme,
            schemes.contains(scheme),
            url.host == Page.host else {
                return false
        }
        return true
    }
    
    /// 通过枚举来跳转对应页面
    @discardableResult
    static func goto(_ page: JMPage,
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
            let toVC = page.routePageCreate(with: url ?? "", parameters: parameters, object: object) else {
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

// MARK: - Extension
private extension UIViewController {
    //获取app当前最顶层的ViewController
    static var appTopVC: UIViewController? {
        var resultVC: UIViewController?
        resultVC = UIApplication.shared.keyWindow?.rootViewController?.topVC
        while resultVC?.presentedViewController != nil {
            resultVC = resultVC?.presentedViewController?.topVC
        }
        return resultVC
    }
    
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

private extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
}


