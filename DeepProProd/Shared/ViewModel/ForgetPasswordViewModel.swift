//
//  ForgetPasswordViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/14/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import RxSwift

class ForgetPasswordViewModel: NSObject,UITextFieldDelegate {

    var email = Variable<String>("")
    var password = Variable<String>("")
    var isValid : Observable<Bool> {

       return Observable.combineLatest(email.asObservable(),password.asObservable()) { email , password in
            email.count > 0 && email.contains("@") && email.contains(".com")
            
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
