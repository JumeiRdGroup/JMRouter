//
//  JMRouter.swift
//  JMRouter
//
//  Created by yangyuan on 2017/6/29.
//  Copyright © 2017年 huan. All rights reserved.
//

import UIKit

// MARK: - Router

/// 支持跳转controller

/// 1. 跳转界面可以用类似下面格式url
/// scheme1://page/map?title="地图"


public extension JMRouter {
    /// 遍历所有的类，检测是否实现Routable，存入字典作为映射表，使用Router前必须先调用
    static func setup(with appDelegate: UIApplicationDelegate,
                      schemes: [String],
                      pageHost: String = "page") {
        JMRouter.pageHost = pageHost
        JMRouter.schemes = schemes
        JMRouter.registerPathMap(with: appDelegate)
    }
}

open class JMRouter {
    public typealias Completion = (Bool, Any?) -> Void
    
    /// 支持的schemes
    public static private(set) var schemes = [""]
    public static private(set) var pageHost = "page"
    
    /// 检查urlString是否是合法scheme
    open class func validateUrl(_ urlString: String) -> Bool {
        return validatePageUrl(urlString)
    }
    
    /// 通过url 来跳转对应页面, 或执行某个action
    ///
    /// - Parameters:
    ///   - urlString: url字符串
    ///   - object: 额外的参数
    ///   - vc: 优先使用传入的controller来执行跳转或action，否则会自动寻找当前的controller
    ///   - completion: routing完成后的回调（有动画会异步），Bool同return的返回值
    /// - Returns: 如果找到了对应的page并跳转成功，或执行了对应action，返回true
    @discardableResult
    open class func routing(with urlString: String,
                            object: Any? = nil,
                            from vc: UIViewController? = nil,
                            completion: Completion? = nil) -> Bool {
        /// 将completion回调的执行放到defer中
        var result: Any? = nil
        var excuteCompletion = true
        defer {
            if let completion = completion, excuteCompletion {
                completion(result != nil, result)
            }
        }
        
        guard let url = urlString.toURL() else {
            return false
        }
        
        /// 将query的值转换成字典
        let queryParameters = url.queryParameters
        
        /// 约定的字符串
        let mappingWord = url.lastPathComponent
        
        /// 跳转页面
        if validatePageUrl(urlString) {
            excuteCompletion = false
            return goto(mappingWord, url: urlString, parameters: queryParameters, object: object, from: vc, completion: completion) != nil
        }
        
        return false
    }
}





