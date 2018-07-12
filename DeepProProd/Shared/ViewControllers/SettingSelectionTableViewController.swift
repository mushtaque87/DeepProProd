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
    var settingTypeDetails = ["Language": ["English","Arabic"], "Theme":["Blue","Grey","Red"] , "Graph Type":["Bar","Line"] , "Gender":["Male" ,"Female"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
        cell.contentView.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        cell.selectionStyle = .none
       // cell.accessoryView?.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        cell.tintColor = UIColor.white
        if let settingtype = self.settingtype {
            switch settingtype {
            case .language:
                cell.textLabel?.text = settingTypeDetails["Language"]?[indexPath.row]
            case .themetype:
                cell.textLabel?.text = settingTypeDetails["Theme"]?[indexPath.row]
            case .graphtype:
                cell.textLabel?.text = settingTypeDetails["Graph Type"]?[indexPath.row]
            case .logout:
                break
            }
        }
        // Configure the cell...
        
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
    
}
