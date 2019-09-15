//
//  CircleWarmerView.swift
//  CircleWarmerView
//
//  Created by Yu Sun on 23/5/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import UIKit

struct CircleWarmerViewModel {
    
    private init() { }
    
    struct Item {
        
        let center: CGPoint
        let description: String
    }
}

class RadialGradientLayer: CALayer {
    
    override init(){
        
        super.init()
        
        needsDisplayOnBoundsChange = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        
        ctx.saveGState()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let startColor = UIColor.red.cgColor
        let endColor = UIColor(red: 75/255, green: 183/255, blue: 72/255, alpha: 1.0).cgColor
        let colors = [startColor, endColor] as CFArray
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
  
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil) {
            ctx.drawRadialGradient(
                gradient,
                startCenter: center,
                startRadius: 0,
                endCenter: center,
                endRadius: max(bounds.width, bounds.height) / 2,
                options: .drawsBeforeStartLocation
            )
        }
        
        super.draw(in: ctx)
    }
}

final class CircleWarmerView: UIView {
    
    private let model: [CircleWarmerViewModel.Item]
    
    private lazy var gradientLayer = RadialGradientLayer()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.addSublayer(gradientLayer)
        
        return view
    }()
    
    init(model: [CircleWarmerViewModel.Item]) {
        self.model = model
        
        super.init(frame: .zero)
    
        backgroundColor = .clear
        addSubview(contentView)
        
        if let firstItem = model.first {
            let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            contentView.frame = frame
            contentView.center = firstItem.center
            contentView.layer.cornerRadius = frame.width / 2
            contentView.clipsToBounds = true
            
            // Gradient
            let offset: CGFloat = 5
            gradientLayer.bounds = CGRect(x: 0, y: 0, width: frame.width + offset * 2, height: frame.height + offset * 2)
            gradientLayer.position = CGPoint(x: frame.width / 2 - offset, y: frame.height / 2)
            
            let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
            
            // Pulsing Layer
            let circlePath = UIBezierPath(
                arcCenter: .zero,
                radius: 10,
                startAngle: 0,
                endAngle: 2 * .pi,
                clockwise: false
            )
            
            let pulsingLayer = CAShapeLayer()
            pulsingLayer.path = circlePath.cgPath
            pulsingLayer.strokeColor = UIColor.yellow.withAlphaComponent(0.2).cgColor
            pulsingLayer.lineWidth = 1
            pulsingLayer.lineCap = .round
            pulsingLayer.fillColor = UIColor.yellow.withAlphaComponent(0.2).cgColor
            pulsingLayer.position = center
            contentView.layer.addSublayer(pulsingLayer)
            
            // Pulsing Animation
            let pulsingAnimation = CABasicAnimation(keyPath: "transform.scale")
            pulsingAnimation.toValue = 1.3
            pulsingAnimation.duration = 0.8
            pulsingAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            pulsingAnimation.autoreverses = true
            pulsingAnimation.repeatCount = .infinity
            pulsingLayer.add(pulsingAnimation, forKey: "pulsing")
            
            // Mask
            let path = UIBezierPath(rect: frame)
            path.append(UIBezierPath(
                arcCenter: center,
                radius: 10,
                startAngle: 0,
                endAngle: 2 * .pi,
                clockwise: false
            ))

            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            contentView.layer.mask = maskLayer
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self { print("Hit self") }
        move(to: point)
        
        return view
    }
    
    private func move(to destination: CGPoint) {
        UIView.animate(
            withDuration: 2,
            delay: 0,
            options: [.curveEaseInOut, .layoutSubviews],
            animations: {
                self.contentView.center = destination
            },
            completion: nil
        )
    }
}
