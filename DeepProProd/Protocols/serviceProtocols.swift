//
//  serviceProtocols.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/21/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import Alamofire

protocol ServiceProtocols: class {
    func returnPredictionValue(response : DataResponse<Any>)
}