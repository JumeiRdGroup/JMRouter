//
//  ViewController1.swift
//  JMRouter
//
//  Created by yangyuan on 2017/7/5.
//  Copyright © 2017年 huan. All rights reserved.
//

import UIKit

class ViewControllerFromStoryboard: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewControllerFromStoryboard: JMRoutable {
    static var routeAnimation: JMRouter.Animation {
        return .push(animated: false)
    }
    
    static var routePath: JMRouter.Page {
        return .vc1
    }
    
	static func routePageCreate(with url: String?, parameters: [String : String]?, object: Any?) -> UIViewController? {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerFromStoryboard")
        vc.title = parameters?["title"]
        vc.view.backgroundColor = object as? UIColor
        return vc
    }
}


