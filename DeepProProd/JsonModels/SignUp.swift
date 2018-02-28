//
//  SignUp.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 2/19/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation

// MARK: - Signup Request
struct SignUpRequest: Codable {
    
    let email: String
    let first_name : String
    let last_name : String
    let password : String
    let user_attributes : User_attributes
    
    
}

struct User_attributes : Codable{
    let dob: String
    let gender : Gender
}

enum Gender : String, Codable {
    case Male
    case Female
    // ...
}

// MARK: - Signup Response
struct SignUpResponse : Codable {
    let uid: String
    
}
