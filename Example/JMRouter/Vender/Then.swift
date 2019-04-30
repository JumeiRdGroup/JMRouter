
//
//  Then.swift
//  SwiftProject
//
//  Created by yangyuan on 2018/1/9.
//  Copyright © 2018年 huan. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(iOS) || os(tvOS)
	import UIKit.UIGeometry
#endif

public protocol Then {}

extension Then where Self: Any {
	/// Makes it available to set properties with closures just after initializing and copying the value types.
	///
	///     let frame = CGRect().mutate {
	///       $0.origin.x = 10
	///       $0.size.width = 100
	///     }
	public func mutate(_ block: (inout Self) -> Void) -> Self {
		var newSelf = self
		block(&newSelf)
		return newSelf
	}
	
	/// Makes it available to execute something with closures.
	///
	///     UserDefaults.standard.do {
	///       $0.set("devxoul", forKey: "username")
	///       $0.set("devxoul@gmail.com", forKey: "email")
	///       $0.synchronize()
	///     }
	public func `do`(_ block: (Self) -> Void) {
		block(self)
	}
}

extension Then where Self: AnyObject {
	/// Makes it available to set properties with closures just after initializing.
	///
	///     let label = UILabel().then {
	///       $0.textAlignment = .center
	///       $0.textColor = .black
	///       $0.text = "Hello, World!"
	///     }
	public func then(_ block: (Self) -> Void) -> Self {
		block(self)
		return self
	}
}

extension NSObject: Then {}

extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}

#if os(iOS) || os(tvOS)
	extension UIEdgeInsets: Then {}
	extension UIOffset: Then {}
	extension UIRectEdge: Then {}
#endif















