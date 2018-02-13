//
//  UserDetails.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 2/7/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation

struct UserDetails: Codable {
    
    let uid: String
    let auth_token : String
    let refresh_token : String
    let expires_in : Int
    let refresh_expires_in : Int
}

