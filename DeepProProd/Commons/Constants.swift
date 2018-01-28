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
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        static let Tmp = NSTemporaryDirectory()
    }
}
