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
        static let assignments = "http://192.168.71.10:10002/v1/" + "students/%@/assignments"
        static let units = "http://192.168.71.10:10002/v1/" + "students/%@/assignments/%d/units"
        static let assignmentAnswer = baseUrl + assignmentService + "students/%@/assignments/%d/units/%d/answers"
        static let updateAssignmentStatus = baseUrl + assignmentService + "students/%@/assignments/%d/status"
        
        //Practice
        static let category = "http://192.168.71.10:10002/v1/" +  "categories"
        static let practice = "http://192.168.71.10:10002/v1/" + "students/%@/practices?categoryId=%d"
        static let practiceunit = "http://192.168.71.10:10002/v1/" + "students/%@/practices/%d/units"
        static let practicesAnswer = baseUrl + assignmentService + "students/%@/practices/%d/units/%d/answers"

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
