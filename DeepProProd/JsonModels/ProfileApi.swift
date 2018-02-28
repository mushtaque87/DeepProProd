//
//  ProfileDetails.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 2/13/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation

struct ProfileResponse: Codable {
    
    let name: String
    let age : String
    let gender : String
    let address : Int
    let contact : Int
}
