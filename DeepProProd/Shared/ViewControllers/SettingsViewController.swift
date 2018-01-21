//
//  SettingsViewController.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/27/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var viewModel: SettingsViewModel!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var languageControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Setting"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func logOut(_ sender: Any) {
        
        Settings.sharedInstance.setValue(key: "isLoggedIn", value: false as AnyObject)
        Settings.sharedInstance.reloadSettingsDictionary()
        if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
        {
            rootVc.remove(viewController: self.parent!, from: rootVc)
            rootVc.addLoginViewController()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func refreshUI() {
        backgroundImg.setBackGroundimage()
    }
}
