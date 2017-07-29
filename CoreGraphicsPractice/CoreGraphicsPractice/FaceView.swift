//
//  FaceView.swift
//  CoreGraphicsPractice
//
//  Created by SUN YU on 30/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class FaceView: UIView {

    var scale:CGFloat = 0.90
    
    private var skullRadius:CGFloat
    {
       return min(bounds.size.width,bounds.size.height) / 2 * scale
    }
    
    private var skullCenter:CGPoint
    {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios
    {
        static let SkullRadiusToEyeOffet:CGFloat = 3
        static let SkullRadiusToEyeRadius:CGFloat = 10
        static let SkullRadiusToMouthWidth:CGFloat = 1
        static let SkullRadiusToMouthHigh:CGFloat = 3
        static let SkullRadiusToMouthOffset:CGFloat = 3
    }
    
    private enum Eye
    {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint:CGPoint,withRadius radius:CGFloat) ->UIBezierPath
    {
        let path =  UIBezierPath(
            arcCenter: midPoint,
            radius: radius, startAngle: 0.0,
            endAngle: CGFloat(2 * Double.pi),
            clockwise: false
        )
        path.lineWidth = 5.0
        return path
    }
    
    private func getEyeCenter(eye:Eye) -> CGPoint
    {
        let eyeOffset  = skullRadius / Ratios.SkullRadiusToEyeOffet
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
            
        }
        
        return eyeCenter
        
    }
    
    private func pathForEye(eye:Eye) ->UIBezierPath
    {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        
        return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
        
        
    }
    
    private func pathForMouth()->UIBezierPath
    {
        let mouthHigh = skullRadius / Ratios.SkullRadiusToMouthHigh
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHigh)
        
        let mouthCurvature:Double = 1.0 // 1 full-smile, -1 full frown
        let smileOffset = CGFloat(max(-1,min(mouthCurvature,1))) * mouthRect.height
        let start = CGPoint(x:mouthRect.minX,y:mouthRect.minY)
        let end = CGPoint(x:mouthRect.maxX,y:mouthRect.minY)
        let cp1 = CGPoint(x:mouthRect.minX + mouthRect.width / 3,y:mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x:mouthRect.maxX - mouthRect.width / 3,y:mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        
        return path
        
        
    }
    
    override func draw(_ rect: CGRect)
    {
        UIColor.blue.set()
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
    }
    

}
