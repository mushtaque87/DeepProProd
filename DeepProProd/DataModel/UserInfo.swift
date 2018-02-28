//
//  UserInfo.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 2/13/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import RxSwift

struct user {
    var username : String?
    var password : String?
    //var serverdetails: UserDetails?
    
}

class UserInfo: NSObject {

    static let shared = UserInfo()
    var userDetails: LoginResponse?
    
    //lazy private var accessToken = Variable<userDetails?.access_token>(UserDefaults.standard.string(forKey: "access_token")!)
    lazy open var accessToken = Variable(userDetails?.access_token)
    var accessTokenObserver:Observable<String?> {
        return accessToken.asObservable()
    }
    
 /*   lazy private var accessToken = Variable(userDetails)
    var accessTokenObserver:Observable<LoginResponse?> {
        return accessToken.asObservable()
    }
   */
    private init(with userdetails: LoginResponse? = nil) {
        self.userDetails = userdetails
        
    }
}

