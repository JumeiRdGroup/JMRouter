//
//  YYHud+ShowType.swift
//  SwiftProject
//
//  Created by yangyuan on 2018/8/9.
//  Copyright © 2018年 huan. All rights reserved.
//

import UIKit

public extension YYHud {
	static var imageSucess: UIImage { return UIImage(named: "YYHudSucess")! }
	static var imageError: UIImage { return UIImage(named: "YYHudError")! }
	static var imageInfo: UIImage { return UIImage(named: "YYHudInfo")! }
	
	///
    enum ShowType {
		case tip(text: String)
		case loading(text: String?)
		case image(image: UIImage, text: String?)
	}
	
	///
    class ContentView: UIView {
		///
		lazy var textLabel: UILabel = {
			UILabel().then {
				$0.numberOfLines = 0
				$0.font = .systemFont(ofSize: 14)
				$0.textColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
				$0.textAlignment = .center
			}
		}()
		
		lazy var indicatorView: UIActivityIndicatorView = {
			UIActivityIndicatorView(style: .whiteLarge).then {
				$0.hidesWhenStopped = false
			}
		}()
		
		lazy var imageView: UIImageView = {
			UIImageView().then {
				$0.contentMode = .scaleAspectFit
			}
		}()
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			setupContext()
		}
		
		required public init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		func setupContext() {
			backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7491705908)
			cornerRadius = 5
		}
		
		func config(with type: ShowType) {
			removeSubviews()
			switch type {
			case .tip(let text):
				showTip(text)
			case .loading(let text):
				showLoading(text)
			case let .image(image, text):
				showImage(image, text: text)
			}
		}
		
		func showTip(_ text: String) {
			addSubview(textLabel)
			textLabel.text = text
			textLabel.layoutEqualParent(12)
		}
		
		func showLoading(_ text: String?) {
			addSubview(indicatorView)
			indicatorView.startAnimating()
			if let text = text, text.count > 0 {
				addSubview(textLabel)
				textLabel.text = text
				
				indicatorView.layoutTopParent(12)
				indicatorView.layoutCenterHorizontal()
				textLabel.layoutVertical(view: indicatorView, offset: 5)
				textLabel.layoutLeftParent(15)
				textLabel.layoutRightParent(15)
				textLabel.layoutBottomParent(9)
				textLabel.layoutWidth(min: 50)
			} else {
				indicatorView.layoutEqualParent(15)
			}
		}
		
		func showImage(_ image: UIImage, text: String?) {
			addSubview(imageView)
			imageView.image = image
			if let text = text, text.count > 0 {
				addSubview(textLabel)
				textLabel.text = text
				
				imageView.layoutTopParent(12)
				imageView.layoutCenterHorizontal()
				textLabel.layoutVertical(view: imageView, offset: 5)
				textLabel.layoutLeftParent(15)
				textLabel.layoutRightParent(15)
				textLabel.layoutBottomParent(9)
				textLabel.layoutWidth(min: 50)
			} else {
				imageView.layoutEqualParent(15)
			}
		}
	}
}
