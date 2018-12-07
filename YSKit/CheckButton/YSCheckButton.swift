//
//  YSCheckButton.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/6.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class YSCheckButton: UIControl, CAAnimationDelegate {
    
    /// 颜色
    var color: UIColor = UIColor.green
    /// 线条宽度
    var lineWidth: CGFloat = 3
    private let layerCircle: CAShapeLayer = CAShapeLayer()
    private let layerCheck: CAShapeLayer = CAShapeLayer()
    
    override var isSelected: Bool {
        didSet{
            startAnimate(withSelected: isSelected)
        }
    }
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        if self.width != self.height {
            self.height = self.width
        }
        self.color = color
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        // 圆圈
        let pathCircle = UIBezierPath.init(arcCenter: CGPoint.init(x: self.width/2, y: self.width/2), radius: self.width / 2, startAngle: -CGFloat.pi + 1/8*CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true)
        layerCircle.fillColor = UIColor.clear.cgColor
        layerCircle.strokeColor = color.cgColor
        layerCircle.lineWidth = lineWidth
        layerCircle.path = pathCircle.cgPath
        
        // 对号
        let r = self.width / 2
        
        // 这里需要使用圆的公式计算一下对勾三个点的坐标
        let pointOrigin = CGPoint.init(x: r - r*cos(CGFloat.pi/8), y: r - r*sin(CGFloat.pi/8))
        let pointTurn = CGPoint.init(x: 2/3*r, y: 3/4*2*r)
        let pointEnd = CGPoint.init(x: 5/3*r, y: 1/3*r)
        
        let pathCheck = UIBezierPath()
        pathCheck.move(to: pointOrigin)
        pathCheck.addLine(to: pointTurn)
        pathCheck.addLine(to: pointEnd)
        
        layerCheck.fillColor = UIColor.clear.cgColor
        layerCheck.strokeColor = color.cgColor
        layerCheck.lineWidth = 3
        layerCheck.path = pathCheck.cgPath
        
        self.layer.addSublayer(layerCircle)
    }
    
    private func startAnimate(withSelected selected: Bool) {
        if selected {
            let animationCircle = startCircleAnimation(fromValue: 1, andEnd: 0)
            let animationCheck = startCheckAnimation(fromValue: 0, andEnd: 1)
            self.layerCircle.add(animationCircle, forKey: "circle")
            self.layerCheck.add(animationCheck, forKey: "check")
        }else {
            let checkAnimationGroup = CAAnimationGroup()
            let animationCircle = startCircleAnimation(fromValue: 0, andEnd: 1)
            let animationCheck = startCheckAnimation(fromValue: 1, andEnd: 0)
            let animationCheck2 = startCheck2Animation(fromValue: 0.1, andEnd: 0)
            checkAnimationGroup.animations = [animationCheck2, animationCheck]
            checkAnimationGroup.isRemovedOnCompletion = false
            checkAnimationGroup.delegate = self
            checkAnimationGroup.fillMode = kCAFillModeForwards
            checkAnimationGroup.duration = 0.5
            self.layerCircle.add(animationCircle, forKey: "circle")
            self.layerCheck.add(checkAnimationGroup, forKey: "check")
        }
    }
    
    /// 圆圈动画
    private func startCircleAnimation(fromValue: CGFloat, andEnd endValue: CGFloat) -> CABasicAnimation {
        let animationCircle = CABasicAnimation.init(keyPath: "strokeEnd")
        animationCircle.fromValue = fromValue
        animationCircle.toValue = endValue
        animationCircle.duration = 0.3
        animationCircle.isRemovedOnCompletion = false
        animationCircle.delegate = self
        self.layer.addSublayer(layerCircle)
        return animationCircle
    }
    
    /// 对勾动画
    private func startCheckAnimation(fromValue: CGFloat, andEnd endValue: CGFloat) -> CABasicAnimation {
        let animationCheck = CABasicAnimation.init(keyPath: "strokeEnd")
        animationCheck.fromValue = fromValue
        animationCheck.toValue = endValue
        animationCheck.duration = 0.4
        animationCheck.isRemovedOnCompletion = false
        animationCheck.delegate = self
        animationCheck.fillMode = kCAFillModeForwards
        self.layer.addSublayer(layerCheck)
        return animationCheck
    }
    
    /// 收起尾巴
    private func startCheck2Animation(fromValue: CGFloat, andEnd endValue: CGFloat) -> CABasicAnimation {
        let animationCheck = CABasicAnimation.init(keyPath: "strokeStart")
        animationCheck.fromValue = fromValue
        animationCheck.toValue = endValue
        animationCheck.duration = 0.1
        animationCheck.isRemovedOnCompletion = false
        animationCheck.delegate = self
        animationCheck.fillMode = kCAFillModeForwards
        self.layer.addSublayer(layerCheck)
        return animationCheck
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isSelected {
            // 圆圈动画结束
            if anim == layerCircle.animation(forKey: "circle") {
                layerCircle.removeAllAnimations()
                layerCircle.removeFromSuperlayer()
                // 收起尾巴
                let checkAnimate = startCheck2Animation(fromValue: 0, andEnd: 0.15)
                layerCheck.add(checkAnimate, forKey: nil)
            }
        }else {
            // check 动画结束
            if anim == layerCheck.animation(forKey: "check") {
                layerCheck.removeAllAnimations()
                layerCheck.removeFromSuperlayer()
            }
        }
        
    }

    
    
    
    
}
