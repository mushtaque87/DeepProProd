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

        // Do any additional setup after loading the view.
//        let myFirstButton = UIButton()
//        myFirstButton.setTitle("Hello", for: .normal)
//        myFirstButton.setTitleColor(UIColor.blue, for: .normal)
//        myFirstButton.frame = CGRect(x: 20, y: 80, width: 50, height: 40)
//        myFirstButton.addTarget(self, action: #selector(progbutton), for: .touchUpInside)
//        self.view.addSubview(myFirstButton)
       configureTabBar()
       
        
    }
    
    
    func configureTabBar()
    {
        var tabBarViewControllers = [UIViewController]()

            let courseNavigationController = UINavigationController()
            let levelViewController : Level_SHViewController =  Level_SHViewController(nibName: "Level_SHViewController", bundle: nil)
            courseNavigationController.viewControllers = [levelViewController]
            courseNavigationController.tabBarItem = UITabBarItem(title: "Contents", image: UIImage(named: "homeTab.png"), tag: 0)
            /*
            let studentAssignmentNavigationController = UINavigationController()
            let studentDashboard = AssignmnetDasboardViewController(nibName:"AssignmnetDasboardViewController",bundle:nil)
            studentDashboard.viewModel.tasktype = .assignment
            studentAssignmentNavigationController.viewControllers = [studentDashboard]
            studentAssignmentNavigationController.tabBarItem = UITabBarItem(title: "Assignment", image: UIImage(named: "assignmentTab.png"), tag: 1)
            */
            
            let practiceBoardNavigationController = UINavigationController()
            //let transDetailViewController = TransDetailViewController(nibName: "TransDetailViewController", bundle: nil)
            //  transDetailViewController.boardType = .account
            let transDetailViewController = PracticeBoardViewController(nibName:"PracticeBoardViewController",bundle:nil)
            //transDetailViewController.boardType = BoardType.account
            transDetailViewController.tasktype = .freeText
            practiceBoardNavigationController.viewControllers = [transDetailViewController]
            practiceBoardNavigationController.tabBarItem = UITabBarItem(title: "Board", image: UIImage(named: "assignmentTab.png"), tag: 2)
            
            let settingNavigationController = UINavigationController()
            let settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
            settingNavigationController.viewControllers = [settingsViewController]
            settingNavigationController.tabBarItem = UITabBarItem(title: "Settings", image:UIImage(named: "settingsTab.png"), tag: 3)
            
            tabBarViewControllers  = [courseNavigationController,practiceBoardNavigationController,settingNavigationController]
            
        
        viewControllers = tabBarViewControllers
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let tabindex = Settings.sharedInstance.mainPage {
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
}
