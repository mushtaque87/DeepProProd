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
       
        switch theme {
        case .blue:
            colorTop   =  UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Blue!).cgColor
            colorBottom   = UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Bottom!).cgColor
        case .oceangreen:
//            colorTop   =  UIColor(red: 95.0 / 255.0, green: 208.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0).cgColor
//            colorBottom   = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
            colorTop   =  UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Green!).cgColor
            colorBottom   = UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Bottom!).cgColor
        case .redfox:
//            colorTop   =  UIColor(red: 238.0 / 255.0, green: 108.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0).cgColor
//            colorBottom   = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
            
            colorTop   =  UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Red!).cgColor
            colorBottom   = UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Bottom!).cgColor
            
        case .moonlight:
//            colorTop   =  UIColor(red: 96.0 / 255.0, green: 108.0 / 255.0, blue: 131.0 / 255.0, alpha: 1.0).cgColor
//            colorBottom   = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
            colorTop   =  UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Dark!).cgColor
            colorBottom   = UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Bottom!).cgColor
        }
 
       // colorTop   =  UIColor.colorFrom(hexString: ThemeManager.sharedInstance.gradientColor_Top!).cgColor
       // colorBottom   = UIColor.colorFrom(hexString: ThemeManager.sharedInstance.gradientColor_Bottom!).cgColor
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
    var score_80: String?
    var score_30: String?
    var score_30_80: String?
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
            theme = .blue
            themePlistName = "Theme_Blue.plist"
            themePath =  Helper.getDocumentDirectory().appendingPathComponent("Theme_Blue.plist")
            //color?.setThemeColor(with: .blue)
        case 1:
            theme = .oceangreen
            themePlistName = "Theme_Green.plist"
            themePath =   Helper.getDocumentDirectory().appendingPathComponent("Theme_Green.plist")
            //color?.setThemeColor(with: .oceangreen)
        case 2:
            theme = .redfox
            themePlistName = "Theme_Red.plist"
            themePath =   Helper.getDocumentDirectory().appendingPathComponent("Theme_Red.plist")
           //color?.setThemeColor(with: .redfox)
        default:
            theme = .moonlight
            themePlistName = "Theme_Blue.plist"
            themePath =   Helper.getDocumentDirectory().appendingPathComponent("Theme_Dark.plist")
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
             score_80 = themeDict!["Score_80"] as? String
             score_30 = themeDict!["Score_30"] as? String
             score_30_80 = themeDict!["Score_30_80"] as? String
            
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
