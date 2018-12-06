//
//  YSLoadingAnimation.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/3.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class YSLoadingAnimation: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 23/255, green: 25/255, blue: 41/255, alpha: 1)
        // Do any additional setup after loading the view.
        _ = YSLoading.show(in: self.view)
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
