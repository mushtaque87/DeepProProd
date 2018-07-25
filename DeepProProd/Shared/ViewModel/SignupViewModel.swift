//
//  SignupViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/14/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import RxSwift

enum SignUpDetails : Int  {
    case firstName
    case lastName
    case email
    case password
    case confirmPassword
    case dob
    case gender
    case contact
    case logout
    case standard
    case section
    
}


class SignupViewModel: NSObject,UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource  {

    var currentTextField: UITextField?
    lazy  var dob = Variable("")
    lazy var details = SignUpData()
    var isEditEnabled : Bool = true
    weak var delegate : SignUpViewDelegate?
    
    var dobObserver:Observable<String> {
        return dob.asObservable()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if let detailtype = SignUpDetails(rawValue: indexPath.row) {
            
            switch detailtype {
            case .firstName:
                 let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                 
                 cell.valueTextField.text = details.firstname
                 cell.titleLabel.text = "First Name"
                 cell.valueTextField.tag = detailtype.rawValue
                 cell.selectionStyle = .none
                 configureCells(for: cell)
                 return cell
            case .lastName:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.valueTextField.text = details.lastname
                cell.titleLabel.text = "Last Name"
                /*
                cell.valueTextField.isEnabled = isEditEnabled
                cell.valueTextField.delegate = self
                cell.valueTextField.autocorrectionType = .no
                cell.valueTextField.tag = detailtype.rawValue
                //cell.valueTextField.text = ""
                
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.titleLabel.backgroundColor = UIColor.clear
                */
                cell.selectionStyle = .none
                cell.valueTextField.tag = detailtype.rawValue
                configureCells(for: cell)
                return cell
            case .email:
               let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.titleLabel.text = "Email"
                cell.valueTextField.text = details.email
                /*
                cell.valueTextField.isEnabled = isEditEnabled
                cell.valueTextField.delegate = self
                cell.valueTextField.autocorrectionType = .no
                cell.valueTextField.tag = detailtype.rawValue
                //cell.valueTextField.text = ""
                
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.titleLabel.backgroundColor = UIColor.clear
                */
               cell.selectionStyle = .none
               cell.valueTextField.tag = detailtype.rawValue
               configureCells(for: cell)
               return cell
            case .password:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.titleLabel.text = "Password"
                cell.valueTextField.text = details.password
                
                /*
                cell.valueTextField.isEnabled = isEditEnabled
                cell.valueTextField.delegate = self
                cell.valueTextField.autocorrectionType = .no
                cell.valueTextField.tag = detailtype.rawValue
                //cell.valueTextField.text = ""
                
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.titleLabel.backgroundColor = UIColor.clear
                */
                cell.selectionStyle = .none
                cell.valueTextField.tag = detailtype.rawValue
                configureCells(for: cell)
                return cell
            case .confirmPassword:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.titleLabel.text = "Confirm Password"
                cell.valueTextField.text = details.confirmpassword
                /*
                cell.valueTextField.isEnabled = isEditEnabled
                cell.valueTextField.delegate = self
                cell.valueTextField.autocorrectionType = .no
                cell.valueTextField.tag = detailtype.rawValue
                //cell.valueTextField.text = ""
                
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.titleLabel.backgroundColor = UIColor.clear */
                cell.selectionStyle = .none
                cell.valueTextField.tag = detailtype.rawValue
                configureCells(for: cell)
                return cell
            case .dob:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.titleLabel.text = "Date of Birth"
                cell.valueTextField.text = details.dob
                // let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                /*
                cell.valueTextField.isEnabled = isEditEnabled
                cell.valueTextField.delegate = self
                cell.valueTextField.autocorrectionType = .no
                cell.valueTextField.tag = detailtype.rawValue
                if let dob = details?.user_attributes?.dob {
                    cell.valueTextField.text = dob
                }
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.titleLabel.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
 */
                //return cell
                cell.selectionStyle = .none
                cell.valueTextField.tag = detailtype.rawValue
                configureCells(for: cell)
                return cell
            case .gender:
                //let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.titleLabel.text = "Gender"
                cell.valueTextField.text = details.gender
                cell.valueTextField.isEnabled = false
                /*
                cell.valueTextField.isEnabled = isEditEnabled
                cell.valueTextField.delegate = self
                cell.valueTextField.autocorrectionType = .no
                cell.valueTextField.tag = detailtype.rawValue
                cell.valueTextField.text = "Male"
                
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.titleLabel.backgroundColor = UIColor.clear */
                //return cell
                cell.selectionStyle = .none
                cell.valueTextField.tag = detailtype.rawValue
                configureCells(for: cell)
                cell.valueTextField.isEnabled = false
                return cell
            case .standard:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                // let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.titleLabel.text = "Class"
                cell.valueTextField.text = details.standard
                cell.valueTextField.isEnabled = false
                /*
                cell.valueTextField.isEnabled = isEditEnabled
                cell.valueTextField.delegate = self
                cell.valueTextField.autocorrectionType = .no
                cell.valueTextField.tag = detailtype.rawValue
                cell.valueTextField.text = "3"
                
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.titleLabel.backgroundColor = UIColor.clear */
                //return cell
                cell.selectionStyle = .none
                cell.valueTextField.tag = detailtype.rawValue
                configureCells(for: cell)
                return cell
            case .section:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                // let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.titleLabel.text = "Section"
                cell.valueTextField.text = details.section
                cell.valueTextField.isEnabled = false
                /*
                cell.valueTextField.isEnabled = isEditEnabled
                cell.valueTextField.delegate = self
                cell.valueTextField.autocorrectionType = .no
                cell.valueTextField.tag = detailtype.rawValue
                cell.valueTextField.text = "A"
                
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.titleLabel.backgroundColor = UIColor.clear */
               // return cell
                cell.selectionStyle = .none
                cell.valueTextField.tag = detailtype.rawValue
                configureCells(for: cell)
                return cell
            case .contact:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                // let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.titleLabel.text = "Contact"
                cell.valueTextField.text = details.contact
                /*
                cell.valueTextField.isEnabled = isEditEnabled
                cell.valueTextField.delegate = self
                cell.valueTextField.autocorrectionType = .no
                cell.valueTextField.tag = detailtype.rawValue
                cell.valueTextField.text = "9886820824"
                cell.titleLabel.text = "Contact"
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.titleLabel.backgroundColor = UIColor.clear */
                //return cell
                cell.selectionStyle = .none
                cell.valueTextField.tag = detailtype.rawValue
                configureCells(for: cell)
                return cell
            case .logout:
                let sumbitCell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
                sumbitCell.titleLbl.textAlignment = .center
                sumbitCell.titleLbl.text = "Sumbit"
                sumbitCell.titleLbl.textColor = UIColor.white
                sumbitCell.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                return sumbitCell
            
            }
            
        }
       
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
        // cell.tintColor = UIColor.clear
        
        if indexPath.row == SignUpDetails.logout.rawValue {
            delegate?.signUp()
        } else if indexPath.row == SignUpDetails.gender.rawValue {
            delegate?.showEditInfoScreen(for: .gender)
        }
        else if indexPath.row == SignUpDetails.standard.rawValue {
            delegate?.showEditInfoScreen(for: .standard)
        }
        else if indexPath.row == SignUpDetails.section.rawValue {
            delegate?.showEditInfoScreen(for: .section)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func configureCells(for cell:DetailCell) {
        cell.valueTextField.isEnabled = isEditEnabled
        cell.valueTextField.delegate = self
        cell.valueTextField.autocorrectionType = .no
        //cell.valueTextField.placeholder = "Enter here"
        cell.valueTextField.tintColor = UIColor.white
        cell.titleLabel.textAlignment = .left
        cell.titleLabel.backgroundColor = UIColor.clear
        cell.titleLabel.textColor = UIColor.white
        cell.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        cell.backView.backgroundColor = UIColor.clear
    }
    
    
    func createSignUpBody(firstname:String , lastname:String, email:String , password:String , dob:String , gender: String) -> SignUpRequest
    {
        return SignUpRequest(email: email,
                             first_name: firstname, last_name: lastname,
                             password: password, user_attributes:User_attributes(dob: dob))
    }
    
    
    // MARK: - TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        if(textField.tag == SignUpDetails.dob.rawValue){

            
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
                                        self.details.dob = formatter.string(from: dt)
                                        textField.text = self.details.dob
                                    }
                }
            
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        //currentTextField?.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setData(from: textField)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func setData(from textField:UITextField) {
        
        if let detailtype = SignUpDetails(rawValue: textField.tag) {
            switch detailtype {
            case .firstName:
                //cell.valueTextField.placeholder = "Male"
                details.firstname = textField.text
                break
            case .lastName:
                details.lastname = textField.text
                break
            case .email:
                details.email = textField.text
                break
            case .password:
                details.password = textField.text
                break
            case .confirmPassword:
                 details.confirmpassword = textField.text
                break
            case .dob:
                details.dob = textField.text!
                break
            case .gender:
                details.gender = textField.text!
                break
            case .standard:
                details.standard = textField.text!
                break
            case .section:
                details.section = textField.text!
                break
            case .contact:
                details.contact = textField.text!
                break
            case .logout:
                break
            }
        }
    }
    
}
