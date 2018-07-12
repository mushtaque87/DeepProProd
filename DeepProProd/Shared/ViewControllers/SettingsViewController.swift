//
//  SettingsViewController.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/27/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit



class SettingsViewController: UIViewController,SettingProtocols {

    @IBOutlet var viewModel: SettingsViewModel!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var languageControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Settings"
        self.settingTableView.register(UINib(nibName: "LogOutCell", bundle: nil), forCellReuseIdentifier: "logout")
        self.settingTableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "labelCell")
        self.settingTableView.register(UINib(nibName: "LanguageTableViewCell", bundle: nil), forCellReuseIdentifier: "language")
        self.settingTableView.register(UINib(nibName: "ThemeCell", bundle: nil), forCellReuseIdentifier: "theme")
        self.settingTableView.backgroundColor = UIColor.clear
        viewModel.delegate = self
       // self.view.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        self.backgroundImage.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshUI()
         backgroundImage.setBackGroundimage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showProfileScreen() {
        let profileViewController =     ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
   
    func showSettingSelectionScreen(for settingType : SettingType) {
        let settingSelectionViewController =     SettingSelectionTableViewController(nibName: "SettingSelectionTableViewController", bundle: nil)
        settingSelectionViewController.settingtype = settingType
        self.navigationController?.pushViewController(settingSelectionViewController, animated: true)
    }
    
     func logOut(_ sender: Any) {
        
        Settings.sharedInstance.setValue(key: "isLoggedIn", value: false as AnyObject)
        Settings.sharedInstance.reloadSettingsDictionary()
        if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
        {
           // rootVc.remove(viewController: rootVc.tabBar_ViewController , from: rootVc)
            rootVc.removeAllVCFromParentViewController()
            rootVc.showLoginViewController()
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
    func reloadTable(){
        settingTableView.reloadData()
    }
    
    func refreshUI() {
       
    }
}
