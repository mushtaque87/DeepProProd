//
//  Constants.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/21/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation

struct Constants {
//    struct api {
//        static let baseUrl = "https://ainfinity.dyndns.org"
//        static let engPort = ":8500"
//        static let speechApi = "/audio/predict"
//    }
    
    struct ServerApi {

        //static let baseUrl = "http://ainfinity.dyndns.org:10010/v1"
       // static let baseUrl = BUILDSETTINGS.baseurl!
        static let baseUrl = "http://192.168.71.10:10010/api/"
        
        static let userService = "aiuam/v1/"
        static let profile = baseUrl + userService + "users/%@"
        static let login = baseUrl + userService + "users/login"
        static let signUp = baseUrl + userService + "users/signup"
        static let forgotpassword = baseUrl + userService + "users/forget-password"
        static let refreshtoken = baseUrl + userService + "users/%@/token/refresh"

        static let grpcBaseUrl =  "192.168.71.10:10007"
        //static let grpcBaseUrl =  "http://ainfinity.dyndns.org:10007"
        
        //Assignment
        static let student = "students/"
        static let assignmentService = "assignment-service/v1/"
        static let assignments = baseUrl + assignmentService + "students/%@/assignments"
        static let units = baseUrl + assignmentService + "students/%@/assignments/%d/units"
        static let assignmentAnswer = baseUrl + assignmentService + "students/%@/assignments/%d/units/%d/answers"
        static let updateAssignmentStatus = baseUrl + assignmentService + "students/%@/assignments/%d/status"
        
        //Practice
        static let category = baseUrl + assignmentService +  "categories"
        static let practice = baseUrl + assignmentService + "students/%@/practices?categoryId=%d"
        static let practiceunit = baseUrl + assignmentService + "students/%@/practices/%d/units"
        static let practicesAnswer = baseUrl + assignmentService + "students/%@/practices/%d/units/%d/answers"

        //Content
        static let contentService = "content-service/v1/"
        static let content  = baseUrl + contentService + "students/%@/contents"
        static let rootContent  = baseUrl + contentService + "students/%@/contents?is_assignment=%@"
        static let contentGroup  = baseUrl + contentService + "students/%@/contents/%d"
        static let contentUnit  = baseUrl  + contentService + "students/%@/contents/%d/units"
        static let unitAnswers  = baseUrl  + contentService + "students/%@/units/%d/answers"

        //http://192.168.71.11:8091/contents/4/units
        // GRPC

    }
    
    struct BUILDSETTINGS {
        static let tokenTest = ProcessInfo.processInfo.environment["TOKENEXPIRYTEST"]
        static let refreshTokenTest = ProcessInfo.processInfo.environment["REFRESHTOKENEXPIRYTEST"]
        static let grpcTest = ProcessInfo.processInfo.environment["GRPCON"]
        static let baseurl = ProcessInfo.processInfo.environment["BASEURL"]
        static let grpcbaseurl = ProcessInfo.processInfo.environment["GRPCBASEURL"]
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        static let Tmp = NSTemporaryDirectory()
    }
}
