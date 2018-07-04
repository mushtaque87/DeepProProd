//
//  ViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/8/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import RxSwift

protocol MainViewControllerProtocols {
    

    
}



class MainViewController: UIViewController, MainViewControllerProtocols {

    
    open var currentViewController : UIViewController?
    open var previousViewController : UIViewController?
    let disposeBag = DisposeBag()
    
    /*
    lazy var   tabBar_ViewController: TabBarControllerViewController = {
       var viewcontroller = TabBarControllerViewController(nibName: "TabBarControllerViewController", bundle: nil)
        return viewcontroller
    }()
    */
   lazy var     login_ViewController: Login_SH_ViewController  = {
     var viewcontroller   = Login_SH_ViewController(nibName: "Login_SH_ViewController", bundle: nil)
     return viewcontroller
    
    }()
     
    
    lazy var     signUp_ViewController: SignUp_SH_ViewController  = {
        var viewcontroller   = SignUp_SH_ViewController(nibName: "SignUp_SH_ViewController", bundle: nil)
        return viewcontroller
        
    }()
    
    lazy var     infoAlertView: InfromationAlertViewController  = {
        var viewcontroller   = InfromationAlertViewController(nibName: "InfromationAlertViewController", bundle: nil)
        return viewcontroller
        
    }()
    
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
                

                showLoginViewController()
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
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
    func addTabBarControllers() {
        
       /* if let tabBarVC = tabBar_ViewController
        {
            self.bringViewController(toFront: tabBarVC, on: self)

        }
        else {
             tabBar_ViewController = TabBarControllerViewController(nibName: "TabBarControllerViewController", bundle: nil)
            self.addSubView(addChildViewController: tabBar_ViewController!, on: self)
        }*/
        
        let tabBar_ViewController = TabBarControllerViewController(nibName: "TabBarControllerViewController", bundle: nil)
        self.addSubView(addChildViewController: tabBar_ViewController, on: self)
    }
    
    func showLoginViewController() {
        
        
       /*
        if let loginVC = login_ViewController, self.currentViewController ==  login_ViewController
        {
            self.bringViewController(toFront: loginVC, on: self)
           // self.addSubView(addChildViewController: loginVC, on: self)

          
        }
        else {
         login_ViewController  = Login_SH_ViewController(nibName: "Login_SH_ViewController", bundle: nil)
            login_ViewController?.view.frame = self.view.frame
       // let navigation_Controller = UINavigationController()
       // navigation_Controller.viewControllers = [login_ViewController]
        
            self.addSubView(addChildViewController: login_ViewController!, on: self)
        }
        
        */
        //let login_ViewController  = Login_SH_ViewController(nibName: "Login_SH_ViewController", bundle: nil)
        //login_ViewController?.view.frame = self.view.frame
        self.addSubView(addChildViewController: login_ViewController, on: self)
        
        
    }
    
    func showSignUpViewController() -> Void {
        let signUp_ViewController: SignUp_SH_ViewController = SignUp_SH_ViewController(nibName: "SignUp_SH_ViewController", bundle: nil)
        //self.navigationController?.pushViewController(signUp_ViewController, animated: true)
        self.present(signUp_ViewController, animated: true, completion: nil)
        //self.addSubView(addChildViewController: signUp_ViewController, on: self)

    }
    
    func showForgetPasswordViewController() -> Void {
        let forgot_ViewController : ForgotPassword_SH_ViewController = ForgotPassword_SH_ViewController(nibName: "ForgotPassword_SH_ViewController", bundle: nil)
        self.present(forgot_ViewController, animated: true, completion: nil)
        
    }
    
    func showInfoAlertView(with message:String) -> Void {
        //let signUp_ViewController: SignUp_SH_ViewController = SignUp_SH_ViewController(nibName: "SignUp_SH_ViewController", bundle: nil)
        self.addSubView(addChildViewController: infoAlertView, on: self)
        infoAlertView.infoMessage = message
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

