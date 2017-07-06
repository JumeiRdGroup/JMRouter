//
//  ViewController.swift
//  JMRouter
//
//  Created by yangyuan on 2017/6/29.
//  Copyright © 2017年 huan. All rights reserved.
//

import UIKit

// MARK: - Life cycle

extension HomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContext()
    }
}
/*
 
 */
class HomeController: UIViewController {
    
    // MARK: - Const
    
    let cellHeight = CGFloat(49)
    let cellIdentifier = "cellIdentifier"
    
    // MARK: - Property
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        return tableView
    }()
    
    // MARK: - Initialization
    
    func setupContext() {
        setupUI()
        requestData()
    }
    
    func setupUI() {
        title = "JMRouter使用demo"
        
        edgesForExtendedLayout = []
        automaticallyAdjustsScrollViewInsets = false

        view.addSubview(tableView)
        tableView.addConstraintFillSuperView()
    }
    
    // MARK: - Network
    
    func requestData(append: Bool = false) {
        dataArray = [
            "使用枚举方式present一个新的home",
            "scheme1://action/tel?phone=123456&点我打电话",
            "scheme2://page/nibVc?title=push xib创建的vc",
            "scheme3://page/vc1?title=无动画push storyboard创建的vc",
            "scheme3://page/xxx?titile=没配置过的，不会跳转",
        ]
        renderUI()
    }
    
    func renderUI() {
        tableView.reloadData()
    }

    // MARK: - Private
    
    fileprivate var dataArray: [String] = []
}

// MARK: - Delegate

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        cell?.detailTextLabel?.text = dataArray[indexPath.row]
        return cell!
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            /// 应用内使用枚举方式跳转更方便
            JMRouter.goto(.home, from: self) { resrult, homeVc in
                YYHud.showTip(resrult ? "操作成功" : "操作失败")
            }
            return
        }
        /// 使用url跳转并传递一个额外参数 随机颜色
        JMRouter.routing(url: dataArray[indexPath.row], object: UIColor.random) { resrult, _ in
            YYHud.showTip(resrult ? "操作成功" : "操作失败")
        }
    }
}



extension HomeController: Routable {
    static var routeAnimation: JMRouter.Animation {
        return .present(animated: true)
    }
    
    static var routePath: JMRouter.Page {
        return .home
    }
    
    static func routePageCreate(url: String, parameters: [String : String]?, object: Any?) -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }
}



extension UIView {
    /// 添加填满父view的约束
    func addConstraintFillSuperView() {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints = false
            let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let left = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0)
            superview.addConstraints([top, left, bottom, right])
        }
    }
}


extension UIColor {
    public static var random: UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
}

extension CGFloat {
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

}

