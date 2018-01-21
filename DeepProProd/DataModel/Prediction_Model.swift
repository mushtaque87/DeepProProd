//
//  Prediction_Model.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/13/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class Prediction_Model: NSObject {

    var numPred: Int?
    var text : String?
    var key : String?
    var value: String?
    
     init(text: String , numPred: Int) {
        self.numPred = numPred
        self.text = text
    }
}
