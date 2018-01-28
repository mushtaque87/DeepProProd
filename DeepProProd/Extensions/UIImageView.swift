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
        /*
            if (Settings.sharedInstance.language == "English")
            {
                 self.image = UIImage(named: "Eng_BackGround")
            }
            else{
                 self.image = UIImage(named: "Arb_Background")
            }
        */
        
        switch Settings.sharedInstance.themeType {
        case 1?:
            self.image = UIImage(named: "Carbon")
            break
        case 2?:
            self.image = UIImage(named: "Abstract")
            break
        case 3?:
            self.image = UIImage(named: "Arb_Background")
            break
        case 4?:
            self.image = UIImage(named: "Eng_BackGround")
            break
        default:
            self.image = UIImage(named: "Eng_BackGround")
            break
        }
        
        
    }
}
