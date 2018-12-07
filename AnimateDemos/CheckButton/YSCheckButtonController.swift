//
//  CheckButtonController.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/6.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class YSCheckButtonController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        let checkButton = YSCheckButton.init(frame: CGRect.init(x: 150, y: 200, width: 40, height: 40), color: UIColor.green)
        checkButton.centerX = self.view.centerX
        self.view.addSubview(checkButton)
        
        checkButton.addTarget(self, action: #selector(btnTapped(btn:)), for: .touchUpInside)
    }

    @objc func btnTapped(btn: YSCheckButton) {
        btn.isSelected = !btn.isSelected
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
