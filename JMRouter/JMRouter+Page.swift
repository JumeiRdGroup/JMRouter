//
//  JMRouter+Page.swift
//  JMProject
//
//  Created by yangyuan on 2018/11/8.
//  Copyright © 2018 huan. All rights reserved.
//

import UIKit

// MARK: - 支持的pages
public extension JMRouter {
	/// 声明哪些controller支持路由跳转
	enum Page: String {
		case home
		case vc1 //key和约定的字符串一致时
		case vc2 = "nibVc" //key和约定的字符串不一致时
	}
}

private extension JMRouter.Page {
	static let host = "page"
	
	func toRoutePage() -> JMRoutable.Type? {
		guard let className = JMRouter.pagePathMap[self] else {
			return nil
		}
		return className.toClass() as? JMRoutable.Type
	}
}

private extension JMRouter {
	/// 类名和枚举值的映射表
	static var pagePathMap = [JMRouter.Page: String]()
}

public extension JMRouter {
	///使用Router前必须先调用
	static func registerPagePathMap() {
		var count: UInt32 = 0
		guard let classes = objc_copyClassNamesForImage(class_getImageName(AppDelegate.self)!, &count) else {
				return
		}
		for i in 0 ..< Int(count) {
			if let clsName = String(cString: classes[i], encoding: .utf8)?.components(separatedBy: ".").last {
				if let cls = clsName.toClass() as? JMRoutable.Type {
					pagePathMap.updateValue(clsName, forKey: cls.routePath)
				}
			}
		}
	}
	
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
    static func goto(_ page: JMRouter.Page,
							url: String? = nil,
							parameters: [String : String]? = nil,
							object: Any? = nil,
							from vc: UIViewController? = nil,
							completion: Completion? = nil) -> UIViewController? {
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
			let toVC = page.routePageCreate(with: url, parameters: parameters, object: object) else {
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




