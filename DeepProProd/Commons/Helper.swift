//
//  Helper.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/10/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import Alamofire


class Helper: NSObject {

    static func getDocumentDirectory() -> NSString
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        return documentsDirectory
    }
 
    static func copyFileFromBundle(to directory:() -> NSString, filename file:String , ofType type:String) {
        let path = directory().appendingPathComponent(String(format: "%@.%@",file, type))
        guard let bundlePath = Bundle.main.path(forResource: file, ofType: type) else { return }
        
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: path) {
            try fileManager.removeItem(atPath: path)
            }
            try fileManager.copyItem(atPath: bundlePath, toPath: path)
        } catch let error as NSError {
            print("Unable to carry out fileOperation . ERROR: \(error.localizedDescription)")
        }
    }
    
    static func updateFileFromBundle(to directory:() -> NSString, filename file:String , ofType type:String) {
        let path = directory().appendingPathComponent(String(format: "%@.%@",file, type))
        guard let bundlePath = Bundle.main.path(forResource: file, ofType: type) else { return }

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            do {
                try fileManager.copyItem(atPath: bundlePath, toPath: path)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
            }
        } else
        {
            Helper.updateFile(at:path, withFileFrom:bundlePath)
        }
    }

    static func fileExist(at path:String) -> Bool
    {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
    
    static func updateFile(at path:String , withFileFrom bundlepath:String) {
        
        let bundlefile:NSMutableDictionary = NSMutableDictionary(contentsOfFile: bundlepath)!
        let documentFile:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path)!

        for bundlekey in bundlefile.allKeys {
            var found = false
            for filekey in documentFile.allKeys {
                if bundlekey as! String == filekey as! String {
                    found = true
                    break
                }
            }
            if found {
                print("Yes: \(bundlekey)  , \(bundlefile.value(forKey:bundlekey as! String) )")
            } else {
                print("No: \(bundlekey)")
                Settings.sharedInstance.setValue(key: bundlekey as! String, value: bundlefile[bundlekey] as AnyObject)
            }
        }
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

static func createDirectory(with folderName:String)
{
    do{
        try FileManager.default.createDirectory(atPath: getDocumentDirectory().appendingPathComponent(String(format: "%@",folderName)), withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

    static func getAudioDirectory(for  type:TaskType) -> String
    {
        switch type {
        case .content:
            return getDocumentDirectory().appendingPathComponent("Assignments")
     
        default:
            return getDocumentDirectory().appendingPathComponent("PracticeBoard")

        }
    }
    
 static func parseLevelJson() throws -> LevelList  {
    let filePath = Bundle.main.url(forResource: "LevelJson", withExtension: "txt")
        
        let data: Data = try Data.init(contentsOf: filePath!)
        
        let decoder = JSONDecoder()
        let levels = try! decoder.decode(LevelList.self, from: data)
    
       // let levelsList  = levels
        print(levels)
    return levels
    }
    
    func scoreColor()
    {
    
    }
    
    /*
 static func getAssignmentList() throws -> Assignments  {
        let filePath = Bundle.main.url(forResource: "AssignmentList", withExtension: "txt")
        
        let data: Data = try Data.init(contentsOf: filePath!)
        
        let decoder = JSONDecoder()
        let assignments = try! decoder.decode(Assignments.self, from: data)
        
        // let levelsList  = levels
        print(assignments)
        return assignments
    }
    */
    // MARK: -  AutoRotion Codes
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
    //MARK: - HTTPError
    func handleHTTPError(from serverResponse: DataResponse<Data>)
    {
        
        var httpError: HTTPError?
        switch serverResponse.response!.statusCode {
        case 400 , 401 , 405 , 404:
            let decoder = JSONDecoder()
            httpError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
            //showInfoAlertScreen(with: httpError, oftype: "HTTPERROR")
        case 403 :
            let decoder = JSONDecoder()
            httpError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
            //self.showLoginScreen(with: (httpError?.description)!)
            
        default:
            //showInfoAlertScreen(with: "Server Problem", oftype: "INFO")
            break
        }
        
        print("Error \(String(describing: httpError))")
        // return httpError!
    }
    
}
