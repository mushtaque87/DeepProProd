//
//  TokenManager.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 2/20/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import PromiseKit
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
        UserDefaults.standard.set(tokenExpiresAt(add: userDetails.expires_in), forKey:"token_expire_date");
        UserDefaults.standard.set(refreshTokenExpiresAt(add: userDetails.refresh_expires_in), forKey:"refreshtoken_expire_date");
        UserDefaults.standard.synchronize();
        UserInfo.shared.userDetails = userDetails
        UserInfo.shared.accessToken.value = userDetails.access_token
            
        }

    
        func currentDateTime() -> Date {
            let date = Date()
    //        let calendar = Calendar.current
    //        let hour = calendar.component(.hour, from: date)
    //        let minutes = calendar.component(.minute, from: date)
            return date
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
        let accesTokenExpiryDate = UserDefaults.standard.string(forKey: "token_expire_date")
        let currentDate = currentDateTime()
        print("acess token expiry date :\(accesTokenExpiryDate!) \n currentDate:\(currentDate)")
       
        if (BUILDSETTINGS.tokenTest != nil) {
            return false
        }
        if(currentDate.compare((accesTokenExpiryDate?.toDate())!) == ComparisonResult.orderedAscending)
        {
            //FIXME: Change false to true for correct implementation
           
         
               return true
           
            
        }
        return false
    }
    
    func isRefreshTokenValid() -> Bool {
        let refreshTokenExpiryDate = UserDefaults.standard.string(forKey: "refreshtoken_expire_date")
        let currentDate = currentDateTime()
        if(currentDate.compare((refreshTokenExpiryDate?.toDate())!) == ComparisonResult.orderedAscending)
        {
           return true
        }
        /*else if(currentDate.compare((refreshTokenExpiryDate?.toDate())!) == ComparisonResult.orderedDescending) {
             return false
        }*/
        return false
    }

    
    //func getNewToken() -> LoginResponse
    //{
    //
    //}
    }
