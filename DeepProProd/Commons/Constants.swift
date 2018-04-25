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
        
        static let baseUrl = "http://192.168.71.10:10010/api/"
        static let userService = "aiuam/v1/"
        static let profile = baseUrl + userService + "users/%@"
        static let login = baseUrl + userService + "users/login"
        static let signUp = baseUrl + userService + "users/signup"
        static let forgotpassword = baseUrl + userService + "users/forget-password"
        static let refreshtoken = baseUrl + userService + "users/%@/token/refresh"

        static let grpcBaseUrl = "192.168.71.10:10007"

        //Assignment
        static let student = "students/"
        static let assignmentService = "assignment-service/v1/"
        static let assignments = baseUrl + assignmentService + "students/%@/assignments"
        static let units = baseUrl + assignmentService + "students/%@/assignments/%d/units"
        static let assignmentAnswer = baseUrl + assignmentService + "student/%@/assignment/%@/unit/%@/answers"
        
        //Practice
        static let category = baseUrl + assignmentService +  "categories"
        static let practice = baseUrl + assignmentService + "students/%@/practices"
        static let practiceunit = baseUrl + assignmentService + "practices/%d/units"
       
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
