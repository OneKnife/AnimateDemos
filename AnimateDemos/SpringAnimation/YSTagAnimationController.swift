//
//  YSSpringAnimationController.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/10.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class YSSpringTagController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "QQ消息粘粘效果"

        let springTag = YSSpringTag.init(color: UIColor.red, frame: CGRect.init(x: 0, y: 200, width: 20, height: 20))
        springTag.centerX = self.view.centerX
        springTag.setText(text: "11")
        self.view.addSubview(springTag)
        
       

    }
}
