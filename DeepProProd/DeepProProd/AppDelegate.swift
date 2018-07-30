//
//  AppDelegate.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/8/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("didFinishLaunchingWithOptions")
        
        
        //Copy Files to Document Directory
        Helper.updateFileFromBundle(to: Helper.getDocumentDirectory, filename: "Settings", ofType: "plist")
        Helper.copyFileFromBundle(to: Helper.getDocumentDirectory, filename: "Theme_Blue", ofType: "plist")
        Helper.copyFileFromBundle(to: Helper.getDocumentDirectory, filename: "Theme_Green", ofType: "plist")
        Helper.copyFileFromBundle(to: Helper.getDocumentDirectory, filename: "Theme_Red", ofType: "plist")
        Helper.copyFileFromBundle(to: Helper.getDocumentDirectory, filename: "Theme_Dark", ofType: "plist")
        Helper.copyFileFromBundle(to: Helper.getDocumentDirectory, filename: "Arabic", ofType: "plist")
        Helper.copyFileFromBundle(to: Helper.getDocumentDirectory, filename: "English", ofType: "plist")
        Helper.createDirectory(with: "PracticeBoard")
        Helper.createDirectory(with: "Assignments")
        UITabBar.appearance().tintColor = UIColor.white

      //  Helper.readJsonFile(at: "LevelJson", ofType: "txt")
        
        /*do {
            try Helper.parseJson()
        } catch  {
            print(error)
        }*/
        return true
        
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
         print("applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      print("Current Date \(TokenManager.shared.currentDateTime())")
      //print("token_expire_date \(UserDefaults.standard.string(forKey: "token_expire_date")!)")
      
        /*
        #if DEBUG
            print("Debugging Mode")
        #else
             print("Production Mode")
        #endif
        
        
      
        if (ProcessInfo.processInfo.environment["TOKENEXPIRYTEST"] != nil) {
             print("Test")
        }
        else {
             print("Dont Test")
        }
        */
        guard UserDefaults.standard.string(forKey: "uid") != nil && UserDefaults.standard.string(forKey: "refresh_token") != nil else {
            print("First Login")
            return
        }
        
        ServiceManager().verifyTokenAndProceed(of: (UserDefaults.standard.string(forKey: "uid"))!, onSuccess: {
            //Do nothing.
        }, onError: { error in
            //Let the user know of the issue.
        })
        
       /* guard Settings.sharedInstance.firstLogIn == false &&
             TokenManager.sharedInstance.isRefreshTokenValid() == true else{
            if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
            {
               rootVc.showLoginViewController()
            }
            return
        }*/
    }
  
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    enum courseLevel : String, Codable {
        case Basic
        case Intermediate
        case Advanced
        // ...
    }
    
    struct Level: Codable {
        let levelname: courseLevel
    }
    
    struct LevelList : Codable {
        let courses: Dictionary<String,[Level]>
    }
    
    func parseJson() throws {
        let filePath = Bundle.main.url(forResource: "level", withExtension: "txt")
       
        let data: Data = try Data.init(contentsOf: filePath!)
       
        let decoder = JSONDecoder()
        let level = try! decoder.decode(LevelList.self, from: data)
        print(level)
    }

}

