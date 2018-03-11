//
//  UserDetails.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 2/7/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    var uid: String
    var access_token : String
    var refresh_token : String
    var expires_in : TimeInterval
    var refresh_expires_in : TimeInterval
}

