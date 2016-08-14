//
//  CardView.swift
//  ToKnight
//
//  Created by Adam Behrman on 7/2/16.
//  Copyright © 2016 Adam Behrman. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }

/*
    var xDistanceFromCenter: CGFloat
    var yDistanceFromCenter: CGFloat
    var originalLocation: CGPoint
    var animationDirection: Double
    
    let rotationMax = CGFloat(15.0)
    let defaultRotationAngle = 5.0
    let scaleMin = CGFloat(0.5)
    
    func panGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        xDistanceFromCenter = gestureRecognizer.translationInView(self).x
        yDistanceFromCenter = gestureRecognizer.translationInView(self).y
        
        let touchLocation = gestureRecognizer.locationInView(self)
        switch gestureRecognizer.state {
        case .Began:
            originalLocation = center
            
            animationDirection = touchLocation.y >= frame.size.height / 2 ? -1.0 : 1.0
            layer.shouldRasterize = true
            break
            
        case .Changed:
            
            let rotationStrength = min(xDistanceFromCenter / self.frame.size.width, rotationMax)
            let rotationAngle = CGFloat(animationDirection * defaultRotationAngle) * rotationStrength
            let scaleStrength = 1 - ((1 - scaleMin) * fabs(rotationStrength))
            let scale = max(scaleStrength, scaleMin)
            
            layer.rasterizationScale = scale * UIScreen.mainScreen().scale
            
            let transform = CGAffineTransformMakeRotation(rotationAngle)
            let scaleTransform = CGAffineTransformScale(transform, scale, scale)
            
            self.transform = scaleTransform
            center = CGPoint(x: originalLocation.x + xDistanceFromCenter, y: originalLocation.y + yDistanceFromCenter)
            
            updateOverlayWithFinishPercent(xDistanceFromCenter! / frame.size.width)
            //100% - for proportion
            delegate?.cardDraggedWithFinishPercent(self, percent: min(fabs(xDistanceFromCenter! * 100 / frame.size.width), 100))
            
            break
        case .Ended:
            swipeMadeAction()
            
            layer.shouldRasterize = false
        default :
            break
        }
    }
*/
}