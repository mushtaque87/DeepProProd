//
//  ForgetPasswordViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/14/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class ForgetPasswordViewModel: NSObject,UITextFieldDelegate {

    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
