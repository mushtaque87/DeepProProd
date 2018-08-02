//
//  SettingDetailsTableViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/12/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class SettingSelectionTableViewController: UITableViewController {
    var settingtype : SettingType?
    var settingTypeDetails = ["Language": ["English","Arabic"], "Theme":["Grey (Default)","Blue","Red", "Pink"] , "Graph Type":["Bar","Line"] , "Gender":["Male" ,"Female"]]
    var selectedIndex : IndexPath?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveDetails(_:)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let settingtype = self.settingtype {
            switch settingtype {
            case .language:
                return "Select language"
            case .themetype:
                return "Select Theme"
            case .graphtype:
                return "Select Graph Type"
            case .logout:
                break
            }
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let settingtype = self.settingtype {
            switch settingtype {
            case .language:
                return settingTypeDetails["Language"]!.count
            case .themetype:
                return settingTypeDetails["Theme"]!.count
            case .graphtype:
                return settingTypeDetails["Graph Type"]!.count
            case .logout:
                break
            }
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       // cell.contentView.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.backgroundColor = UIColor.clear
        //cell.backgroundColor = UIColor.colorFrom(hexString: ThemeManager.sharedInstance.backgroundColor_Regular!)
        cell.selectionStyle = .none
       // cell.accessoryView?.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        cell.tintColor = UIColor.white
        if let settingtype = self.settingtype {
            switch settingtype {
            case .language:
                cell.textLabel?.text = settingTypeDetails["Language"]?[indexPath.row]
            case .themetype:
                cell.textLabel?.text = settingTypeDetails["Theme"]?[indexPath.row]
                if (indexPath.row == 0) {
                    //cell.backgroundColor  = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
                    setCellGradient(for: cell, with: .defaults)
                } else if (indexPath.row == 1){
                    //cell.backgroundColor  = UIColor(red: 10/255, green: 197/255, blue: 98/255, alpha: 0.9)
                    setCellGradient(for: cell, with: .blue)
                } else if (indexPath.row == 2){
                   // cell.backgroundColor  = UIColor(red: 255/255, green: 168/255, blue: 212/255, alpha: 0.9)
                    setCellGradient(for: cell, with: .red)
                }else {
                    setCellGradient(for: cell, with: .pink)
                }
            case .graphtype:
                cell.textLabel?.text = settingTypeDetails["Graph Type"]?[indexPath.row]
            case .logout:
                break
            }
        }
        // Configure the cell...
        configureCells(for: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let settingtype = self.settingtype {
            switch settingtype {
            case .language:
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                deselectOtherRows(except: indexPath.row)
            case .themetype:
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                deselectOtherRows(except: indexPath.row)
            case .graphtype:
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                deselectOtherRows(except: indexPath.row)
            case .logout:
                break
            }
        }
        selectedIndex = indexPath
    }

    func deselectOtherRows (except selectedRow : Int) {
        for row in 0...(tableView.numberOfRows(inSection: 0) - 1) {
            if row != selectedRow {
                let cell:UITableViewCell = tableView.cellForRow(at: IndexPath(row: row, section: 0))!
                cell.accessoryType = .none
            }
        }
    }
    
    //MARK:- UI Events and Actions
    @objc func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveDetails(_ sender: Any) {
        
        if let settingtype = self.settingtype {
            switch settingtype {
            case .language:
                languageSelected()
               break
            case .themetype:
                selectThemeType()
                break
            case .graphtype:
                selectGraphType()
               break
            case .logout:
                break
            }
        }
       self.navigationController?.popViewController(animated: true)
    }
  
    @objc func languageSelected() {
        if(selectedIndex?.row == 0)
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
    }

    @objc func selectGraphType() {
        
        Settings.sharedInstance.graphType = selectedIndex?.row
        Settings.sharedInstance.setValue(key: "GraphType", value: selectedIndex?.row as AnyObject)
        Localizator.sharedInstance.reloadLocalisationDictionary()
        //delegate?.reloadTable()
    }
    
    @objc func selectThemeType() {
        
        
        
        Settings.sharedInstance.themeType = selectedIndex?.row
        Settings.sharedInstance.setValue(key: "ThemeType", value: selectedIndex?.row as AnyObject)
        ThemeManager.sharedInstance.updateCurrentTheme()
        ThemeManager.sharedInstance.reloadThemeDictionary()
        ThemeManager.sharedInstance.setGradientLayer(with: true)
        
        if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
        {
            // rootVc.remove(viewController: rootVc.tabBar_ViewController , from: rootVc)
            rootVc.tabBar_ViewController.updateTabBarColor()
        }
        
        
        //Localizator.sharedInstance.reloadLocalisationDictionary()
        //delegate?.reloadTable()
    }
    
    func setCellGradient(for cell:UITableViewCell , with theme:ThemeType)
    {
        cell.contentView.backgroundColor = UIColor.clear
        switch theme {
        case .defaults:
            cell.backgroundColor = UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Default!)
            break
        case .red:
            cell.backgroundColor = UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Red!)
            break
        case .blue:
            cell.backgroundColor = UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Blue!)
            break
        case .pink:
            cell.backgroundColor = UIColor.hexStringToUIColor(hex: Settings.sharedInstance.theme_Pink!)
            break
        }
        
        //self.view.backgroundColor = UIColor.clear
        //let backgroundLayer = colors.gl
       // backgroundLayer.frame = cell.contentView.frame
        
        

        //cell.contentView.layer.insertSublayer(backgroundLayer, at: 0)*/
        
    }
    
    func configureCells(for cell:UITableViewCell) {
        cell.textLabel?.textColor = UIColor.black
            // UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.font_Color!)
        cell.textLabel?.font = UIFont(name: ThemeManager.sharedInstance.font_Regular!, size:CGFloat(ThemeManager.sharedInstance.fontSize_Medium!) )
        
        cell.tintColor = UIColor.black
        
        if (self.settingtype == SettingType.themetype) {
            cell.tintColor = UIColor.white
            cell.textLabel?.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        // UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)
        

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
    
}
