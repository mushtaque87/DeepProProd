//
//  TokenManager.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 2/20/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import Alamofire



class TokenManager: NSObject {
    static let shared = TokenManager()
  
    
    typealias constant = Constants.ServerApi
    typealias BUILDSETTINGS = Constants.BUILDSETTINGS
    
    
        func storeNewToken(with userDetails:LoginResponse) {
            UserDefaults.standard.set(userDetails.uid, forKey:"uid");
            UserDefaults.standard.set(userDetails.refresh_token, forKey:"refresh_token");
            UserDefaults.standard.set(userDetails.access_token, forKey:"access_token");
            UserDefaults.standard.set(userDetails.refresh_expires_in, forKey:"refresh_expires_in");
            UserDefaults.standard.set(userDetails.expires_in, forKey:"expires_in");
            UserDefaults.standard.set(tokenExpiresAt(add: userDetails.expires_in!), forKey:"token_expire_date");
            UserDefaults.standard.set(refreshTokenExpiresAt(add: userDetails.refresh_expires_in!), forKey:"refreshtoken_expire_date");
        UserDefaults.standard.synchronize();
        //UserInfo.shared.userDetails = userDetails
        //UserInfo.shared.accessToken.value = userDetails.access_token
            
        }

    
    
        func currentDateTime() -> Date {
            let date = Date()
            let calendar = Calendar.current
            /* let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.calendar = Calendar.current
            dateFormatter.timeZone =  TimeZone.current
            dateFormatter.date
 */
            
       
            let currentdatetime = calendar.date(from: DateComponents(calendar: calendar , timeZone: TimeZone.current,  year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date), hour: calendar.component(.hour, from: date), minute: calendar.component(.minute, from: date), second: calendar.component(.second, from: date)))!
 
            
            
            
            return currentdatetime
            //return  Calendar.current.dateComponents(in: TimeZone.autoupdatingCurrent, from: Date())
        }
    
    func  tokenExpiresAt(add seconds:TimeInterval) -> String {
        
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .second, value: Int(seconds), to: currentDateTime())!
        return date.toString()
    }
    
    func  refreshTokenExpiresAt(add seconds:TimeInterval) -> String {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .second, value: Int(seconds), to: currentDateTime())!
        return date.toString()
    }
    
//    func convertDateToString(date:Date) -> String
//    {
//       return date.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
//    }
//
//    func convertStringToDate(date:String) -> Date
//    {
//        date.toDate()
//    }
//
    
    func isaccessTokenValid() -> Bool {
        
        if (BUILDSETTINGS.tokenTest != nil) {
            return false
        }
        
        guard UserDefaults.standard.string(forKey: "token_expire_date")  != nil else {
            return false
        }
        let accesTokenExpiryDate = UserDefaults.standard.string(forKey: "token_expire_date")
        let currentDate = currentDateTime()
        print("acess token expiry date :\(accesTokenExpiryDate!) \n currentDate:\(currentDate)")
        if(currentDate.compare((accesTokenExpiryDate?.toDate())!) == ComparisonResult.orderedAscending)
        {
            Helper.printLogs(with: "Access Token is Valid")
            return true
        }
        Helper.printLogs(with: "Access Token is InValid")
        return false
    }
    
    func isRefreshTokenValid() -> Bool {
        if (BUILDSETTINGS.refreshTokenTest != nil) {
            return false
        }
       
        let refreshTokenExpiryDate = UserDefaults.standard.string(forKey: "refreshtoken_expire_date")
        let currentDate = currentDateTime()
        if(currentDate.compare((refreshTokenExpiryDate?.toDate())!) == ComparisonResult.orderedAscending)
        {
             Helper.printLogs(with: "Refresh Token is Valid")
           return true
        }
        /*else if(currentDate.compare((refreshTokenExpiryDate?.toDate())!) == ComparisonResult.orderedDescending) {
             return false
        }*/
        Helper.printLogs(with: "Refresh Token is InValid")
        return false
    }

    
    //func getNewToken() -> LoginResponse
    //{
    //
    //}
    }
