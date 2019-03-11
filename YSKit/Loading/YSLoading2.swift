//
//  YSLoading2.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2019/3/11.
//  Copyright © 2019年 melody. All rights reserved.
//


import UIKit

class YSLoading2: UIView {
    // 小球间距
    let margin: CGFloat = 5.0
    // 小球行列数
    let cols = 3;
    
    class func show(in view: UIView) -> YSLoading2 {
        let width: CGFloat = 80
        let loading = YSLoading2.init(frame: CGRect.init(x: 0, y: 0, width: width, height: width))
        loading.center = view.center
        view.addSubview(loading)
        loading.setupUI()
        return loading
    }
    
    class func hide(in view: UIView) {
        for subview in view.subviews {
            if let loadingView = subview as? YSLoading2 {
                loadingView.removeFromSuperview()
            }
        }
    }
    
    func setupUI() {
        let width = self.bounds.size.width
        // 小球宽度
        let dotW = (width - margin * CGFloat(cols - 1)) / CGFloat(cols)
        
        let dotLayer = CAShapeLayer()
        dotLayer.frame = CGRect.init(x: 0, y: 0, width: dotW, height: dotW)
        dotLayer.path = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: dotW, height: dotW)).cgPath
        dotLayer.fillColor = UIColor.red.withAlphaComponent(0.3).cgColor
        
        // 横向重复
        let replicatorLayerX = CAReplicatorLayer()
        replicatorLayerX.frame = CGRect.init(x: 0, y: 0, width: self.width, height: dotW)
        replicatorLayerX.instanceDelay = 0.3
        replicatorLayerX.instanceCount = 3 // 重复个数
        replicatorLayerX.addSublayer(dotLayer)
        
        let transform = CATransform3DTranslate(CATransform3DIdentity, dotW + margin, 0, 0)
        replicatorLayerX.instanceTransform = transform
        
        // 纵向重复
        let replicatorLayerY = CAReplicatorLayer()
        replicatorLayerY.frame = self.bounds
        replicatorLayerY.instanceDelay = 0.3
        replicatorLayerY.instanceCount = 3
        replicatorLayerY.addSublayer(replicatorLayerX)
        
        let transformY = CATransform3DTranslate(CATransform3DIdentity, 0, dotW + margin, 0)
        replicatorLayerY.instanceTransform = transformY
        
        self.layer.addSublayer(replicatorLayerY)
        
//        let opacityAnimate = CABasicAnimation.init(keyPath: "opacity")
//        opacityAnimate.fromValue = 0.3
//        opacityAnimate.toValue = 0.3
        
        let scaleAnimate = CABasicAnimation.init(keyPath: "transform")
        scaleAnimate.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0))
        scaleAnimate.toValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0.0))
        
        let animateGroup = CAAnimationGroup()
        animateGroup.animations = [scaleAnimate]
        animateGroup.duration = 1
        animateGroup.beginTime = 0.2
        animateGroup.autoreverses = true
        animateGroup.repeatCount = HUGE
        dotLayer.add(animateGroup, forKey: "groupAnimation")
    }
}
