//
//  YSCurve.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/5.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class YSWaveView: UIView {

    /// 波浪幅度  (波浪的高度)
    var waveHeight: CGFloat = 20
    
    /// 波浪移动速度
    var waveSpeed: CGFloat = 0.16
    
    /// 波长 默认为控件宽度1.5倍
    var waveWidth: CGFloat = UIScreen.main.bounds.width * 1.5
    
    /// 主波浪
    private var waveLayer: CAShapeLayer = CAShapeLayer()
    /// 背景波浪
    private var waveLayer2: CAShapeLayer = CAShapeLayer()
    private var offset: CGFloat = 0
    private var displayLink: CADisplayLink?
    private let doublePi: CGFloat = CGFloat.pi * 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        waveWidth = self.width * 1.5
        
        self.layer.addSublayer(waveLayer2)
        self.layer.addSublayer(waveLayer)
        
        waveLayer.fillColor = UIColor.init(red: 80/255, green: 238/255, blue: 255/255, alpha: 1).cgColor
        waveLayer2.fillColor = UIColor.init(red: 80/255, green: 238/255, blue: 255/255, alpha: 0.4).cgColor
        
        displayLink = CADisplayLink.init(target: self, selector: #selector(waveAnimation))
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    /// 生成波浪曲线path
    private func buildBezierPath() -> (UIBezierPath, UIBezierPath){
        let path = UIBezierPath()
        let path2 = UIBezierPath()
        
        
        for x in 0...Int(self.width) {
            let y = waveHeight * sin( doublePi / waveWidth * CGFloat(x) + offset)
            let y2 = waveHeight * sin( doublePi / waveWidth * CGFloat(x) + offset - CGFloat.pi/2)
            if x == 0 {
                path.move(to: CGPoint.init(x: 0, y: y))
                path2.move(to: CGPoint.init(x: 0, y: y2))
            }else{
                path.addLine(to: CGPoint.init(x: CGFloat(x), y: y))
                path2.addLine(to: CGPoint.init(x: CGFloat(x), y: y2))
            }
        }
        path.addLine(to: CGPoint.init(x: self.width, y: self.height))
        path.addLine(to: CGPoint.init(x: 0, y: self.height))
        
        path2.addLine(to: CGPoint.init(x: self.width, y: self.height))
        path2.addLine(to: CGPoint.init(x: 0, y: self.height))

        path.close()
        path2.close()
        return (path, path2)
    }
    
    /// 水波动画
    @objc func waveAnimation() {
        let paths = buildBezierPath()
        waveLayer.path = paths.0.cgPath
        waveLayer2.path = paths.1.cgPath
        offset += waveSpeed
    }
    

}
