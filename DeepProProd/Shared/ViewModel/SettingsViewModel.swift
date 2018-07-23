//
//  SettingsViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/14/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import MBProgressHUD

enum SettingType : Int  {
    case language
    case themetype
    case graphtype
    case logout
}


class SettingsViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var settingtype : SettingType?
    weak var delegate: SettingProtocols?
    
    // MARK: - TableView Delegate
    /*
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
     */
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
         let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
         headerView.backgroundColor = UIColor.white
        let titleLbl : UILabel =  UILabel(frame: CGRect(x: 5, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height))
        titleLbl.font = UIFont.boldSystemFont(ofSize: 25)
        titleLbl.textColor = UIColor.black
        titleLbl.text = "Settings".localized
        titleLbl.alignText()
        titleLbl.backgroundColor = UIColor.clear
        headerView.addSubview(titleLbl)
        headerView.backgroundColor = UIColor(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1)
         return headerView
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let settingtype = SettingType(rawValue: indexPath.row) {
            switch settingtype {
            case .language, .graphtype , .themetype:
                return 80.0
            case .logout:
                 return 80.0
            }

        }
        return 80.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            return 4
        }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard indexPath.section > 0  else {
       
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
        cell.titleLbl.text = "My_Account".localized
        cell.titleLbl.alignText()
        cell.contentView.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        return cell
        */
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
        cell.titleLabel.text = "My_Account".localized
        cell.titleLabel.textColor = UIColor.white
        cell.titleLabel.textAlignment = .left
        cell.backgroundColor = UIColor.clear
        cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        cell.titleLabel.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.valueTextField.isEnabled = false
        cell.valueTextField.textColor = UIColor.white
        cell.valueTextField.tag = indexPath.row
        return cell
    }
    
    if let settingtype = SettingType(rawValue: indexPath.row) {
       
            switch settingtype {
            case .language:
                //let cell  = tableView.dequeueReusableCell(withIdentifier: "language", for: indexPath) as! LanguageTableViewCell
               /*  let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
                 cell.titleLbl.text = "Language".localized

                //cell.languageSwitch.addTarget(self, action: #selector(languageSelected), for: UIControlEvents.valueChanged)
                cell.titleLbl.alignText()
                cell.contentView.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                 */
                
                /*
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.accessoryType = .disclosureIndicator
                cell.tintColor = UIColor.white
                cell.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 17)
                cell.textLabel?.textColor = UIColor.white
                cell.textLabel?.backgroundColor = UIColor.clear
                cell.backgroundColor  = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.contentView.backgroundColor = UIColor.clear
                cell.textLabel?.text = "Language".localized
                 */
                let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.titleLabel.text = "Language".localized
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.titleLabel.backgroundColor = UIColor.clear
                
                cell.valueTextField.isEnabled = false
                cell.valueTextField.textColor = UIColor.white
                cell.valueTextField.tag = indexPath.row
                cell.valueTextField.text = Settings.sharedInstance.language
                cell.selectionStyle = .none
                return cell
             /*
            case .profile:
                 let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
                 cell.titleLbl.text = "My_Account".localized
                 cell.titleLbl.alignText()
                 cell.contentView.backgroundColor = UIColor.clear
                 return cell
              */
                /*
            case .mainPage:
                
                let cell  = tableView.dequeueReusableCell(withIdentifier: "language", for: indexPath) as! LanguageTableViewCell
                
                cell.titlLbl.text = "MainPage".localized
                cell.languageSwitch.setTitle("Main", forSegmentAt: 0)
                cell.languageSwitch.setTitle("Practice Board", forSegmentAt: 1)
                cell.languageSwitch.addTarget(self, action: #selector(selectMainPage(_:)), for: UIControlEvents.valueChanged)
                cell.titlLbl.alignText()
                cell.contentView.backgroundColor = UIColor.clear
                return cell
                 */
            case .graphtype:
              /*  let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
                cell.titleLbl.text = "GraphType".localized
                cell.titleLbl.alignText()
                cell.contentView.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                */
                
                /*
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.accessoryType = .disclosureIndicator
                cell.tintColor = UIColor.white
                cell.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 17)
                cell.textLabel?.textColor = UIColor.white
                cell.textLabel?.backgroundColor = UIColor.clear
                cell.backgroundColor  = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.contentView.backgroundColor = UIColor.clear
                 cell.textLabel?.text = "GraphType".localized
                */
                
                let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.titleLabel.text = "GraphType".localized
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.titleLabel.backgroundColor = UIColor.clear
                
                cell.valueTextField.isEnabled = false
                cell.valueTextField.textColor = UIColor.white
                cell.valueTextField.tag = indexPath.row
                cell.valueTextField.text = (Settings.sharedInstance.graphType == 0 ? "Bar" : "Line")
                
                cell.selectionStyle = .none
                /*
                let cell  = tableView.dequeueReusableCell(withIdentifier: "language", for: indexPath) as! LanguageTableViewCell
                cell.titlLbl.text = "GraphType".localized
                cell.languageSwitch.setTitle("Bar", forSegmentAt: 0)
                cell.languageSwitch.setTitle("Line", forSegmentAt: 1)
                cell.languageSwitch.addTarget(self, action: #selector(selectGraphType(_:)), for: UIControlEvents.valueChanged)
                cell.titlLbl.alignText()
                cell.contentView.backgroundColor = UIColor.clear
                 */
                return cell
                
            case .themetype:
                
                /*
                let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
                cell.titleLbl.text = "Theme".localized
                cell.titleLbl.alignText()
                cell.contentView.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                */
                
                /*
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.accessoryType = .disclosureIndicator
                cell.tintColor = UIColor.white
                cell.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 17)
                cell.textLabel?.textColor = UIColor.white
                cell.textLabel?.backgroundColor = UIColor.clear
                cell.backgroundColor  = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.contentView.backgroundColor = UIColor.clear
                cell.textLabel?.text = "Theme".localized
                */
                
                let cell  = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! DetailCell
                cell.titleLabel.text = "Theme".localized
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.textAlignment = .left
                cell.backgroundColor = UIColor.clear
                cell.backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.titleLabel.backgroundColor = UIColor.clear
                
                cell.valueTextField.isEnabled = false
                cell.valueTextField.textColor = UIColor.white
                cell.valueTextField.tag = indexPath.row
                switch Settings.sharedInstance.themeType {
                case 0:
                    cell.valueTextField.text = "Blue"
                    break
                case 1:
                    cell.valueTextField.text = "Green"
                    break
                default :
                    cell.valueTextField.text = "Pink"
                    break
                }
                cell.selectionStyle = .none
                
                /*let cell  = tableView.dequeueReusableCell(withIdentifier: "language", for: indexPath) as! LanguageTableViewCell
                cell.titlLbl.text = "GraphType".localized
                cell.languageSwitch.setTitle("Sea Green", forSegmentAt: 0)
                cell.languageSwitch.setImage(UIImage(named:"Abstract"), forSegmentAt: 0)
                cell.languageSwitch.setTitle("Sky Blue", forSegmentAt: 1)
                cell.languageSwitch.setImage(UIImage(named:"Carbon"), forSegmentAt: 1)
               
                cell.languageSwitch.addTarget(self, action: #selector(themeType), for: UIControlEvents.valueChanged)
                cell.titlLbl.alignText()*/
                
                /*
                let cell  = tableView.dequeueReusableCell(withIdentifier: "theme", for: indexPath) as! ThemeCell
                cell.setImage(forButtonWithTag: 1, withImage: "Carbon")
                cell.setImage(forButtonWithTag: 2, withImage: "Abstract")
                cell.setImage(forButtonWithTag: 3, withImage: "Arb_Background")
                cell.setImage(forButtonWithTag: 4, withImage: "Eng_BackGround")
                cell.button1.addTarget(self, action: #selector(selectThemeType(_:)), for: UIControlEvents.touchUpInside)
                cell.button2.addTarget(self, action: #selector(selectThemeType(_:)), for: UIControlEvents.touchUpInside)
                cell.button3.addTarget(self, action: #selector(selectThemeType(_:)), for: UIControlEvents.touchUpInside)
                cell.button4.addTarget(self, action: #selector(selectThemeType(_:)), for: UIControlEvents.touchUpInside)
                
                cell.titleLbl.text = "Theme".localized
                cell.titleLbl.alignText()
                cell.contentView.backgroundColor = UIColor.clear
                */
                return cell
                /*
            case .announcements:
                let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
                cell.titleLbl.text = "Announcements".localized
                cell.titleLbl.alignText()
                cell.contentView.backgroundColor = UIColor.clear
                return cell
            case .aboutus:
                let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
                cell.titleLbl.text = "Aboutus".localized
                cell.titleLbl.alignText()
                cell.contentView.backgroundColor = UIColor.clear
                return cell
 */
            case .logout:
//                 let cell = tableView.dequeueReusableCell(withIdentifier: "logout", for: indexPath) as! LogOutCell
//                 return cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
                cell.titleLbl.textAlignment = .center
                cell.titleLbl.text = "Logout".localized
                cell.contentView.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                cell.selectionStyle = .blue
                return cell
            }
        }
    return UITableViewCell()
    }

   
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            
            
            guard indexPath.section > 0 else {
                delegate?.showProfileScreen()
                return
            }
            
            if let settingtype = SettingType(rawValue: indexPath.row) {
                switch settingtype {
                case .language:
                    delegate?.showSettingSelectionScreen(for: .language)
                  /*
                case .profile:
                    delegate?.showProfileScreen()
                    break
 */
                case .themetype:
                    delegate?.showSettingSelectionScreen(for: .themetype)
                case .graphtype:
                    delegate?.showSettingSelectionScreen(for: .graphtype)
                    /*
                case .themetype: break
                case .announcements: break
                    
                case .aboutus: break
                    */
                case .logout:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "logout", for: indexPath) as! LogOutCell
                    delegate?.logOut(cell.logOut)
                    break
                }
        }
    }
    
    //MARK: - UIAction and Events
    
    @objc func languageSelected(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0)
        {
            Settings.sharedInstance.language = "English"
            Settings.sharedInstance.setValue(key: "Language", value: "English" as AnyObject)
        }
        else
        {
            Settings.sharedInstance.language = "Arabic"
            Settings.sharedInstance.setValue(key: "Language", value: "Arabic" as AnyObject)
            
        }
        Localizator.sharedInstance.reloadLocalisationDictionary()
        delegate?.reloadTable()
    }
    
    @objc func selectMainPage(_ sender: UISegmentedControl) {
       
        Settings.sharedInstance.mainPage = sender.selectedSegmentIndex
        Settings.sharedInstance.setValue(key: "mainPage", value: sender.selectedSegmentIndex as AnyObject)
        Localizator.sharedInstance.reloadLocalisationDictionary()
        //delegate?.reloadTable()
    }
    
    @objc func selectGraphType(_ sender: UISegmentedControl) {
        
        Settings.sharedInstance.graphType = sender.selectedSegmentIndex
        Settings.sharedInstance.setValue(key: "GraphType", value: sender.selectedSegmentIndex as AnyObject)
        Localizator.sharedInstance.reloadLocalisationDictionary()
        //delegate?.reloadTable()
    }
    
    @objc func selectThemeType(_ sender: UIButton) {
        
        Settings.sharedInstance.themeType = sender.tag
        Settings.sharedInstance.setValue(key: "ThemeType", value: sender.tag as AnyObject)
        //Localizator.sharedInstance.reloadLocalisationDictionary()
        //delegate?.reloadTable()
    }
    
    
    
    
    
    
}
