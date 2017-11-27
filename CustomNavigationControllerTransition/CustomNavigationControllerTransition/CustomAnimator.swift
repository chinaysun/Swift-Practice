//
//  CustomAnimator.swift
//  CustomNavigationControllerTransition
//
//  Created by Yu Sun on 27/11/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    var duration: TimeInterval = 0.4
    var isPresenting: Bool = false
    var originFrame: CGRect = CGRect.zero
    var image: UIImage = UIImage()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        self.isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
        
        let detailView = isPresenting ? toView : fromView
        
        guard let artWork = toView.viewWithTag(99) as? UIImageView else { return }
        artWork.image = image
        artWork.alpha = 0
        
        let transitionImageView = UIImageView(frame: isPresenting ? originFrame : artWork.frame )
        transitionImageView.image = image
        
        container.addSubview(transitionImageView)
        
        
        toView.frame = isPresenting ? CGRect(x: fromView.frame.width,
                                            y: 0,
                                            width: toView.frame.width,
                                            height: toView.frame.height) : toView.frame
        
        toView.alpha = isPresenting ? 0 : 1
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        
                            transitionImageView.frame = self.isPresenting ? artWork.frame : self.originFrame
                            detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
                            detailView.alpha = self.isPresenting ? 1 : 0
                        
                        }) { finished in
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                            transitionImageView.removeFromSuperview()
                            artWork.alpha = 1
                        }
        
        
        
        
    }
    
}
