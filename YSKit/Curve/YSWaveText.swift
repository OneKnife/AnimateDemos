//
//  YSWaveText.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/5.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class YSWaveText: UIView {
    /// 主波浪
    private var waveLayer: CAShapeLayer = CAShapeLayer()

    private var offset: CGFloat = 0
    private var displayLink: CADisplayLink?
    private let doublePi: CGFloat = CGFloat.pi * 2
    private let backlabel: UILabel = UILabel()
    private let label: UILabel = UILabel()

    /// 波浪移动速度
    var waveSpeed: CGFloat = 0.16
    
    /// 波长 默认为控件宽度1.5倍
    var waveWidth: CGFloat = 0
    /// 波浪幅度  (波浪的高度)
    var waveHeight: CGFloat = 5

    
    /// 字体大小 默认根据frame自适应
    var fontSize: CGFloat = 10 {
        didSet{
            label.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
            backlabel.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(text: String, textColor: UIColor, waveColor: UIColor) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        setDisplayText(text: text, textColor: textColor, waveColor: waveColor)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDisplayText(text: String? = nil, textColor: UIColor? = nil, waveColor: UIColor? = nil) {
        if let text = text {
            label.text = text
            backlabel.text = text
        }
        
        if let textColor = textColor {
            backlabel.textColor = textColor
        }
        
        if let waveColor = waveColor {
            label.backgroundColor = waveColor
        }
    }
    
    private func setupUI() {
        self.backlabel.textAlignment = .center
        self.label.textAlignment = .center
        self.label.textColor = UIColor.white
        
        self.addSubview(backlabel)
        self.addSubview(label)
        self.label.layer.mask = waveLayer
        
        displayLink = CADisplayLink.init(target: self, selector: #selector(waveAnimation))
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        waveWidth = self.width * 1.5
        waveHeight = self.width * 0.1
        fontSize = self.frame.width * 0.5
        backlabel.frame = self.bounds
        label.frame = self.bounds
        
        self.addCornerRadius(self.width/2)
    }
    
    /// 生成波浪曲线path
    private func buildBezierPath() -> UIBezierPath{
        let path = UIBezierPath()
        
        for x in 0...Int(self.width) {
            let y = waveHeight * sin( doublePi / waveWidth * CGFloat(x) + offset) + self.height / 2
            if x == 0 {
                path.move(to: CGPoint.init(x: 0, y: y))
            }else{
                path.addLine(to: CGPoint.init(x: CGFloat(x), y: y))
            }
        }
        path.addLine(to: CGPoint.init(x: self.width, y: self.height))
        path.addLine(to: CGPoint.init(x: 0, y: self.height))
                
        path.close()
        return path
    }
    
    /// 水波动画
    @objc func waveAnimation() {
        let path = buildBezierPath()
        waveLayer.path = path.cgPath
        offset += waveSpeed
    }
    
    
}
