//
//  ProfileSelectionTableViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/12/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

enum EditProfileType : Int  {
    case name = 0
    case gender = 2
    case standard = 3
    case contact = 4
    case address = 5
}

enum EditProfileScreenType : Int  {
    case profile
    case signUp
   
}

class ProfileSelectionTableViewController: UITableViewController, UITextFieldDelegate {
    var editProfileType : EditProfileType?
    var editProfileScreenType : EditProfileScreenType = .profile
    weak var delegate: ProfileViewDelegate?
    weak var signUpDelegate: SignUpViewDelegate?
    
    var details : Profile?
    var signUpDetails : SignUpData?
    var profileTypeDetails = ["Gender":["Male" ,"Female"],"Standard":["1","2","3","4","5","6","7","8","9"],"Section":["A","B","C","D"]]
    
    //MARK:- View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem =varlf.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveDetails(_:)))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        self.tableView.register(UINib(nibName: "NameTableViewCell", bundle: nil), forCellReuseIdentifier: "nameCell")
        self.tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "labelCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let editProfileType = self.editProfileType {
            switch editProfileType {
            case .name:
                return "Enter First and Last Name"
            case .gender:
                return "Select Gender"
            case .standard:
                return "Select Class"
            case .contact:
                return "Enter Phone number"
            case .address:
                return "Enter Address"
            }
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if let editProfileType = self.editProfileType {
            switch editProfileType {
            case .name:
                return 60
            case .gender:
                return 50
            case .standard:
                return 50
            case .contact:
                return 60
            case .address:
                return 50
                }
        }
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let editProfileType = self.editProfileType {
            switch editProfileType {
            case .name:
               return 2
            case .gender:
                return profileTypeDetails["Gender"]!.count
            case .standard:
                return  profileTypeDetails["Standard"]!.count
            case .contact:
                return 1
            case .address:
                return 1
            }
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        if let editProfileType = self.editProfileType {
            switch editProfileType {
            case .name:
                let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameTableViewCell
                if(indexPath.row == 0) {
                cell.textFieldOne.becomeFirstResponder()
                }
                cell.textFieldOne.tag = indexPath.row
                cell.textFieldOne.delegate = self
                cell.textFieldOne.placeholder = (indexPath.row == 0 ? "First Name" : "Last Name")
                cell.textFieldOne.text = (indexPath.row == 0 ? details?.first_name : details?.last_name)
                cell.selectionStyle = .none
                configureCells(for: cell)
                return cell
            case .gender:
                let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
                cell.titleLbl.text = profileTypeDetails["Gender"]?[indexPath.row]
                //cell.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.contentView.backgroundColor = UIColor.clear
                cell.tintColor = UIColor.white
                cell.selectionStyle = .none
                if(cell.titleLbl.text == details?.user_attributes?.gender){
                    cell.accessoryType = .checkmark
                }
                configureCells(for: cell)
                return cell
              
            case .standard:
                let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
                cell.titleLbl.text = profileTypeDetails["Standard"]?[indexPath.row]
                //cell.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.tintColor = UIColor.white
                cell.contentView.backgroundColor = UIColor.clear
                if(cell.titleLbl.text == details?.user_attributes?.class_code){
                    cell.accessoryType = .checkmark
                }
                cell.selectionStyle = .none
                configureCells(for: cell)
                return cell
                
            case .contact:
                let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameTableViewCell
                cell.textFieldOne.tag = indexPath.row
                cell.textFieldOne.delegate = self
                cell.textFieldOne.text = details?.user_attributes?.phone
                cell.textFieldOne.becomeFirstResponder()
               cell.selectionStyle = .none
                configureCells(for: cell)
                return cell
                
            case .address:
                let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameTableViewCell
                cell.textFieldOne.tag = indexPath.row
                cell.textFieldOne.text = details?.user_attributes?.address
                cell.textFieldOne.delegate = self
                cell.textFieldOne.becomeFirstResponder()
                cell.selectionStyle = .none
                configureCells(for: cell)
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
   

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if let editProfileType = self.editProfileType {
            switch editProfileType {
            case .name: break
            case .gender :
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                deselectOtherRows(except: indexPath.row)
                details?.user_attributes?.gender = profileTypeDetails["Gender"]?[indexPath.row]
                signUpDetails?.gender  = profileTypeDetails["Gender"]?[indexPath.row]
            case .standard:
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                deselectOtherRows(except: indexPath.row)
                details?.user_attributes?.class_code = profileTypeDetails["Standard"]?[indexPath.row]
                signUpDetails?.standard = profileTypeDetails["Standard"]?[indexPath.row]
            case .contact: break
            case .address:break
//                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//                deselectOtherRows(except: indexPath.row)
//                details?.user_attributes?.class_code = profileTypeDetails["Section"]?[indexPath.row]
//                signUpDetails?.section =  profileTypeDetails["Section"]?[indexPath.row]
            }
        }
    }
    
    func deselectOtherRows (except selectedRow : Int) {
        for row in 0...(tableView.numberOfRows(inSection: 0) - 1) {
            if row != selectedRow {
                let cell:UITableViewCell = tableView.cellForRow(at: IndexPath(row: row, section: 0))!
                cell.accessoryType = .none
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:- UI Events and Actions
    func updateDetails(from textField:UITextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if let editProfileType = self.editProfileType {
            switch editProfileType {
            case .name:
                if(textField.tag == 0 ){
                    details?.first_name = textField.text
                } else {
                    details?.last_name = textField.text
                }
            case .gender:
                break
            case .standard:
                break
            case .contact:
                if(textField.tag == 0 ){
                    details?.user_attributes?.phone = textField.text
                }
                break
            case .address:
                details?.user_attributes?.address = textField.text
                break
            }
        }
    }
    
    func configureCells(for cell:AnyObject) {
        
        if let cell = cell as? UITableViewCell {
            cell.textLabel?.textColor = UIColor.black
            cell.tintColor = UIColor.black
                //UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.font_Color!)
            cell.textLabel?.font = UIFont(name: ThemeManager.sharedInstance.font_Regular!, size:CGFloat(ThemeManager.sharedInstance.fontSize_Medium!) )
        cell.backgroundColor = UIColor.white
            // UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)
        }
        if  let cell = cell as? NameTableViewCell
        {
            cell.contentView.backgroundColor = UIColor.clear
            cell.textFieldOne.tintColor = UIColor.black//UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.font_Color!)
           cell.textFieldOne.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
            //UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)
        }
        if let cell = cell as? LabelTableViewCell {
            cell.titleLbl.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
            cell.titleLbl.font = UIFont(name: ThemeManager.sharedInstance.font_Regular!, size:CGFloat(ThemeManager.sharedInstance.fontSize_Medium!) )
             //UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)
        }
    }
    
    @objc func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveDetails(_ sender: Any) {
        
        switch editProfileScreenType {
        case .profile:
            if let editProfileType = self.editProfileType {
                switch editProfileType {
                case .name:
                    delegate?.saveEditedDetails(for: .name, with: details!)
                    break
                case .gender:
                    delegate?.saveEditedDetails(for: .gender, with: details!)
                    break
                case .standard:
                    delegate?.saveEditedDetails(for: .standard, with:details!)
                    break
                case .contact:
                    delegate?.saveEditedDetails(for: .contact, with: details!)
                    break
                case .address:
                    delegate?.saveEditedDetails(for: .address  , with: details!)
                }
            }
        default:
            if let editProfileType = self.editProfileType {
                switch editProfileType {
                case .name:
                    break
                case .gender:
                    signUpDelegate?.saveEditedDetails(for: .gender, with: signUpDetails!)
                    break
                case .standard:
                    signUpDelegate?.saveEditedDetails(for: .standard, with: signUpDetails!)
                    break
                case .contact:
                    break
                case .address:
                    signUpDelegate?.saveEditedDetails(for: .address, with: signUpDetails!)
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
   
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
       
        updateDetails(from: textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateDetails(from: textField)
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }

    
}
