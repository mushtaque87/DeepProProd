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

        //static let baseUrl = "http://192.168.32.24:8777/v1"
        
        static let baseUrl = "http://192.168.71.10:10000/v1/"
        
        static let profile = baseUrl + "users/%s"
        static let login = baseUrl + "users/login"
        static let signUp = baseUrl + "users/signup"
        static let forgotpassword = baseUrl + "users/forget-password"
        static let refreshtoken = baseUrl + "users/%s/token/refresh"

        static let grpcBaseUrl = "192.168.71.10:10007"

        
        static let student = "students/"
        static let assignments = "students/%@/assignments"
        static let units = "assignments/%@/units"
        static let answer = "student/%s/assignment/%@/unit/%@/answers"
        
        
        // GRPC

    }
    
    struct BUILDSETTINGS {
        static let tokenTest = ProcessInfo.processInfo.environment["TOKENEXPIRYTEST"]
        static let grpcTest = ProcessInfo.processInfo.environment["GRPCON"]
        
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        static let Tmp = NSTemporaryDirectory()
    }
}
