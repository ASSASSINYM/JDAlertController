//
//  CALayer+Extension.swift
//  testi
//
//  Created by Jawad Ali on 20/08/2020.
//  Copyright © 2020 Jawad Ali. All rights reserved.
//

import UIKit
public typealias AnimationCompletion = (() -> Void)?

public extension CALayer {

    var areAnimationsEnabled: Bool {
            get { delegate == nil }
            set { delegate = newValue ? nil : CALayerAnimationsDisablingDelegate.shared }
        }

    private class CALayerAnimationsDisablingDelegate: NSObject, CALayerDelegate {
        static let shared = CALayerAnimationsDisablingDelegate()
        private let null = NSNull()

        func action(for layer: CALayer, forKey event: String) -> CAAction? {
            null
        }
     }

       func bringToFront() {
          guard let sLayer = superlayer else {
             return
          }
          removeFromSuperlayer()
          sLayer.insertSublayer(self, at: UInt32(sLayer.sublayers?.count ?? 0))
       }

       func sendToBack() {
          guard let sLayer = superlayer else {
             return
          }
          removeFromSuperlayer()
          sLayer.insertSublayer(self, at: 0)
       }

      func animateGradientColors(from: [CGColor], toColor: [CGColor], duration: Double) {
          let animation = CABasicAnimation(keyPath: "colors")
          animation.fromValue = from
          animation.toValue = toColor
          animation.duration = duration
          animation.fillMode = .forwards
          animation.isRemovedOnCompletion = false

          // add the animation to the gradient
          self.add(animation, forKey: nil)

      }

    func strokeAnimation(duration: Double, delay: Double, completion: AnimationCompletion) {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.beginTime =  CACurrentMediaTime() + delay
        animation.toValue = 1
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        CATransaction.setCompletionBlock(completion)
        self.add(animation, forKey: "line")
        CATransaction.commit()
    }

    func boundsAnimationFrames(bounds: [CGRect], times: [Double], duration: Double, delay: Double ) {
           let rotationAnimation = CAKeyframeAnimation(keyPath: "bounds")
           rotationAnimation.beginTime =  CACurrentMediaTime() + delay
           rotationAnimation.duration =  duration
           rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
           rotationAnimation.fillMode = .forwards
           rotationAnimation.isRemovedOnCompletion = false
           rotationAnimation.values = bounds
           rotationAnimation.keyTimes = times.map { NSNumber(value: $0) }
           self.add(rotationAnimation, forKey: nil)
       }

    func rotateAnimationFrames(angels: [CGFloat], times: [Double], duration: Double, delay: Double, completion: AnimationCompletion) {
        CATransaction.begin()
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.beginTime =  CACurrentMediaTime() + delay
        rotationAnimation.duration =  duration
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.values = angels
        CATransaction.setCompletionBlock(completion)
        rotationAnimation.keyTimes = times.map { NSNumber(value: $0) }
        self.add(rotationAnimation, forKey: nil)
         CATransaction.commit()
    }

    func rotateAnimation(angal: CGFloat, duration: Double, repeatAnimation: Bool = false, delay: Double) {

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = angal
        rotationAnimation.beginTime =  CACurrentMediaTime() + delay
        rotationAnimation.duration =  duration
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.repeatCount = repeatAnimation ? .infinity : 0
        self.add(rotationAnimation, forKey: "rotation")
    }

    func removeRotationAnimation() {
        self.removeAnimation(forKey: "rotation")
    }

    func animateShape(path: CGPath, duration: Double, delay: Double) {

        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.beginTime =  CACurrentMediaTime() + delay
        animation.toValue = path
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards

        self.add(animation, forKey: nil)

    }

    func doMask(by imageMask: UIImage) {
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = CGRect(x: 0, y: 0, width: imageMask.size.width, height: imageMask.size.height)
        bounds = maskLayer.bounds
        maskLayer.contents = imageMask.cgImage
        maskLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        mask = maskLayer
    }

    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size,
                                               isOpaque,
                                               UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}
