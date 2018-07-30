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
    var dob: String?
   // let gender : Gender?
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

extension SignUpRequest {
func toJSON() -> [String: Any] {
    return [
        "email": email as Any,
        "first_name": first_name as Any,
        "last_name": last_name as Any,
        "password": password as Any,
        "user_attributes": user_attributes.toJSON() as Any
    ]
}
}

extension User_attributes {
    func toJSON() -> [String: Any] {
        return [
            "dob": dob as Any,
        ]
    }
}
