//
//  YSLoadingAnimation2.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2019/3/11.
//  Copyright © 2019年 melody. All rights reserved.
//

import UIKit

class YSLoadingAnimation2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        _ = YSLoading2.show(in: self.view)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    }
