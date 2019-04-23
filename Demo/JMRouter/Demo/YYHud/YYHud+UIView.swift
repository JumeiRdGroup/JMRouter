//
//  YYHud+UIView.swift
//  SwiftProject
//
//  Created by yangyuan on 2018/8/10.
//  Copyright © 2018年 huan. All rights reserved.
//

import UIKit


public extension UIView {
	func hideLoading(after: Double = 0) {
		subviews.forEach {
			if let hud = $0 as? YYHud {
				hud.dismiss(after: after)
			}
		}
	}
	
	@discardableResult
	func showTip(_ text: String, options: YYHud.OptionInfo = [.duration(second: 2)], in view: UIView? = nil) -> YYHud {
		return show(.tip(text: text), options: options)
	}
	
	@discardableResult
	func showLoading(with text: String? = nil, options: YYHud.OptionInfo = [], in view: UIView? = nil) -> YYHud {
		return show(.loading(text: text), options: options)
	}
	
	@discardableResult
	func showSuccess(with text: String? = nil, options: YYHud.OptionInfo = [.duration(second: 2)], in view: UIView? = nil) -> YYHud {
		return show(.image(image: YYHud.imageSucess, text: text), options: options)
	}
	
	@discardableResult
	func showError(with text: String? = nil, options: YYHud.OptionInfo = [.duration(second: 2)], in view: UIView? = nil) -> YYHud {
		return show(.image(image: YYHud.imageError, text: text), options: options)
	}
	
	@discardableResult
	func showInfo(with text: String? = nil, options: YYHud.OptionInfo = [.duration(second: 2)], in view: UIView? = nil) -> YYHud {
		return show(.image(image: YYHud.imageInfo, text: text), options: options)
	}
	
	@discardableResult
	func show(_ type: YYHud.ShowType, options: YYHud.OptionInfo = []) -> YYHud {
		return YYHud().show(type, options: options, in: self)
	}
}
