//
//  Helper.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/10/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class Helper: NSObject {

    static func getDocumentDirectory() -> NSString
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        return documentsDirectory
    }
 
    static func copyFileFromBundle(to directory:() -> NSString, filename file:String , ofType type:String) {
        let path = directory().appendingPathComponent(String(format: "%@.%@",file, type))
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            
            guard let bundlePath = Bundle.main.path(forResource: file, ofType: type) else { return }
            
            do {
                try fileManager.copyItem(atPath: bundlePath, toPath: path)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    static func fileExist(at path:String) -> Bool
    {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
    
    static func readJsonFile(at path:String , ofType type:String)
    {
        guard Bundle.main.path(forResource: path, ofType: type) != nil
        else { return }
        
        do {
            if let file = Bundle.main.url(forResource: path, withExtension: type) {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                  //  print(object)
                   print(object["courses"])
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
        

    
    
    
}
