//
//  UIImageView.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/11/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import  UIKit

extension UIImageView
{
    func setBackGroundimage() {
        //Align UIButton Title
        
            if (Settings.sharedInstance.language == "English")
            {
                 self.image = UIImage(named: "Eng_BackGround")
            }
            else{
                 self.image = UIImage(named: "Arb_Background")
        }
        
    }
}
