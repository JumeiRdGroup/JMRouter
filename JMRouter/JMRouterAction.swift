//
//  JMRouterAction.swift
//  JMRouter
//
//  Created by yangyuan on 2017/7/5.
//  Copyright © 2017年 huan. All rights reserved.
//

import UIKit

/// MARK: - Action

extension JMRouter {
    public static let actionHost = "action"
    
    /// 检查urlString是否是合法action schema
    public static func validateUrlActionable(_ urlString: String?) -> Bool {
        guard let url = urlString?.toURL(),
            let scheme = url.scheme,
            schemes.contains(scheme),
            url.host == actionHost else {
                return false
        }
        return true
    }
    
    /// 通过枚举来执行action
    @discardableResult
    public static func run(_ action: JMRouter.Action, url: String? = nil, parameters: [String : String]? = nil, object: Any? = nil, from vc: UIViewController? = nil, completion: JMRouterCompletionClosure? = nil) -> Bool {
        
        /// 将completion回调的执行放到defer中
        var result: Any? = nil
        defer {
            if let completion = completion {
                completion(result != nil, result)
            }
        }
        
        
        switch action {
        case .tel:
            let phoneNumber = parameters?["phone"]
            JMRouter.makePhoneCall(phoneNumber)
            result = phoneNumber
            return true
        }
    }
}

// MARK: - 支持的action

extension JMRouter {
    public enum Action: String {
        case tel
    }
}









