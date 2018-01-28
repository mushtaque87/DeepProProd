//
//  Settings.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/27/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class Settings: NSObject {
    
    var language : String?
    var firstLogIn : Bool?
    var isLoggedIn : Bool?
    var isDemo : Bool?
    var mainPage : Int?
    var graphType : Int?
    var themeType : Int?
    static let sharedInstance = Settings()
    var settingsDict : NSMutableDictionary?
    private var settingsPath : String?
    
    private override  init()  {
        settingsDict  = NSMutableDictionary();
        settingsPath = Helper.getDocumentDirectory().appendingPathComponent("Settings.plist")
       // Helper.copyFileFromBundle(to: Helper.getDocumentDirectory, filename: "Settings", ofType: "plist")
        super.init()
        reloadSettingsDictionary()
        
    }
    
    func reloadSettingsDictionary()
    {
        if let path = settingsPath {
        settingsDict = NSMutableDictionary(contentsOfFile: path)
        language = settingsDict!["Language"] as? String
        firstLogIn = settingsDict!["FirstLogin"] as? Bool
        isLoggedIn = settingsDict!["isLoggedIn"] as? Bool
        isDemo = settingsDict!["isDemo"] as? Bool
        mainPage = settingsDict!["mainPage"] as? Int
        graphType = settingsDict!["GraphType"] as? Int
        print("Saved GameData.plist file is --> \(settingsDict?.description ?? "")")
        }
        else{
            Helper.updateFileFromBundle(to: Helper.getDocumentDirectory, filename: "Settings", ofType: "plist")
            reloadSettingsDictionary()
        }
    }
    
    func setValue(key:String , value:AnyObject) -> Void {
        
        let path = Helper.getDocumentDirectory().appendingPathComponent("Settings.plist")
        let info:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path)!
        //saving values
        info.setValue(value, forKey: key)
        //writing to Setting.plist
        info.write(toFile: path, atomically: true)
        reloadSettingsDictionary()
       // let resultDictionary = NSMutableDictionary(contentsOfFile: path)
       // print("Saved GameData.plist file is --> \(resultDictionary?.description ?? "")")

    }
        
}


