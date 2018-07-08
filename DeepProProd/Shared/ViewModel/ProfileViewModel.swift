//
//  ProfileViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/3/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import UIKit

enum DetailType : Int  {
    case dob
    case gender
    case standard
    case section
    case contact
}



class ProfileViewModel: NSObject, UITableViewDelegate , UITableViewDataSource,  UITextFieldDelegate {
   
    var details : Profile?
    var isEditEnabled : Bool = false
    weak var delegate: ProfileViewDelegate? 
    var isKeyboardOnScreen : Bool = false
    var currentTextField : UITextField?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let detailtype = DetailType(rawValue: indexPath.row) {
            switch detailtype {
                case .dob:
                        let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                        cell.valueTextField.isEnabled = isEditEnabled
                        cell.titleLabel.text = "Date of Birth"
                        cell.valueTextField.delegate = self
                        cell.valueTextField.autocorrectionType = .no
                        cell.valueTextField.tag = indexPath.row
                        if let dob = details?.user_attributes?.dob {
                            cell.valueTextField.text = dob
                        }
                        cell.titleLabel.textColor = UIColor.white
                        cell.titleLabel.textAlignment = .left
                        cell.backgroundColor = UIColor.clear
                        cell.titleLabel.backgroundColor = UIColor.clear
                        cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                        return cell
                case .gender:
                        let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                        cell.valueTextField.isEnabled = isEditEnabled
                        cell.valueTextField.delegate = self
                        cell.valueTextField.autocorrectionType = .no
                         cell.valueTextField.tag = indexPath.row
                        cell.valueTextField.text = "Male"
                        cell.titleLabel.text = "Gender"
                        cell.titleLabel.textColor = UIColor.white
                        cell.titleLabel.textAlignment = .left
                        cell.backgroundColor = UIColor.clear
                        cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                        cell.titleLabel.backgroundColor = UIColor.clear
                        return cell
            case .standard:
                        let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                        cell.valueTextField.isEnabled = isEditEnabled
                        cell.valueTextField.delegate = self
                        cell.valueTextField.autocorrectionType = .no
                         cell.valueTextField.tag = indexPath.row
                        cell.valueTextField.text = "3"
                        cell.titleLabel.text = "Class"
                        cell.titleLabel.textColor = UIColor.white
                        cell.titleLabel.textAlignment = .left
                        cell.backgroundColor = UIColor.clear
                        cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                        cell.titleLabel.backgroundColor = UIColor.clear
                        return cell
            case .section:
                        let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                        cell.valueTextField.isEnabled = isEditEnabled
                        cell.valueTextField.delegate = self
                        cell.valueTextField.autocorrectionType = .no
                         cell.valueTextField.tag = indexPath.row
                        cell.valueTextField.text = "A"
                        cell.titleLabel.text = "Section"
                        cell.titleLabel.textColor = UIColor.white
                        cell.titleLabel.textAlignment = .left
                        cell.backgroundColor = UIColor.clear
                        cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                        cell.titleLabel.backgroundColor = UIColor.clear
                        return cell
            case .contact:
                        let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                        cell.valueTextField.isEnabled = isEditEnabled
                        cell.valueTextField.delegate = self
                        cell.valueTextField.autocorrectionType = .no
                         cell.valueTextField.tag = indexPath.row
                        cell.valueTextField.text = "9886820824"
                        cell.titleLabel.text = "Contact"
                        cell.titleLabel.textColor = UIColor.white
                        cell.titleLabel.textAlignment = .left
                        cell.backgroundColor = UIColor.clear
                        cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                        cell.titleLabel.backgroundColor = UIColor.clear
                        return cell
            }
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func controlKeyboard (sender:UITapGestureRecognizer){
        guard sender.numberOfTapsRequired == 1 else {
            return
        }
        if((currentTextField != nil) && (currentTextField?.isFirstResponder)!) {
            currentTextField?.resignFirstResponder()
        } else {
            currentTextField?.becomeFirstResponder()
        }
    }
    
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
       
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        
        if textField.tag == 0 {
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
                                    textField.text = formatter.string(from: dt)
                                    self.details?.user_attributes?.dob = formatter.string(from: dt)
                                }
            }
            return false
        } else if (textField.tag == 100) || (textField.tag == 101){
            return true
        }
        else {
            if (isKeyboardOnScreen == false) {
            //delegate?.moveTextField(up: true)
            }
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        if (isKeyboardOnScreen == true) {
            //delegate?.moveTextField(up: false)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if (isKeyboardOnScreen == true) {
           // delegate?.moveTextField(up: false)
        }
       
        textField.resignFirstResponder()
        return true
    }
}
