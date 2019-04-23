//
//  JMRouter+Foundation.swift
//  JMProject
//
//  Created by yangyuan on 2018/11/8.
//  Copyright © 2018 huan. All rights reserved.
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
public protocol JMPage {
    var rawValue: String { get }
}

// MARK: - 路由协议 controller实现这个协议，表示支持路由跳转
public protocol JMRoutable {
	/// 路由界面唯一标志
	static var routePath: JMPage { get }
	
	/// 路由界面出现的动画方式，目前只有 push, present，默认为push(animated:true)
	static var routeAnimation: JMRouter.Animation { get }
	
	/// 路由界面如何生成
	static func routePageCreate(with scheme: String?, parameters: [String : String]?, object: Any?) -> UIViewController?
}

// MARK: - 一些默认值
public extension JMRoutable {
	static var routeAnimation: JMRouter.Animation { return .push(animated: true) }
}

// MARK: - Extensions
extension String {
    var isNotBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty
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







