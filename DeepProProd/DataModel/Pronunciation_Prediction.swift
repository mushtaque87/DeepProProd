//
//  Pronunciation_Prediction.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/16/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class Pronunciation_Prediction: NSObject {

    var total_score: Float = 0.00
    var words_Result: Array<Word_Prediction>?
    
    override init() {
            words_Result = Array<Word_Prediction> ();
        }
}
