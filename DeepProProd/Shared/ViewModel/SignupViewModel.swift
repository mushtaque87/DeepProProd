//
//  SignupViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/14/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import RxSwift

class SignupViewModel: NSObject,UITextFieldDelegate {

    
   lazy  var dob = Variable("")
    var dobObserver:Observable<String> {
        return dob.asObservable()
    }
    
    func createSignUpBody(firstname:String , lastname:String, email:String , password:String , age:String , dob:String , gender: Int) -> SignUpRequest
    {
        return SignUpRequest(email: email,
                             first_name: firstname, last_name: lastname,
                             password: password, user_attributes:User_attributes(dob: dob))
    }
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
        if(textField.tag == 6){
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = 100
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .black,
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        datePicker.show("Date of Birth",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: threeMonthAgo,
                        maximumDate: currentDate,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd-MM-YYYY"
                                self.dob.value = formatter.string(from: dt)
                            }
        }
        }
    
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
