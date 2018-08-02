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
      lazy var shadow = NSShadow()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Settings"
        self.settingTableView.register(UINib(nibName: "LogOutCell", bundle: nil), forCellReuseIdentifier: "logout")
        self.settingTableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "labelCell")
        self.settingTableView.register(UINib(nibName: "LanguageTableViewCell", bundle: nil), forCellReuseIdentifier: "language")
        self.settingTableView.register(UINib(nibName: "ThemeCell", bundle: nil), forCellReuseIdentifier: "theme")
        self.settingTableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "details")

        self.settingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.settingTableView.backgroundColor = UIColor.clear
        viewModel.delegate = self
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: "#EFEFF4")
        self.backgroundImage.isHidden = true
        
        shadow.shadowColor = UIColor.darkGray
        shadow.shadowBlurRadius = 1.0
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
         reloadTable()
         setTheme()
         backgroundImage.setBackGroundimage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- View Controller Delegates
    func showProfileScreen() {
        let profileViewController =     ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
   
    func showSettingSelectionScreen(for settingType : SettingType) {
        let settingSelectionViewController =     SettingSelectionTableViewController(nibName: "SettingSelectionTableViewController", bundle: nil)
        settingSelectionViewController.settingtype = settingType
        self.navigationController?.pushViewController(settingSelectionViewController, animated: true)
    }
    
    //MARK:- UI Actions and Events
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
    
    func setTheme() {
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.font_Color!)]
       // self.navigationController?.navigationBar.layer.insertSublayer(barlayer, at: 1)
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.font_Color!),NSAttributedStringKey.shadow:shadow]
        
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        let colors = ThemeManager.sharedInstance.color
        let barlayer = colors?.gl
        barlayer?.frame = CGRect(x: 0, y:0, width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!)
        // (self.navigationController?.navigationBar.bounds)!
        self.navigationController?.view.layer.insertSublayer(barlayer!, at: 1)

    }
    
    func reloadTable(){
        settingTableView.reloadData()
    }
    
    func refreshUI() {
        self.settingTableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
 
}
