//
//  JMRouter.swift
//  JMRouter
//
//  Created by yangyuan on 2017/6/29.
//  Copyright © 2017年 huan. All rights reserved.
//

import UIKit

// MARK: - Router

public typealias JMRouterCompletionClosure = (Bool, Any?) -> Void

/// 支持跳转controller或执行特定action

/// 1. 跳转界面可以用类似下面格式url
/// scheme1://page/map?title="地图"

/// 2. 执行action可以用类似下面格式url
/// scheme2://action/tel?phone=xxxxxx

public enum JMRouter {
    /// 支持的schemes
    public static let schemes = ["scheme1", "scheme2", "scheme3"]
    
    /// 检查urlString是否是合法schema
    public static func validateUrl(_ urlString: String?) -> Bool {
        return validateUrlPageable(urlString) || validateUrlActionable(urlString)
    }
    
    /// 通过url 来跳转对应页面, 或执行某个action
    ///
    /// - Parameters:
    ///   - url: url字符串
    ///   - object: 额外的参数
    ///   - vc: 优先使用传入的controller来执行跳转或action，否则会自动寻找当前的controller
    ///   - completion: routing完成后的回调（有动画会异步），Bool同return的返回值；注意：如果是push(animated: true)成功的，completion在0.35s后调用，这个是自定义的时间。
    /// - Returns: 如果找到了对应的page并跳转成功，或执行了对应action，返回true
    @discardableResult
    public static func routing(url: String?, object: Any? = nil, from vc: UIViewController? = nil, completion: JMRouterCompletionClosure? = nil) -> Bool {
        
        /// 将completion回调的执行放到defer中
        var result: Any? = nil
        var excuteCompletion = true
        defer {
            if let completion = completion, excuteCompletion {
                completion(result != nil, result)
            }
        }
        
        guard let encodedUrl = url?.toURL() else {
            return false
        }
        
        /// 将query的值解码并转换成字典
        var decodedQueryParameters: [String:String] = [:]
        if let queryParameters = encodedUrl.queryParameters {
            for (key, value) in queryParameters {
                decodedQueryParameters[key] = value.urlDecoded()
            }
        }
        
        /// 约定的字符串
        let mappingWord = encodedUrl.lastPathComponent
        
        /// 跳转页面
        if validateUrlPageable(url) {
            guard let page = JMRouter.Page(rawValue: mappingWord) else {
                return false
            }
            excuteCompletion = false
            return goto(page, url: url, parameters: decodedQueryParameters, object: object, from: vc, completion: completion) != nil
        }
        
        /// 执行action
        if validateUrlActionable(url) {
            guard let action = JMRouter.Action(rawValue: mappingWord) else {
                return false
            }
            excuteCompletion = false
            return run(action, url: url, parameters: decodedQueryParameters, object: object, from: vc, completion: completion)
        }
        
        return false
    }
}


extension JMRouter {
    /// 跳转方式
    public enum Animation {
        case push(animated: Bool)
        case present(animated: Bool)
    }
}





