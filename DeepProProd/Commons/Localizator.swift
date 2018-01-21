//
//  Localizator.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/9/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import UIKit

public class Localizator {
    
    static let sharedInstance = Localizator()
    
    lazy var localizableDictionary: NSDictionary! = {
        if (Helper.fileExist(at: (Helper.getDocumentDirectory().appendingPathComponent(String(format: "%@.%@",Settings.sharedInstance.language!,"plist")))))
         {
            return NSDictionary(contentsOfFile: (Helper.getDocumentDirectory().appendingPathComponent(String(format: "%@.%@",Settings.sharedInstance.language!,"plist"))))
        }
        fatalError("Localizable file NOT found")
    }()
    
    
    func reloadLocalisationDictionary()
    {
          localizableDictionary =  NSDictionary(contentsOfFile: (Helper.getDocumentDirectory().appendingPathComponent(String(format: "%@.%@",Settings.sharedInstance.language!,"plist"))))
    }
    
    func localize(text: String) -> String {
        guard let localizedString = (localizableDictionary.value(forKey: text) as? NSDictionary)?.value(forKey: "value") as? String else {
            //assertionFailure("Missing translation for: \(text)")
            return ""
        }
        return localizedString
    }
    
    
}

extension String {
    var localized: String {
        return Localizator.sharedInstance.localize(text: self)
    }
}


