//
//  ViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/8/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import RxSwift





class MainViewController: UIViewController {

    
    open var currentViewController : UIViewController?
    open var previousViewController : UIViewController?
    let disposeBag = DisposeBag()
    
    /*
    lazy var   tabBar_ViewController: TabBarControllerViewController = {
       var viewcontroller = TabBarControllerViewController(nibName: "TabBarControllerViewController", bundle: nil)
        return viewcontroller
    }()
    */
   lazy var     login_ViewController: LoginViewController  = {    
     var viewcontroller   = LoginViewController(nibName: "LoginViewController", bundle: nil)
     return viewcontroller
    
    }()
     
    
    lazy var     signUp_ViewController: SignUpViewController  = {
        var viewcontroller   = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        return viewcontroller
        
    }()
    
   lazy var  tabBar_ViewController: TabBarControllerViewController = {
       var viewcontroller   = TabBarControllerViewController(nibName: "TabBarControllerViewController", bundle: nil)
        return viewcontroller
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func setNeedsStatusBarAppearanceUpdate() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let tabBar =  TabBarControllerViewController();
        
        
        
        
        //self.addSubView(addChildViewController: tabBar, on: self)
       
        ThemeManager.sharedInstance.setGradientLayer(with: true)
        
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
        
        tabBar_ViewController = TabBarControllerViewController(nibName: "TabBarControllerViewController", bundle: nil)
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
        
        let navigationController = UINavigationController(rootViewController: login_ViewController)
        //self.addChildViewController(navigationController)
        self.addSubView(addChildViewController: navigationController, on: self)
        //self.view.addSubview(navigationController.view)
        
    }
    
    func showSignUpViewController() -> Void {
        let signUp_ViewController: SignUpViewController = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        login_ViewController.navigationController?.pushViewController(signUp_ViewController, animated: true)
        //self.present(signUp_ViewController, animated: true, completion: nil)
       // self.navigationController?.pushViewController(signUp_ViewController, animated: true)
        //self.addSubView(addChildViewController: signUp_ViewController, on: self)
        
        /*
        let signUpViewController =     ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        signUpViewController.viewModel.isEditEnabled = true
        signUpViewController.viewModel.screenType = .signUp
        self.present(signUpViewController, animated: true, completion: nil)
         */
    }
    
    func showForgetPasswordViewController() -> Void {
        let forgot_ViewController : ForgotPasswordViewController = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
        login_ViewController.navigationController?.pushViewController(forgot_ViewController, animated: true)

        //self.present(forgot_ViewController, animated: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

