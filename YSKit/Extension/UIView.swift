//
//  UIView+Frame.swift
//  Hitour
//
//  Created by Veaer on 2017/4/21.
//  Copyright © 2017年 Veaer. All rights reserved.
//

import UIKit

extension UIView {
    
    var width: CGFloat {
        get {
            return frame.width
        }
        set {
            var newFrame = frame
            newFrame.size.width = newValue
            frame = newFrame
        }
    }
    
    var height: CGFloat {
        get {
            return frame.height
        }
        set {
            var newFrame = frame
            newFrame.size.height = newValue
            frame = newFrame
        }
    }
    
    var left: CGFloat {
        get {
            return frame.minX
        }
        set {
            var newFrame = frame
            newFrame.origin.x = newValue
            frame = newFrame
        }
    }

    var right: CGFloat {
        get {
            return frame.maxX
        }
        set {
            var newFrame = frame
            newFrame.origin.x = newValue - frame.size.width
            frame = newFrame
        }
    }
    
    var top: CGFloat {
        get {
            return frame.minY
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var bottom: CGFloat {
        get {
            return frame.maxY
        }
        set {
            var newFrame = frame
            newFrame.origin.y = newValue - frame.size.height
            frame = newFrame
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint.init(x: newValue, y: self.center.y)
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint.init(x: self.center.x, y: newValue)
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        
        set {
            var frame = self.frame
            frame.origin = origin
            self.frame = frame
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = size
            self.frame = frame
        }
    }
    
    var viewController: UIViewController? {
        get{
            var view: UIView? = self
            while view != nil {
                let nextResponder = view?.next
                if nextResponder?.isKind(of: UIViewController.self) == true{
                    return nextResponder as? UIViewController
                }
                view = view?.superview
            }
            return nil
        }
    }
    
    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func addBorder(_ width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func addBorder(_ width: CGFloat, color: UIColor, cornerRadius: CGFloat) {
        self.addBorder(width, color: color)
        self.layer.cornerRadius = cornerRadius
    }
    
    func addShadow(_ color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowPath = UIBezierPath.init(rect: self.bounds).cgPath
    }
    
    
    func addShadowWithRadius(_ radius: CGFloat,color: UIColor, offset: CGSize, opacity: Float)  {
        
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))
        self.layer.shadowPath = maskPath.cgPath
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.cornerRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    func addCorner(aCorners : UIRectCorner, aSize : CGSize) ->Void
    {
        // 根据矩形画带圆角的曲线
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: aCorners, cornerRadii: aSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func blink(_ backgroundColor: UIColor, borderColor: UIColor, borderWidth: CGFloat) {
        let originalBackgroundColor = self.backgroundColor
        //		UIView.animateWithDuration(0.5, delay: 0, options: [UIViewAnimationOptions.CurveEaseIn, UIViewAnimationOptions.Autoreverse], animations: {
        //			self.backgroundColor = backgroundColor
        //			self.layer.borderWidth = borderWidth
        //			self.layer.borderColor = borderColor.CGColor
        //		}) { completed in
        //			UIView.animateWithDuration(0.5, animations: {
        //				self.backgroundColor = originalBackgroundColor
        //				self.layer.borderWidth = 0
        //				self.layer.borderColor = UIColor.clearColor().CGColor
        //			})
        //		}
        
        let backgroundAni: CABasicAnimation = CABasicAnimation(keyPath: "backgroundColor")
        backgroundAni.fromValue = originalBackgroundColor?.cgColor
        backgroundAni.toValue = backgroundColor.cgColor
        
        let colorAni: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        colorAni.fromValue = UIColor.clear.cgColor
        colorAni.toValue = borderColor.cgColor
        //		self.layer.backgroundColor = backgroundColor.CGColor
        
        let widthAni: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        widthAni.fromValue = 0
        widthAni.toValue = borderWidth
        
        //        Width.duration=4
        //		self.layer.borderWidth = 0
        
        let both: CAAnimationGroup = CAAnimationGroup()
        both.duration = 0.5
        //		both.beginTime = 0.6
        both.repeatCount = 2
        both.animations = [backgroundAni, colorAni, widthAni]
        both.autoreverses = true
        both.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.layer.add(both, forKey: "color and Width")
        
    }
    
    func routeWithDuration(duration: CFTimeInterval, byAngle angle: Float) {
        CATransaction.begin()
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.byValue = NSNumber.init(value:angle)
        rotationAnimation.duration = duration
        rotationAnimation.isRemovedOnCompletion = true
        
        CATransaction.setCompletionBlock {[weak self] in
            self?.transform = CGAffineTransform.init(rotationAngle: CGFloat(angle))
        }
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
        CATransaction.commit()
    }
    
    
    /// 生成截图
    ///
    /// - Returns: 截图
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        guard let content = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: content)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
    
    func snapshotImageAfterScreenUpdates(afterUpdates: Bool) -> UIImage? {
        if !self.responds(to: #selector(drawHierarchy(in:afterScreenUpdates:))) {
            return self.snapshotImage()
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterUpdates)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
    
    func removeSubviews() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    func convertPoit(point: CGPoint, toViewOrWindow view: UIView?) -> CGPoint {
        guard let view = view else {
            if let windowSelf = self as? UIWindow {
                return windowSelf.convert(point, to: nil)
            }else {
                return self.convert(point, to: nil)
            }
        }
        
        let fromWindow = self.isKind(of: UIWindow.self) ? self as? UIWindow : self.window
        let toWindow = view.isKind(of: UIWindow.self) ? view as? UIWindow : self.window
        if (fromWindow == nil || toWindow == nil) || fromWindow == toWindow {
            return self.convert(point, to: view)
        }
        var point: CGPoint = self.convert(point, to: fromWindow)
        point = toWindow!.convert(point, from: fromWindow)
        point = view.convert(point, from: toWindow)
        
        return point
    }
    
    func convertPoint(point: CGPoint, fromViewOrWindow view: UIView?) -> CGPoint {
        guard let view = view else {
            if let windowSelf = self as? UIWindow {
                return windowSelf.convert(point, from: nil)
            }else {
                return self.convert(point, from: nil)
            }
        }
        
        let fromWindow = view.isKind(of: UIWindow.self) ? view as? UIWindow : view.window
        let toWindow = self.isKind(of: UIWindow.self) ? self as? UIWindow : self.window
        if (fromWindow == nil || toWindow == nil) || fromWindow == toWindow {
            return self.convert(point, from: view)
        }
        var point: CGPoint = fromWindow!.convert(point, from: view)
        point = toWindow!.convert(point, from: fromWindow)
        point = self.convert(point, from: toWindow)
        
        return point
    }

    func convertRect(rect: CGRect, toViewOrWindow view: UIView?) -> CGRect {
        guard let view = view else {
            if let windowSelf = self as? UIWindow {
                return windowSelf.convert(rect, to: nil)
            }else {
                return self.convert(rect, to: nil)
            }
        }
        
        let fromWindow = self.isKind(of: UIWindow.self) ? self as? UIWindow : self.window
        let toWindow = view.isKind(of: UIWindow.self) ? view as? UIWindow : self.window
        if (fromWindow == nil || toWindow == nil) || fromWindow == toWindow {
            return self.convert(rect, to: view)
        }
        var rect: CGRect = self.convert(rect, to: fromWindow)
        rect = toWindow!.convert(rect, from: fromWindow)
        rect = view.convert(rect, from: toWindow)
        
        return rect
    }

    func convertRect(rect: CGRect, fromViewOrWindow view: UIView?) -> CGRect {
        guard let view = view else {
            if let windowSelf = self as? UIWindow {
                return windowSelf.convert(rect, from: nil)
            }else {
                return self.convert(rect, from: nil)
            }
        }
        
        let fromWindow = view.isKind(of: UIWindow.self) ? view as? UIWindow : view.window
        let toWindow = self.isKind(of: UIWindow.self) ? self as? UIWindow : self.window
        if (fromWindow == nil || toWindow == nil) || fromWindow == toWindow {
            return self.convert(rect, from: view)
        }
        var rect: CGRect = fromWindow!.convert(rect, from: view)
        rect = toWindow!.convert(rect, from: fromWindow)
        rect = self.convert(rect, from: toWindow)
        
        return rect
    }
}

protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {
    // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromXib() -> Self {
        let nibName = "\(self)".split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
    
}
