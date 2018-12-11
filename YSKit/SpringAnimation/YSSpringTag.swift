//
//  YSSpringTag.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/10.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class YSSpringTag: UIView {
    
    
    /// 气泡粘性系数，越大可以拉的越长
    var viscosity: CGFloat = 15
    
    /// 起始点
    private var identityPoint: CGPoint
    
    /// 动画持续时间
    private var duration: CFTimeInterval = 0.6
    
    /// 路径点数组
    private var pointArray: [CGPoint] = []
    
    /// 不动点
    private var backView = UIView()
    
    /// 颜色
    var color: UIColor = UIColor.red
    
    /// 不动圆的半径
    private var r1: CGFloat = 0
    /// 拖动圆的半径
    private var r2: CGFloat = 0
    /// 不动圆的x坐标
    private var x1: CGFloat = 0
    /// 拖动圆的x坐标
    private var x2: CGFloat = 0
    /// 拖动圆的y坐标
    private var y1: CGFloat = 0
    /// 拖动圆的y坐标
    private var y2: CGFloat = 0
    /// 圆心距
    private var centerDistance: CGFloat = 0
    /// 圆心连线和y轴夹角的cos值
    private var cosDigree: CGFloat = 0
    /// 圆心连线和y轴夹角的sin值
    private var sinDigerss: CGFloat = 0
    
    /// 圆1 切点1
    private var pointA: CGPoint = CGPoint.zero
    /// 圆1 切点2
    private var pointB: CGPoint = CGPoint.zero
    /// 圆2 切点1
    private var pointC: CGPoint = CGPoint.zero
    /// 圆2 切点2
    private var pointD: CGPoint = CGPoint.zero
    /// 切线AD的控制点O
    private var pointO: CGPoint = CGPoint.zero
    /// 切线AD的控制点P
    private var pointP: CGPoint = CGPoint.zero

    /// 记录原始frame
    private var oldBackViewFrame: CGRect = CGRect.zero
    /// 记录原始center
    private var oldBackViewCenter: CGPoint = CGPoint.zero
//    private var initialPoint: CGPoint = CGPoint.zero

    private var cutePath = UIBezierPath()
    

    /// frame width/height 请保持一致, 如不一致，将会取最大值
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tagLabel.font = UIFont.systemFont(ofSize: self.width * 0.5, weight: UIFont.Weight.medium)
    }
    
    func setText(text: String) {
        tagLabel.text = text
    }
    
    func setupUI() {
        
        backView.frame = self.bounds
        backView.addCornerRadius(self.width/2)
        backView.backgroundColor = self.color
        self.addSubview(backView)
        
        tagLabel.frame = self.bounds
        tagLabel.addCornerRadius(self.width/2)
        tagLabel.backgroundColor = self.color
        self.addSubview(tagLabel)
        oldBackViewFrame = backView.frame
        oldBackViewCenter = backView.center
        r2 = tagLabel.width / 2
        
        self.calculatePoints()
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(gesture:)))
        tagLabel.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        tagLabel.layer.removeAllAnimations()
        // 小球跟随手指移动
        let point = gesture.location(in: gesture.view?.superview)
        gesture.view?.center = point
        if gesture.state == .began {
            backView.isHidden = false
        } else if gesture.state == .changed {
            if r1 < self.oldBackViewFrame.width / 4 {
                backView.isHidden = true
            }
            calculatePoints()
            updateViews()
        } else if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            if r1 < self.oldBackViewFrame.width / 4 {
                backView.isHidden = true
                tagLabel.isHidden = true
            } else {
                // 当拖动结束时 回弹
                backView.isHidden = true
                shapLayer.removeFromSuperlayer()
                
                springAnimation.fromValue = point
                springAnimation.toValue = identityPoint
                tagLabel.center = identityPoint
                tagLabel.layer.add(springAnimation, forKey: "spring")
            }
        }
    }
    
    /// 计算图像的坐标
    func calculatePoints() {
        x1 = backView.centerX
        y1 = backView.centerY
        
        x2 = tagLabel.centerX
        y2 = tagLabel.centerY
        
        // 计算圆心距
        let distanceX = x2 - x1
        let distanceY = y2 - y1
        centerDistance = CGFloat(sqrtf(Float(distanceX * distanceX + distanceY * distanceY)))
        if centerDistance == 0 {
            cosDigree = 1
            sinDigerss = 0
        }else {
            cosDigree = (y2 - y1) / centerDistance
            sinDigerss = (x2 - x1) / centerDistance
        }
        
        r1 = oldBackViewFrame.size.width / 2 - centerDistance / self.viscosity
        
        pointA = CGPoint.init(x: x1 - r1 * cosDigree, y: y1 + r1 * sinDigerss)
        pointB = CGPoint.init(x: x1 + r1 * cosDigree, y: y1 - r1 * sinDigerss)
        pointD = CGPoint.init(x: x2 - r2 * cosDigree, y: y2 + r2 * sinDigerss)
        pointC = CGPoint.init(x: x2 + r2 * cosDigree, y: y2 - r2 * sinDigerss)
        pointO = CGPoint.init(x: pointA.x + (centerDistance / 2) * sinDigerss, y: pointA.y + (centerDistance / 2) * cosDigree)
        pointP = CGPoint.init(x: pointB.x + (centerDistance / 2) * sinDigerss, y: pointB.y + (centerDistance / 2) * cosDigree)

    }
    
    func updateViews() {
        backView.bounds = CGRect.init(x: 0, y: 0, width: r1 * 2, height: r1 * 2)
        backView.center = oldBackViewCenter
        backView.layer.cornerRadius = r1
        backView.backgroundColor = color
        
        cutePath.removeAllPoints()
        
        cutePath.move(to: pointA)
        cutePath.addQuadCurve(to: pointD, controlPoint: pointO)
        cutePath.addLine(to: pointC)
        cutePath.addQuadCurve(to: pointB, controlPoint: pointP)
        cutePath.addLine(to: pointA)
        
        if !backView.isHidden {
            shapLayer.path = cutePath.cgPath
            shapLayer.fillColor = color.cgColor
            self.layer.insertSublayer(shapLayer, below: tagLabel.layer)
        }else {
            shapLayer.removeFromSuperlayer()
        }
    }
    
    /// ballView
    lazy var tagLabel: UILabel = {
        let tagLabel = UILabel()
        tagLabel.isUserInteractionEnabled = true
        tagLabel.textColor = UIColor.white
        tagLabel.textAlignment = .center
        return tagLabel
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

    
    lazy var shapLayer: CAShapeLayer = {
        let shapLayer = CAShapeLayer()
        
        return shapLayer
    }()
    
    
    
    
}
