//
//  ProfileViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/3/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import RxSwift

enum DetailType : Int  {
    case email
    case dob
    case gender
    case standard
    case section
    case contact
}

enum InfoType : Int  {
    case firstName
    case lastName
    
}

enum ScreenType : Int  {
    case signUp
    case edit
}



class ProfileViewModel: NSObject, UITableViewDelegate , UITableViewDataSource,  UITextFieldDelegate {
   
    var details : Profile?
    var isEditEnabled : Bool = false
    weak var delegate: ProfileViewDelegate? 
    var isKeyboardOnScreen : Bool = false
    var currentTextField : UITextField?
    var screenType : ScreenType = .edit
    var isEdited = Variable<Bool>(false)
//    var isEnable : Observable<Bool> {
//        return Observable.subscribeOn(isEdited.value)
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        let title = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height))
//        title.textColor = UIColor.black
//        if (section == 0){
//            title.text = "Profile Information"
//        } else {
//            title.text = "Detail Information"
//        }
//
//        headerView.addSubview(title)
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
                        return "Profile Information"
                    } else {
                        return "Detail Information"
                    }
    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 1
        } else {
            return 8
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0 :
                let cell  = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! InfoTableViewCell
                
                cell.firstName.text = details?.first_name
                cell.lastName.text = details?.last_name
//                cell.firstName.isUserInteractionEnabled = false
//                cell.lastName.isUserInteractionEnabled = false
                cell.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.contentView.backgroundColor = UIColor.clear
                cell.profileImageButton.addTarget(self , action: #selector(editProfilePic), for: .touchUpInside)
                cell.profileImageButton.setImage(details?.profile_image, for: .normal)
                return cell
            default:
               break
            }
        default:
        if let detailtype = DetailType(rawValue: indexPath.row) {
           let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
            switch detailtype {
                case .email:
                        cell.valueTextField.isEnabled = isEditEnabled
                        cell.valueTextField.textColor = UIColor.white
                        cell.valueTextField.delegate = self
                        cell.valueTextField.autocorrectionType = .no
                        cell.valueTextField.tag = indexPath.row
                        cell.valueTextField.text = details?.email
                        cell.titleLabel.text = "Email"
                        cell.titleLabel.textColor = UIColor.white
                        cell.titleLabel.textAlignment = .left
                        cell.backgroundColor = UIColor.clear
                        cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                        cell.titleLabel.backgroundColor = UIColor.clear
                        cell.selectionStyle = .none
                        return cell
                case .dob:
                       // let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
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
                        cell.selectionStyle = .none
                        return cell
                case .gender:
                        //let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                        cell.valueTextField.isEnabled = isEditEnabled
                        cell.valueTextField.delegate = self
                        cell.valueTextField.autocorrectionType = .no
                        cell.valueTextField.tag = indexPath.row
                        if let gender = details?.gender{
                            cell.valueTextField.text = gender
                        }
                        cell.titleLabel.text = "Gender"
                        cell.titleLabel.textColor = UIColor.white
                        cell.titleLabel.textAlignment = .left
                        cell.backgroundColor = UIColor.clear
                        cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                        cell.titleLabel.backgroundColor = UIColor.clear
                        
                        return cell
            case .standard:
                       // let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                        cell.valueTextField.isEnabled = isEditEnabled
                        cell.valueTextField.delegate = self
                        cell.valueTextField.autocorrectionType = .no
                         cell.valueTextField.tag = indexPath.row
                        if let standard = details?.standard{
                            cell.valueTextField.text = standard
                        }
                        cell.titleLabel.text = "Class"
                        cell.titleLabel.textColor = UIColor.white
                        cell.titleLabel.textAlignment = .left
                        cell.backgroundColor = UIColor.clear
                        cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                        cell.titleLabel.backgroundColor = UIColor.clear
                        
                        return cell
            case .section:
                        // let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                        cell.valueTextField.isEnabled = isEditEnabled
                        cell.valueTextField.delegate = self
                        cell.valueTextField.autocorrectionType = .no
                         cell.valueTextField.tag = indexPath.row
                        cell.valueTextField.text = details?.section
                        cell.titleLabel.text = "Section"
                        cell.titleLabel.textColor = UIColor.white
                        cell.titleLabel.textAlignment = .left
                        cell.backgroundColor = UIColor.clear
                        cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                        cell.titleLabel.backgroundColor = UIColor.clear
                        
                        return cell
            case .contact:
                       // let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                        cell.valueTextField.isEnabled = isEditEnabled
                        cell.valueTextField.delegate = self
                        cell.valueTextField.autocorrectionType = .no
                         cell.valueTextField.tag = indexPath.row
                        cell.valueTextField.text = details?.contact
                        cell.titleLabel.text = "Contact"
                        cell.titleLabel.textColor = UIColor.white
                        cell.titleLabel.textAlignment = .left
                        cell.backgroundColor = UIColor.clear
                        cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                        cell.titleLabel.backgroundColor = UIColor.clear
                        
                        return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 100.0
        } else {
            return 70.0
        }
        
    }
 
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        if indexPath.section == 0 {
//            delegate?.showEditNameScreen()
//        } else {
//            if indexPath.row == 2 {
//                delegate?.showEditGenderScreen()
//            }
//        }
//    }
//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.section == 0 {
                        delegate?.showEditInfoScreen(for: .name)
                    } else {
            if indexPath.row == 1 {
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
                                        let cell  = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))! as! DetailCell

                                        cell.valueTextField.text = formatter.string(from: dt)
                                        self.details?.user_attributes?.dob = formatter.string(from: dt)
                                    }
                }
            }
            else if indexPath.row == 2 {
                            delegate?.showEditInfoScreen(for: .gender)
                        }
            else if indexPath.row == 3 {
                            delegate?.showEditInfoScreen(for: .standard)
                    }
            else if indexPath.row == 4 {
                            delegate?.showEditInfoScreen(for: .section)
            }
            else if indexPath.row == 5 {
                delegate?.showEditInfoScreen(for: .contact)
            }
                }
    }
    
    
    @objc func editProfilePic() {
        delegate?.editProfilePic()
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
        delegate?.shouldEnableSaveButton(enable: true)
        if textField.tag == 1 {
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
        } else if (textField.tag == 0){
            return false
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
