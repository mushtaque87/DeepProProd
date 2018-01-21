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
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
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
