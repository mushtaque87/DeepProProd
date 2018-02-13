//
//  UserInfo.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 2/13/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit


class UserInfo: NSObject {
    
    static let sharedInstance = UserInfo()
    var userDetails: UserDetails?
    private init(with userdetails: UserDetails? = nil) {
        self.userDetails = userdetails
        
    }
    
    
    
}
