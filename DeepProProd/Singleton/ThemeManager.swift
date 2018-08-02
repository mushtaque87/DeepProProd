//
//  ThemeConfiguration.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/23/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

enum ThemeType : Int  {
    case defaults
    case blue
    case red
    case pink
}

class Colors {
    var gl = CAGradientLayer()
    var theme = ThemeType.blue
    var colorTop : CGColor?
    var colorBottom : CGColor?
    var isGradientOn: Bool = true
    
     init() {
        // let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
       // setThemeColor(with: .blue , isGradientOn)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Colors()
        copy.colorTop = colorTop
        copy.colorBottom = colorBottom
        return copy
    }
    
    func setThemeColor(with theme:ThemeType , _ isGradientOn: Bool  = true)
    {
       
        /*
        switch theme {
        case .blue:
            colorTop   =  UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.gradientColor_Top!).cgColor
            colorBottom   = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.gradientColor_Bottom!).cgColor
        case .oceangreen:
//            colorTop   =  UIColor(red: 95.0 / 255.0, green: 208.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0).cgColor
//            colorBottom   = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
            colorTop   =  UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.gradientColor_Top!).cgColor
            colorBottom   = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.gradientColor_Bottom!).cgColor
        case .redfox:
//            colorTop   =  UIColor(red: 238.0 / 255.0, green: 108.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0).cgColor
//            colorBottom   = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
            
            colorTop   =  UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.gradientColor_Top!).cgColor
            colorBottom   = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.gradientColor_Bottom!).cgColor
            
        case .moonlight:
//            colorTop   =  UIColor(red: 96.0 / 255.0, green: 108.0 / 255.0, blue: 131.0 / 255.0, alpha: 1.0).cgColor
//            colorBottom   = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
            colorTop   =  UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.gradientColor_Top!).cgColor
            colorBottom   = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.gradientColor_Bottom!).cgColor
        }
 */
        colorTop   =  UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.gradientColor_Top!).cgColor
        colorBottom   = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.gradientColor_Bottom!).cgColor
       // self.gl = CAGradientLayer()
        if(isGradientOn == true) {
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.5]
        }else {
            self.gl.colors = [colorTop, colorTop]
            self.gl.locations = [0.0, 1.0]
        }
    }
}


class ThemeManager: NSObject {

    static let sharedInstance = ThemeManager()
    var theme = ThemeType.blue
    var color : Colors?
    private var themePath : String?
    private var themePlistName : String?
    private var themeDict : NSMutableDictionary?
    var backgroundColor_Regular: String?
    var backgroundColor_Dark: String?
    var backgroundColor_Light: String?
    var gradientColor_Top: String?
    var gradientColor_Bottom: String?
    var font_Bold: String?
    var font_SemiBold: String?
    var font_Medium: String?
    var font_Regular: String?
    var font_Italic: String?
    var fontSize_Large: Int?
    var fontSize_Medium: Int?
    var fontSize_Small: Int?
    var font_Color: String?
    var score_25: String?
    var score_50: String?
    var score_75: String?
    var score_100: String?
    var contentCell_Backgroundcolor: String?
    var navigationbar_tintColor:String?
    var units_Assigned : String?
    var units_Submitted : String?
    var units_Reviewed : String?
    private override  init()  {
        super.init()
        updateCurrentTheme()
        reloadThemeDictionary()
      // color = Colors()
        
       // getCurrentTheme()
        // setGradientLayer(with: true)
    }
    
    
    func updateCurrentTheme() {
        switch Settings.sharedInstance.themeType {
        case 0:
            theme = .defaults
            themePlistName = "Theme_Default.plist"
            themePath =  Helper.getDocumentDirectory().appendingPathComponent("Theme_Default.plist")
            //color?.setThemeColor(with: .blue)
        case 1:
            theme = .blue
            themePlistName = "Theme_Blue.plist"
            themePath =   Helper.getDocumentDirectory().appendingPathComponent("Theme_Blue.plist")
            //color?.setThemeColor(with: .oceangreen)
        case 2:
            theme = .red
            themePlistName = "Theme_Red.plist"
            themePath =   Helper.getDocumentDirectory().appendingPathComponent("Theme_Red.plist")
           //color?.setThemeColor(with: .redfox)
        default:
            theme = .pink
            themePlistName = "Theme_Pink.plist"
            themePath =   Helper.getDocumentDirectory().appendingPathComponent("Theme_Pink.plist")
            //color?.setThemeColor(with: .moonlight)
        }
        
    }
    
    func reloadThemeDictionary()
    {
        if let path = themePath {
            themeDict = NSMutableDictionary(contentsOfFile: path)
             backgroundColor_Regular = themeDict!["BackgroundColor_Regular"] as? String
             backgroundColor_Dark = themeDict!["BackgroundColor_Dark"] as? String
             backgroundColor_Light = themeDict!["BackgroundColor_Light"] as? String
             gradientColor_Top = themeDict!["GradientColor_Top"] as? String
             gradientColor_Bottom = themeDict!["GradientColor_Bottom"] as? String
             font_Bold = themeDict!["Font_Bold"] as? String
             font_SemiBold = themeDict!["Font_SemiBold"] as? String
             font_Medium = themeDict!["Font_Medium"] as? String
             font_Regular = themeDict!["Font_Regular"] as? String
             font_Italic = themeDict!["Font_Italic"] as? String
             fontSize_Large = themeDict!["FontSize_Large"] as? Int
             fontSize_Medium = themeDict!["FontSize_Medium"] as? Int
             fontSize_Small = themeDict!["FontSize_Small"] as? Int
             font_Color = themeDict!["Font_Color"] as? String
             score_25 = themeDict!["Score_25"] as? String
             score_50 = themeDict!["Score_50"] as? String
             score_75 = themeDict!["Score_75"] as? String
             score_100 = themeDict!["Score_100"] as? String
             contentCell_Backgroundcolor = themeDict!["ContentCell_Backgroundcolor"] as? String
             navigationbar_tintColor = themeDict!["Navigationbar_tintColor"] as? String
             units_Assigned = themeDict!["Units_Assigned"] as? String
             units_Submitted = themeDict!["Units_Submitted"] as? String
             units_Reviewed = themeDict!["Units_Reviewed"] as? String
             //contentCell_BackgroundColor = themeDict!["ContentCell_BackgroundColor"] as? String
        }
        else{
            updateCurrentTheme()
            Helper.updateFileFromBundle(to: Helper.getDocumentDirectory, filename: "Theme", ofType: "plist")
            reloadThemeDictionary()
        }
    }
    
    func setGradientLayer(with gradientOn:Bool = true)  {
        guard color != nil else {
            color = Colors()
            setGradientLayer(with: gradientOn)
            return
        }
        color?.setThemeColor(with: ThemeType(rawValue: Settings.sharedInstance.themeType!)! , gradientOn)

    }
    
    
}
