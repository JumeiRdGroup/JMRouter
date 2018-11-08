//
//  UIView+YYLib.swift
//  SwiftProject
//
//  Created by yangyuan on 2018/2/7.
//  Copyright © 2018年 huan. All rights reserved.
//

import UIKit

public extension UIView {
	public func removeSubviews() {
		subviews.forEach { $0.removeFromSuperview() }
	}
}

// MARK: - AutoLayout
/// 自己添加约束
public extension UIView {
	@discardableResult
	func layoutWidth(_ constant: CGFloat) -> NSLayoutConstraint {
		return addConstraint(attribute: .width, constant: constant)
	}
	
	@discardableResult
	func layoutHeight(_ constant: CGFloat) -> NSLayoutConstraint {
		return addConstraint(attribute: .height, constant: constant)
	}
	
	@discardableResult
	func layoutWidth(min constant: CGFloat) -> NSLayoutConstraint {
		return addConstraint(attribute: .width, constant: constant, relatedBy: .greaterThanOrEqual)
	}
	
	@discardableResult
	func layoutHeight(min constant: CGFloat) -> NSLayoutConstraint {
		return addConstraint(attribute: .height, constant: constant, relatedBy: .greaterThanOrEqual)
	}
	
	@discardableResult
	func layoutWidth(max constant: CGFloat) -> NSLayoutConstraint {
		return addConstraint(attribute: .width, constant: constant, relatedBy: .lessThanOrEqual)
	}
	
	@discardableResult
	func layoutHeight(max constant: CGFloat) -> NSLayoutConstraint {
		return addConstraint(attribute: .height, constant: constant, relatedBy: .lessThanOrEqual)
	}
	
	@discardableResult
	func addConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
		return UIView.addConstraint(on: self, attribute: attribute, relatedBy: relatedBy, multiplier: multiplier, constant: constant, priority: priority)
	}
}

/// 和父控件相关约束
public extension UIView {
	func layoutEqualParent(inset: UIEdgeInsets) {
		layoutTopParent(inset.top)
		layoutLeftParent(inset.left)
		layoutBottomParent(inset.bottom)
		layoutRightParent(inset.right)
	}
	
	func layoutEqualParent(_ offset: CGFloat = 0) {
		layoutTopParent(offset)
		layoutLeftParent(offset)
		layoutBottomParent(offset)
		layoutRightParent(offset)
	}
	
	func layoutCenterParent(_ offset: CGPoint = .zero) {
		layoutCenterHorizontal(offset.x)
		layoutCenterVertical(offset.y)
	}
	
	@discardableResult
	func layoutCenterHorizontal(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWithParent(attribute: .centerX, constant: offset)
	}
	
	@discardableResult
	func layoutCenterVertical(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWithParent(attribute: .centerY, constant: offset)
	}
	
	@discardableResult
	func layoutTopParent(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWithParent(attribute: .top, constant: offset)
	}
	
	@discardableResult
	func layoutLeftParent(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWithParent(attribute: .left, constant: offset)
	}
	
	@discardableResult
	func layoutBottomParent(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWithParent(attribute: .bottom, constant: -offset)
	}
	
	@discardableResult
	func layoutRightParent(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWithParent(attribute: .right, constant: -offset)
	}
	
	@discardableResult
	func addConstraintWithParent(attribute: NSLayoutConstraint.Attribute, constant: CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
		guard let superview = superview else {
			return nil
		}
		
		return UIView.addConstraint(on: superview, item: self, attribute: attribute, relatedBy: relatedBy, toItem: superview, attribute: attribute, multiplier: multiplier, constant: constant, priority: priority)
	}
}

/// 和兄弟控件相关约束
public extension UIView {
	@discardableResult
	func layoutTop(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWith(view: view, attribute: .top, attribute: .top, constant: offset)
	}
	
	@discardableResult
	func layoutLeft(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWith(view: view, attribute: .left, attribute: .left, constant: offset)
	}
	
	@discardableResult
	func layoutBottom(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWith(view: view, attribute: .bottom, attribute: .bottom,  constant: offset)
	}
	
	@discardableResult
	func layoutRight(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWith(view: view, attribute: .right, attribute: .right, constant: offset)
	}
	
	@discardableResult
	func layoutHorizontal(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWith(view: view, attribute: .left, attribute: .right, constant: offset)
	}
	
	@discardableResult
	func layoutVertical(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
		return addConstraintWith(view: view, attribute: .top, attribute: .bottom, constant: offset)
	}
	
	@discardableResult
	func addConstraintWith(view: UIView, attribute attribute1: NSLayoutConstraint.Attribute, attribute attribute2: NSLayoutConstraint.Attribute, constant: CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
		guard let superview = superview else {
			return nil
		}
		
		return UIView.addConstraint(on: superview, item: self, attribute: attribute1, relatedBy: relatedBy, toItem: view, attribute: attribute2, multiplier: multiplier, constant: constant, priority: priority)
	}
}

public extension UIView {
	/// 给target添加约束
	@discardableResult
	class func addConstraint(on target: UIView, attribute: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, multiplier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
		return UIView.addConstraint(on: target, item: target, attribute: attribute, relatedBy: relatedBy, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constant, priority: priority)
	}
	
	
	@discardableResult
	class func addConstraint(on target: UIView, item: Any, attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, toItem: Any?, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
		//		target.translatesAutoresizingMaskIntoConstraints = false
		//		(toItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
		(item as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
		let constraint = NSLayoutConstraint(item: item, attribute: attribute1, relatedBy: relatedBy, toItem: toItem, attribute: attribute2, multiplier: multiplier, constant: constant)
		constraint.priority = priority
		target.addConstraint(constraint)
		return constraint
	}
}

// MARK: - Frame Sugar
public extension UIView {
	///
	public var x: CGFloat {
		get {
			return frame.origin.x
		} set(value) {
			frame = CGRect(x: value, y: y, width: w, height: h)
		}
	}
	
	///
	public var y: CGFloat {
		get {
			return frame.origin.y
		} set(value) {
			frame = CGRect(x: x, y: value, width: w, height: h)
		}
	}
	
	///
	public var w: CGFloat {
		get {
			return frame.size.width
		} set(value) {
			frame = CGRect(x: x, y: y, width: value, height: h)
		}
	}
	
	///
	public var h: CGFloat {
		get {
			return frame.size.height
		} set(value) {
			frame = CGRect(x: x, y: y, width: w, height: value)
		}
	}
	
	///
	public var width: CGFloat {
		get {
			return frame.size.width
		} set(value) {
			frame = CGRect(x: x, y: y, width: value, height: h)
		}
	}
	
	///
	public var height: CGFloat {
		get {
			return frame.size.height
		} set(value) {
			frame = CGRect(x: x, y: y, width: w, height: value)
		}
	}
	
	///
	public var left: CGFloat {
		get {
			return x
		} set(value) {
			x = value
		}
	}
	
	///
	public var right: CGFloat {
		get {
			return x + w
		} set(value) {
			x = value - w
		}
	}
	
	///
	public var top: CGFloat {
		get {
			return y
		} set(value) {
			y = value
		}
	}
	
	///
	public var bottom: CGFloat {
		get {
			return y + h
		} set(value) {
			y = value - h
		}
	}
	
	///
	public var origin: CGPoint {
		get {
			return frame.origin
		} set(value) {
			frame = CGRect(origin: value, size: frame.size)
		}
	}
	
	///
	public var centerX: CGFloat {
		get {
			return center.x
		} set(value) {
			center.x = value
		}
	}
	
	///
	public var centerY: CGFloat {
		get {
			return center.y
		} set(value) {
			center.y = value
		}
	}
	
	///
	public var size: CGSize {
		get {
			return frame.size
		} set(value) {
			frame = CGRect(origin: frame.origin, size: value)
		}
	}
}

// MARK: - IBInspectable
public extension UIView {
	/// Border color of view; also inspectable from Storyboard.
	@IBInspectable public var borderColor: UIColor? {
		get {
			return layer.borderColor.flatMap { UIColor(cgColor: $0) }
		}
		set {
			layer.borderColor = newValue.flatMap { $0.cgColor }
		}
	}
	
	/// Border width of view; also inspectable from Storyboard.
	@IBInspectable public var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	
	/// Corner radius of view; also inspectable from Storyboard.
	@IBInspectable public var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.masksToBounds = true
			layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
		}
	}
	
	/// Shadow color of view; also inspectable from Storyboard.
	@IBInspectable public var shadowColor: UIColor? {
		get {
			guard let color = layer.shadowColor else { return nil }
			return UIColor(cgColor: color)
		}
		set {
			layer.shadowColor = newValue?.cgColor
		}
	}
	
	/// Shadow offset of view; also inspectable from Storyboard.
	@IBInspectable public var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set {
			layer.shadowOffset = newValue
		}
	}
	
	/// Shadow opacity of view; also inspectable from Storyboard.
	@IBInspectable public var shadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set {
			layer.shadowOpacity = newValue
		}
	}
	
	/// Shadow radius of view; also inspectable from Storyboard.
	@IBInspectable public var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set {
			layer.shadowRadius = newValue
		}
	}
}













