//
//  YYHud.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/11.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 显示配置

public struct YYHudOpitions: OptionSet {
    public var rawValue = 0  // 因为RawRepresentable的要求
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static var dim = YYHudOpitions(rawValue: 1 << 0)//灰色模板
    public static var modal = YYHudOpitions(rawValue: 1 << 1)//模态显示
}

// MARK: - 动画

public enum YYHudAnimation {
    case none
    case fade
    case zoom
}


// MARK: - Public

extension YYHud {
    
    /// 显示加载框
    ///
    /// - Parameters:
    ///   - text: 文案
    ///   - options: 默认模态显示，设置nil为非模态
    ///   - container: 显示到某个view上，为nil时会显示到最外层的window上
    /// - Returns: hud对象
    @discardableResult
    public static func showLoading(_ text: String? = nil, options: YYHudOpitions = [], in container: UIView? = nil) -> YYHud {
        return shared.showLoading(text, options: options, in: container)
    }
    
    @discardableResult
    public static func showSuccess(_ text: String? = nil, in container: UIView? = nil) -> YYHud {
        return shared.showSuccess(text, in: container)
    }
    
    @discardableResult
    public static func showError(_ text: String? = nil, in container: UIView? = nil) -> YYHud {
        return shared.showError(text, in: container)
    }
    
    @discardableResult
    public static func showInfo(_ text: String? = nil, in container: UIView? = nil) -> YYHud {
        return shared.showInfo(text, in: container)
    }
    
    @discardableResult
    public static func showTip(_ text: String, in container: UIView? = nil) -> YYHud {
        return shared.showTip(text, in: container)
    }
    
    public static func dismiss() {
        shared.dismiss()
    }
    
    public static func config() {
        
    }
}

public class YYHud: UIView {
    // MARK: - Const
    
    let YYHudRadius = CGFloat(5)
    let YYHudAnimationDuration = 0.3
    
    public static let YYHudDuration = 2.0
    let YYHudDurationForever = -1.0
    
    let YYHudimageContainerHeight = CGFloat(50)
    let YYHudimageContainerMarginTopDefault = CGFloat(15)
    let YYHudimageContainerMarginTopWithText = CGFloat(10)
    
    // MARK: - Property
    
    @IBOutlet weak var hudContainer: UIView!
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var imageContainerMarginTop: NSLayoutConstraint!
    @IBOutlet weak var imageContainerHeight: NSLayoutConstraint!
    
    // MARK: - 自定义配置，默认值取自xib中的设置
    
    var hudBackgroundColor: UIColor! { didSet { hudContainer.backgroundColor = hudBackgroundColor } }
    var textColor: UIColor! { didSet { textLabel.textColor = textColor } }
    var textFont: UIFont! { didSet { textLabel.font = textFont } }
    
    var options: YYHudOpitions = [] {
        didSet {
            self.backgroundColor = options.contains(.dim) ? UIColor(white: 0, alpha: 0.62) : UIColor.clear
            self.ismodalAlert = options.contains(.modal)
        }
    }
    
    public static let shared = YYHud.newInstanceFromXib()
    public static func newInstanceFromXib() -> YYHud {
        let view = Bundle(for: self).loadNibNamed("YYHud", owner: nil, options: nil)!.first as? YYHud
        return view!
    }
    
    var ismodalAlert = true {
        didSet {
            self.isUserInteractionEnabled = ismodalAlert
        }
    }
    var isShowing: Bool = false
    var dismissTimer: Timer?
    
    // MARK: - Initialization
    
    public override func awakeFromNib() {
        self.setContext()
    }
    
    func setContext() {
        hudBackgroundColor = hudContainer.backgroundColor
        textColor = textLabel.textColor
        textFont = textLabel.font
        hudContainer.layer.cornerRadius = YYHudRadius
    }
}


// MARK: - Show

extension YYHud {
    var imageSucess: UIImage? { return UIImage(named: "YYHudSucess") }
    var imageError: UIImage? { return UIImage(named: "YYHudError") }
    var imageInfo: UIImage? { return UIImage(named: "YYHudInfo") }
    var superViewDefault: UIView { return UIApplication.shared.keyWindow! }
    
    func showLoading(_ text: String? = nil, options: YYHudOpitions = [], in container: UIView? = nil) -> YYHud {
        return show(in: container, text: text, duration: YYHudDurationForever, options: options)
    }
    
    func showSuccess(_ text: String? = nil, in container: UIView? = nil) -> YYHud {
        return show(in: container, text: text, image: imageSucess)
    }
    
    func showError(_ text: String? = nil, in container: UIView? = nil) -> YYHud {
        return show(in: container, text: text, image: imageError)
    }
    
    func showInfo(_ text: String? = nil, in container: UIView? = nil) -> YYHud {
        return show(in: container, text: text, image: imageInfo)
    }
    
    func showTip(_ text: String, in container: UIView? = nil) -> YYHud {
        return show(in: container, text: text, isTip: true)
    }
    
    func show(in view: UIView?, text: String?, image: UIImage? = nil, isTip: Bool = false, duration:Double = YYHud.YYHudDuration, animation: YYHudAnimation = .fade, options: YYHudOpitions = []) -> YYHud {
        isShowing = true
        DispatchQueue.main.async {
            self.options = options
            if self.superview != nil {
                self.superview?.bringSubview(toFront: self)
            } else {
                let finalSuperView = view ?? self.superViewDefault
                finalSuperView.addSubview(self)
            }
            
            self.frame = self.superview!.bounds
            self.textLabel.text = text
            self.imageView.image = image
            
            //只显示提示文字
            if isTip {
                self.imageView.image = nil
                self.indicatorView.stopAnimating()
            } else {
                //显示自定义图片，或者默认的转圈
                image != nil ? self.indicatorView.stopAnimating() : self.indicatorView.startAnimating()
                self.indicatorView.isHidden = image != nil
                
                //没有文字显示正中间
                self.imageContainerMarginTop.constant = text != nil ? self.YYHudimageContainerMarginTopWithText : self.YYHudimageContainerMarginTopDefault
            }
            self.imageContainer.isHidden = isTip
            self.imageContainerHeight.constant = isTip ? 0 : self.YYHudimageContainerHeight
            
            self.showAnimation(animation)
        }
        
        refreshDismissTime(duration)
        return self
    }
    
    func showAnimation(_ type: YYHudAnimation) {
        UIView.animate(withDuration: YYHudAnimationDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.hudContainer.transform = CGAffineTransform.identity
            self.hudContainer.alpha = 1
        }) { (_) in
            
        }
    }
    
    @objc func dismiss() {
        if !self.isShowing {
            return
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.YYHudAnimationDuration, delay: 0, options: [.curveEaseIn], animations: {
                self.hudContainer.transform = CGAffineTransform.identity
                self.hudContainer.alpha = 0
            }) { (_) in
                self.indicatorView.stopAnimating()
                self.removeFromSuperview()
            }
        }
    }
    
    func refreshDismissTime(_ duration: Double) {
        if let timer = dismissTimer {
            timer.invalidate()
            dismissTimer = nil
        }
        
        if (duration != YYHudDurationForever) {
            dismissTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
        }
    }
}


























