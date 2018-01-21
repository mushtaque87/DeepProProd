//
//  ViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/8/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

protocol MainViewControllerProtocols {
    

    
}



class MainViewController: UIViewController, MainViewControllerProtocols {

    
    open var currentViewController : UIViewController?
    open var previousViewController : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let tabBar =  TabBarControllerViewController();
        
        
        
        
        //self.addSubView(addChildViewController: tabBar, on: self)
       
        
        // Do any additional setup after loading the view, typically from a nib.
        if let firstLogin = Settings.sharedInstance.firstLogIn {
            if (firstLogin == true || Settings.sharedInstance.isLoggedIn == false){
            print("Login Page")
            Settings.sharedInstance.setValue(key: "FirstLogin", value: false as AnyObject)
                //let login_VC = Login_SH_ViewController();
                
               // let login_ViewController: Login_SH_ViewController = Login_SH_ViewController(nibName: "Login_SH_ViewController", bundle: nil)
               
                //let navigation_Controller = UINavigationController()
                //navigation_Controller.viewControllers = [login_ViewController]
                
               // self.addSubView(addChildViewController: navigation_Controller, on: self)
                
                addLoginViewController()
            } else {
                print("Tab Bar Controller")
               // let tabBar_ViewController: TabBarControllerViewController = TabBarControllerViewController(nibName: "TabBarControllerViewController", bundle: nil)
                //self.addSubView(addChildViewController: tabBar_ViewController, on: self)
                addTabBarControllers()
               // let menuViewController : Menu_SH_ViewController = Menu_SH_ViewController(nibName: "Menu_SH_ViewController", bundle: nil)
               //  self.addSubView(addChildViewController: menuViewController, on: self)
                
                //let levelViewController : Level_SHViewController =  Level_SHViewController(nibName: "Level_SHViewController", bundle: nil)
               // self.addSubView(addChildViewController: levelViewController, on: self)
            }
        
        }
        
        
    }
    
    func addTabBarControllers() {
        
        let tabBar_ViewController: TabBarControllerViewController = TabBarControllerViewController(nibName: "TabBarControllerViewController", bundle: nil)
        self.addSubView(addChildViewController: tabBar_ViewController, on: self)

    }
    
    func addLoginViewController() {
        let login_ViewController: Login_SH_ViewController = Login_SH_ViewController(nibName: "Login_SH_ViewController", bundle: nil)
        
       // let navigation_Controller = UINavigationController()
       // navigation_Controller.viewControllers = [login_ViewController]
        
        self.addSubView(addChildViewController: login_ViewController, on: self)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

