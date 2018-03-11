//
//  UILabel.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/19/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import  UIKit

extension UIView {
    
        func loadNib() -> UIView {
            let bundle = Bundle(for: type(of: self))
            let nibName = type(of: self).description().components(separatedBy: ".").last!
            let nib = UINib(nibName: nibName, bundle: bundle)
            return nib.instantiate(withOwner: self, options: nil).first as! UIView
        }
        
        func slideInFromLeft(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
            // Create a CATransition animation
            let slideInFromLeftTransition = CATransition()
            
            // Set its callback delegate to the completionDelegate that was provided (if any)
            if let delegate: AnyObject = completionDelegate {
                slideInFromLeftTransition.delegate = delegate as? CAAnimationDelegate
            }
            
            // Customize the animation's properties
            slideInFromLeftTransition.type = kCATransitionPush
            slideInFromLeftTransition.subtype = kCATransitionFromLeft
            slideInFromLeftTransition.duration = duration
            slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            slideInFromLeftTransition.fillMode = kCAFillModeRemoved
            
            // Add the animation to the View's layer
            self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        }
    
    func slideInFromRight(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromRight
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromRightTransition")
    }
    
    func slideBackToLeft(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideBackToLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideBackToLeftTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        // Customize the animation's properties
        slideBackToLeftTransition.type = kCATransitionPush
        slideBackToLeftTransition.subtype = kCATransitionFromLeft
        slideBackToLeftTransition.duration = duration
        slideBackToLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        //slideBackToLeftTransition.fillMode = kCAFillModeRemoved
        
       
        // Add the animation to the View's layer
        self.layer.add(slideBackToLeftTransition, forKey: "slideBackToLeftTransition")
    }
    func slideBackToRight(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideBackToRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideBackToRightTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        // Customize the animation's properties
        slideBackToRightTransition.type = kCATransitionPush
        slideBackToRightTransition.subtype = kCATransitionFromLeft
        slideBackToRightTransition.duration = duration
        slideBackToRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideBackToRightTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(slideBackToRightTransition, forKey: "slideBackToRightTransition")
    }
    
   
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)    }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func alignText() {
        //Align UIButton Title
        if let view = self as? UIButton {
        if (Settings.sharedInstance.language == "English")
        {
            return view.contentHorizontalAlignment = .left
        }
        else{
            return view.contentHorizontalAlignment = .right
        }
      }
        //Align UILablel text
        if let view = self as? UILabel {
            if (Settings.sharedInstance.language == "English")
            {
                return view.textAlignment = .left
            }
            else{
                return view.textAlignment = .right
            }
        }

    }
 
}
