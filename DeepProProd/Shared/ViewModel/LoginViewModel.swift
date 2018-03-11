//
//  LoginViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/9/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject, UITextFieldDelegate {


    func switchValueChanged(_ sender: UISwitch) {
        if(sender.isOn)
        {
            Settings.sharedInstance.language = "Arabic"
            Settings.sharedInstance.setValue(key: "Language", value: "Arabic" as AnyObject)
        }
        else
        {
            Settings.sharedInstance.language = "English"
            Settings.sharedInstance.setValue(key: "Language", value: "English" as AnyObject)
        }
    }
    
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
