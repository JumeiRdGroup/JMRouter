//
//  JMRouter.swift
//  JMProject
//
//  Created by yangyuan on 2018/11/8.
//  Copyright © 2018 huan. All rights reserved.
//

import UIKit

/// 支持跳转controller或执行特定action

/// 1. 跳转界面可以用类似下面格式url
/// scheme1://page/map?title="地图"

/// 2. 执行action可以用类似下面格式url
/// scheme2://action/tel?phone=xxxxxx

public extension JMRouter {
    /// 遍历所有的类，检测是否实现Routable，存入字典作为映射表，使用Router前必须先调用
    static func setup(with appDelegate: UIApplicationDelegate, schemes: [String]) {
        JMRouter.schemes = schemes
        JMRouter.registerPathMap(with: appDelegate)
    }
}


final public class JMRouter {
	public typealias Completion = (Bool, Any?) -> Void
	
    /// 支持的schemes
    public static private(set) var schemes = [""]
	
    /// 检查urlString是否是合法scheme
    public static func validateUrl(_ urlString: String) -> Bool {
        return validatePageUrl(urlString) || validateActionUrl(urlString)
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
    public static func routing(with urlString: String, object: Any? = nil, from vc: UIViewController? = nil, completion: Completion? = nil) -> Bool {
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
            let page = Page(mappingWord)
            return goto(page, url: urlString, parameters: queryParameters, object: object, from: vc, completion: completion) != nil
        }
        
        /// 执行action
        if validateActionUrl(urlString) {
            guard let action = Action(rawValue: mappingWord) else {
                return false
            }
            excuteCompletion = false
            return run(action, url: urlString, parameters: queryParameters, object: object, from: vc, completion: completion)
        }
        
        return false
    }
}


private extension URL {
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
