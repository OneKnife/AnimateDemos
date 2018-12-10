//
//  YSSpringAnimationController.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/10.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class YSSpringAnimationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "拖动小球"

        let springBall = YSSpringBall.init(color: UIColor.red, frame: CGRect.init(x: 0, y: 200, width: 30, height: 30))
        springBall.recordPath = false
        springBall.centerX = self.view.centerX
        self.view.addSubview(springBall)
        
        let springBall2 = YSSpringBall.init(color: UIColor.red, frame: CGRect.init(x: 0, y: 400, width: 30, height: 30))
        springBall2.centerX = self.view.centerX
        springBall2.recordPath = true
        self.view.addSubview(springBall2)

    }
}
