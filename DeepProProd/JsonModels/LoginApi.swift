//
//  UserDetails.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 2/7/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    let uid: String
    let access_token : String
    let refresh_token : String
    let expires_in : TimeInterval
    let refresh_expires_in : TimeInterval
}

