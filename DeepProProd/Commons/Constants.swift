//
//  Constants.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/21/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation

struct Constants {
    struct api {
        static let baseUrl = "https://ainfinity.dyndns.org"
        static let engPort = ":8500"
        static let speechApi = "/audio/predict"
    }
    
    struct ServerApi {
        static let baseUrl = "http://localhost:8777/v1/uam/users/"
        static let port = ":8080"
        static let login = "login"
        static let signUp = "signup"
        static let forgotpassword = "forget-password"
        
        static let refreshtoken = "/token/refresh"
    }
    
    struct BUILDSETTINGS {
        static let tokenTest = ProcessInfo.processInfo.environment["TOKENEXPIRYTEST"]
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        static let Tmp = NSTemporaryDirectory()
    }
}
