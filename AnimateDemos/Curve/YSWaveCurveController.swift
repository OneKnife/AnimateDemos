//
//  YSCurveController.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/5.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class YSWaveCurveController: UIViewController, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 普通波浪
        self.view.backgroundColor = UIColor.white
        let waveView = YSWaveView.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 100))
        self.view.addSubview(waveView)
        
        
        // 字体波浪效果
        let waveText = YSWaveText.init(text: "贴", textColor: UIColor.init(red: 41/255, green: 157/255, blue: 253/255, alpha: 1), waveColor: UIColor.init(red: 41/255, green: 157/255, blue: 253/255, alpha: 1))
        waveText.frame = CGRect.init(x: 0, y: 300, width: 50, height: 50)
        waveText.centerX = self.view.centerX
        self.view.addSubview(waveText)
    }

}
