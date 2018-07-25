//
//  ThemeConfiguration.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/23/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

enum ThemeType : Int  {
    case blue
    case oceangreen
    case redfox
    case moonlight
}

class Colors {
    var gl = CAGradientLayer()
    var theme = ThemeType.blue
    var colorTop : CGColor?
    var colorBottom : CGColor?
    
    init() {
        // let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        
    }
    
    func setThemeColor(with theme:ThemeType)
    {
       
        switch theme {
        case .blue:
            colorTop   =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9).cgColor
            colorBottom   = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        case .oceangreen:
            colorTop   =  UIColor(red: 95.0 / 255.0, green: 208.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0).cgColor
            colorBottom   = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        case .redfox:
            colorTop   =  UIColor(red: 238.0 / 255.0, green: 108.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0).cgColor
            colorBottom   = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        case .moonlight:
            colorTop   =  UIColor(red: 96.0 / 255.0, green: 108.0 / 255.0, blue: 131.0 / 255.0, alpha: 1.0).cgColor
            colorBottom   = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        }
        
       // self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.5]
    }
}


class ThemeManager: NSObject {

    static let sharedInstance = ThemeManager()
    var theme = ThemeType.blue
    var color : Colors?
    
     private override  init()  {
        super.init()
        color = Colors()
        getCurrentSetTheme()
        
    }
    
    func getCurrentSetTheme() {
        switch Settings.sharedInstance.themeType {
        case 0:
            theme = .blue
            color?.setThemeColor(with: .blue)
        case 1:
            theme = .oceangreen
            color?.setThemeColor(with: .oceangreen)
        case 2:
            theme = .redfox
           color?.setThemeColor(with: .redfox)
        default:
            color?.setThemeColor(with: .moonlight)
        }
        
    }
    
}
