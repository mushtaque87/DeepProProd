//
//  TabBarControllerViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/9/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class TabBarControllerViewController: UITabBarController , UITabBarControllerDelegate {

    @IBOutlet weak var newButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        // Do any additional setup after loading the view.
//        let myFirstButton = UIButton()
//        myFirstButton.setTitle("Hello", for: .normal)
//        myFirstButton.setTitleColor(UIColor.blue, for: .normal)
//        myFirstButton.frame = CGRect(x: 20, y: 80, width: 50, height: 40)
//        myFirstButton.addTarget(self, action: #selector(progbutton), for: .touchUpInside)
//        self.view.addSubview(myFirstButton)
        configureTabBar()
        if(Helper.getCurrentDevice() == .phone) {
            Helper.lockOrientation(.portrait)
        } 
       
        
    }
    
    func updateTabBarColor() {
       // self.tabBar.barTintColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)
        //self.tabBar.unselectedItemTintColor = UIColor.white
        Helper.printLogs()
        self.tabBar.tintColor = UIColor.hexStringToUIColor(hex: "#2C354B")
    }
    
    func configureTabBar()
    {
        Helper.printLogs()
        var tabBarViewControllers = [UIViewController]()

      
            let courseNavigationController = UINavigationController()
            let levelViewController : LevelViewController =  LevelViewController(nibName: "LevelViewController", bundle: nil)
            courseNavigationController.viewControllers = [levelViewController]
            courseNavigationController.tabBarItem = UITabBarItem(title: "Contents", image: UIImage(named: "books-stack-of-three.png"), tag: 0)
       
        /*
            let studentAssignmentNavigationController = UINavigationController()
            let studentDashboard = AssignmnetDasboardViewController(nibName:"AssignmnetDasboardViewController",bundle:nil)
            //studentDashboard.viewModel.tasktype = .assignment
            studentAssignmentNavigationController.viewControllers = [studentDashboard]
            studentAssignmentNavigationController.tabBarItem = UITabBarItem(title: "Assignment", image: UIImage(named: "assignmentTab.png"), tag: 1)
    */
        
        let assignmemntNavigationController = UINavigationController()
        let assignmentViewController : LevelViewController =  LevelViewController(nibName: "LevelViewController", bundle: nil)
        assignmentViewController.viewModel.contentType = .assignment
        assignmemntNavigationController.viewControllers = [assignmentViewController]
        assignmemntNavigationController.tabBarItem = UITabBarItem(title: "Assignment", image: UIImage(named: "list.png"), tag: 1)
        
            let practiceBoardNavigationController = UINavigationController()

            let practiceBoardViewController = PracticeBoardViewController(nibName:"PracticeBoardViewController",bundle:nil)
            Helper.printLogs()
            practiceBoardViewController.tasktype = .freeText
            Helper.printLogs()
            practiceBoardNavigationController.viewControllers = [practiceBoardViewController]
            Helper.printLogs()
            practiceBoardNavigationController.tabBarItem = UITabBarItem(title: "Practice", image: UIImage(named: "line-chart.png"), tag: 2)
 
            let settingNavigationController = UINavigationController()
            let settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
            settingNavigationController.viewControllers = [settingsViewController]
            settingNavigationController.tabBarItem = UITabBarItem(title: "Settings", image:UIImage(named: "settings.png"), tag: 3)
        
            tabBarViewControllers  = [courseNavigationController,assignmemntNavigationController,practiceBoardNavigationController,settingNavigationController]
            
        
        viewControllers = tabBarViewControllers
        
        updateTabBarColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let tabindex = Settings.sharedInstance.mainPage {
            Helper.printLogs()
            self.selectedIndex = tabindex
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    /*
    @IBOutlet weak var tabTouched: UIButton!
    @IBAction func tabtouch(_ sender: Any) {
        print("XX")
        
    }
    @IBAction func newButTouched(_ sender: Any) {
        
       print("new")
    }
    
    @objc func progbutton()
    {
        print("prog")
    }
 */
}
