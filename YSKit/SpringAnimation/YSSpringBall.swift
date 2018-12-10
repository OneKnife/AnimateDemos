//
//  YSSpringBall.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/10.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class YSSpringBall: UIView {
    
    /// 起始点
    var identityPoint: CGPoint
    
    /// 动画持续时间
    var duration: CFTimeInterval = 0.6
        
    /// 路径点数组
    var pointArray: [CGPoint] = []
    
    /// 颜色
    var color: UIColor = UIColor.red
    
    /// path
    var path: UIBezierPath = UIBezierPath()
    
    /// 是否记录拖动路径，并按照拖动路径进行回弹
    var recordPath: Bool = false
    
    
    init(color: UIColor, frame: CGRect) {
        let width = max(frame.width, frame.height)
        identityPoint = CGPoint.init(x: width/2, y: width/2)
        self.color = color

        super.init(frame: CGRect.init(x: frame.minX, y: frame.minY, width: width, height: width))
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        ballView.frame = self.bounds
        ballView.addCornerRadius(self.width/2)
        ballView.backgroundColor = self.color
        self.addSubview(ballView)
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(gesture:)))
        ballView.addGestureRecognizer(panGesture)
        
        path.lineCapStyle = .round
        path.lineJoinStyle = .round

        self.layer.addSublayer(shapeLayer)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        ballView.layer.removeAllAnimations()
        // 小球跟随手指移动
        let point = gesture.location(in: gesture.view?.superview)
        gesture.view?.center = point
        
        if recordPath {
            // 记录拖动线路及按线路回弹
            if gesture.state == .began {
                // 开始滑动
                pointArray = [identityPoint]
                path.removeAllPoints()
                path.move(to: identityPoint)
                
            }else if gesture.state != .ended && gesture.state != .cancelled && gesture.state != .failed {
                // 拖动中
                pointArray.append(point)
                path.addLine(to: point)
                shapeLayer.path = path.cgPath
            }else {
                // 结束拖动
                path.reversing()
                // 生成反向path
                let reversePath = path.reversing()
                
                let endPoint = pointArray.first
                var startPoint = pointArray.first
                if pointArray.count > 3 {
                    startPoint = pointArray[2]
                }
                let eachDuration = duration / Double(pointArray.count)
                
                springAnimation.beginTime = CACurrentMediaTime() + duration - 2 * eachDuration
                springAnimation.fromValue = startPoint
                springAnimation.toValue = endPoint
                
                keyFrameAnimation.path = reversePath.cgPath
                
                ballView.center = identityPoint
                ballView.layer.add(springAnimation, forKey: "spring")
                ballView.layer.add(keyFrameAnimation, forKey: "keyframe")
            }
        }else {
            // 不记录线路
            if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
                // 当拖动结束时 回弹
                springAnimation.fromValue = point
                springAnimation.toValue = identityPoint
                ballView.center = identityPoint
                ballView.layer.add(springAnimation, forKey: "spring")
            }
        }
    }
    
    /// ballView
    lazy var ballView: UIView = {
        let ballView = UIView()
        ballView.isUserInteractionEnabled = true
        return ballView
    }()
    
    // 弹性动画
    private lazy var springAnimation: CASpringAnimation = {
        let animate = CASpringAnimation.init(keyPath: "position")
        animate.mass = 1 //质量，影响图层运动时的弹簧惯性,质量越大，弹簧拉伸和压缩的幅度越大,默认1
        animate.stiffness = 100.0 //弹性系数，弹性系数越大，形变产生的力就越大，运动越快，默认100
        animate.damping = 10.0 //阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快，默认10
        animate.initialVelocity = 10.0 //动画视图的初始速度大小，默认0
        animate.duration = animate.settlingDuration //结算时间 返回弹簧动画到停止时的估算时间
        animate.fillMode = kCAFillModeRemoved // 动画结束后复原
        animate.autoreverses = false // 不做逆动画
        animate.isRemovedOnCompletion = true // 动画结束后自动移除

        return animate
    }()
    
    // 关键帧动画
    private lazy var keyFrameAnimation: CAKeyframeAnimation = {
        let animate = CAKeyframeAnimation.init(keyPath: "position")
        animate.repeatCount = 1
        animate.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn) //  kCAMediaTimingFunctionEaseIn表示开始缓慢逐渐变快，这里符合弹簧动画的效果
        animate.duration = duration
        animate.fillMode = kCAFillModeRemoved // 动画结束后复原
        animate.autoreverses = false // 不做逆动画
        animate.isRemovedOnCompletion = true // 动画结束后移除
        
        return animate
    }()

    /// 用来显示路径
    private var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 2
        
        return shapeLayer
    }()
    
    
    
    
    
}
