//
//  JMRouter+Action.swift
//  JMProject
//
//  Created by yangyuan on 2018/11/8.
//  Copyright © 2018 huan. All rights reserved.
//

import UIKit

// MARK: - 支持的action
public extension JMRouter {
	enum Action: String {
		case tel
	}
}

private extension JMRouter.Action {
	static let host = "action"
}

/// MARK: - Action
public extension JMRouter {
	/// 检查urlString是否是合法action schema
    static func validateActionUrl(_ urlString: String) -> Bool {
		guard let url = urlString.toURL(),
			let scheme = url.scheme,
			schemes.contains(scheme),
			url.host == Action.host else {
				return false
		}
		return true
	}
	
	/// 通过枚举来执行action
	@discardableResult
    static func run(_ action: JMRouter.Action, url: String? = nil, parameters: [String : String]? = nil, object: Any? = nil, from vc: UIViewController? = nil, completion: Completion? = nil) -> Bool {
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

private extension JMRouter {
	static func makePhoneCall(_ number: String?) {
		guard let number = number, number.isNotBlank else { return }
		let url = "tel://" + number
		openUrl(url)
	}
	
	static func openUrl(_ url: String) {
		guard let url = url.toURL() else { return }
		let application = UIApplication.shared
		if !application.canOpenURL(url) {
			print("无法打开\(url) 请确保此应用已经正确安装")
			return
		}
		
		if #available(iOS 10.0, *) {
			application.open(url, options: [:]) { (_) in
				
			}
		} else {
			application.openURL(url)
		}
	}
}
