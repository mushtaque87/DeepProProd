//
//  TabBarControllerViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/9/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class TabBarControllerViewController: UITabBarController {

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
        
       
        let levelViewController : Level_SHViewController =  Level_SHViewController(nibName: "Level_SHViewController", bundle: nil)
        levelViewController.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(named: "homeTab.png"), tag: 0)
        
        let transDetailViewController = TransDetailViewController(nibName: "TransDetailViewController", bundle: nil)
        transDetailViewController.tabBarItem = UITabBarItem(title: "Speech", image: UIImage(named: "homeTab.png"), tag: 1)
        
        let settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image:UIImage(named: "homeTab.png"), tag: 2)
   
        let tabBarViewControllers = [levelViewController,transDetailViewController,settingsViewController]
        
        viewControllers = tabBarViewControllers
        
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
