//
//  YSLoading.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/3.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class YSLoading: UIView {
    
    enum YSLoadingBallDirection {
        case positive // 正向
        case negative // 反向
    }
    
    // 球宽
    var ballWidth: CGFloat = 12
    // 缩放比例
    var ballZoomScale: CGFloat = 0.25
    // 球速
    var ballSpeed: CGFloat = 0.7
    // 暂停时间
    var pauseSecond: CGFloat = 0.18
    
    private var greenBall: UIView = UIView.init()
    private var redBall: UIView = UIView.init()
    private var blackBall: UIView = UIView.init()
    private var ballContiner: UIView = UIView.init()
    private var displayLink: CADisplayLink?
    private var direction: YSLoadingBallDirection = .positive
    
    class func show(in view: UIView) -> YSLoading {
        let loading = YSLoading.init(frame: view.bounds)
        view.addSubview(loading)
//        view.
        loading.setupUI()
        loading.startAnimation()
        return loading
    }
    
    class func hide(in view: UIView) {
        for subview in view.subviews {
            if let loadingView = subview as? YSLoading {
                loadingView.stopAnimation()
                loadingView.removeFromSuperview()
            }
        }
    }
    
    func setupUI() {
        ballContiner.frame = CGRect.init(x: 0, y: 0, width: 2.1 * ballWidth, height: ballWidth)
        ballContiner.center = self.center
        
        // 绿球
        greenBall.frame = CGRect.init(x: 0, y: 0, width: ballWidth, height: ballWidth)
        greenBall.backgroundColor = UIColor.init(red: 35/255, green: 246/255, blue: 235/255, alpha: 1)
        greenBall.layer.cornerRadius = ballWidth / 2
        greenBall.layer.masksToBounds = true
        
        // 红球
        redBall.frame = CGRect.init(x: ballContiner.frame.width - ballWidth, y: 0, width: ballWidth, height: ballWidth)
        redBall.backgroundColor = UIColor.init(red: 255/255, green: 46/255, blue: 86/255, alpha: 1)
        redBall.layer.cornerRadius = ballWidth / 2
        redBall.layer.masksToBounds = true
        
        blackBall.frame = CGRect.init(x: 0, y: 0, width: ballWidth, height: ballWidth)
        blackBall.backgroundColor = UIColor.init(red: 12/255, green: 11/255, blue: 17/255, alpha: 1)
        blackBall.layer.cornerRadius = ballWidth / 2
        
        
        self.addSubview(ballContiner)
        ballContiner.addSubview(greenBall)
        ballContiner.addSubview(redBall)
        
        self.displayLink = CADisplayLink.init(target: self, selector: #selector(updateBallAnimations))
    }
    
    /// 开始动画
    func startAnimation() {
        self.displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    /// 结束动画
    func stopAnimation() {
        self.displayLink?.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    func pauseAnimated() {
        stopAnimation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(pauseSecond * 1000))) {
            self.startAnimation()
        }
    }
    
    /// 动画
    @objc func updateBallAnimations() {
        var largerBall: UIView = greenBall
        var smallBall: UIView = redBall
        // 正向移动
        if direction == .positive {
            largerBall = greenBall
            smallBall = redBall
        }else {
            largerBall = redBall
            smallBall = greenBall
        }
        ballContiner.bringSubview(toFront: largerBall)
        largerBall.addSubview(blackBall)
        
        // 大球向右 小球向左
        largerBall.centerX = largerBall.centerX + ballSpeed
        smallBall.centerX = smallBall.centerX - ballSpeed
        
        
        // 对球进行放大缩小动画
        largerBall.transform = ballZoomInAnimation(centerX: largerBall.centerX)
        smallBall.transform = ballZoomOutAnimation(centerX: smallBall.centerX)
        
        // 黑球随着小球移动
        let blackBallFrame = smallBall.convert(smallBall.bounds, to: largerBall)
        blackBall.frame = blackBallFrame
        blackBall.layer.cornerRadius = blackBall.width/2.0;

        // 移动到头
        if largerBall.right >= self.ballContiner.width || smallBall.left <= 0 {
            // 反转方向
            self.direction = self.direction == .positive ? .negative : .positive
            // 暂停一下
            self.pauseAnimated()
        }
    }
    
    /// 放大动画
    func ballZoomInAnimation(centerX: CGFloat) -> CGAffineTransform {
        let cosValue = getCosValue(centerX: centerX)
        let scale = 1 + cosValue * ballZoomScale
        return CGAffineTransform.init(scaleX: scale, y: scale)
    }
    
    /// 缩小动画
    func ballZoomOutAnimation(centerX: CGFloat) -> CGAffineTransform {
        let cosValue = getCosValue(centerX: centerX)
        let scale = 1 - cosValue * ballZoomScale
        return CGAffineTransform.init(scaleX: scale, y: scale)
    }
    
    /// 根据位置获取cos值
    func getCosValue(centerX: CGFloat) -> CGFloat {
        let apart = centerX - self.ballContiner.width / 2
        let maxAppart = (ballContiner.width - ballWidth) / 2
        
        let angle = apart / maxAppart * CGFloat.pi / 2
        return cos(angle)
    }
    
    
    
    
}
