//
//  ViewControllerExtensions.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/9/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import UIKit
extension MainViewController
{
    
    func addSubView(addChildViewController childViewController: UIViewController , on parentViewController: UIViewController   ) {
        self.currentViewController = childViewController
        parentViewController.addChildViewController(childViewController)
        parentViewController.view.addSubview(childViewController.view)
    }

    func bringViewController(toFront childViewController: UIViewController , on parentViewController: UIViewController)
    {
         self.currentViewController = childViewController
    }
    
    func remove(viewController childViewController: UIViewController , from parentViewController: UIViewController)
    {
        childViewController.view.removeFromSuperview()
        
    }
    
}
