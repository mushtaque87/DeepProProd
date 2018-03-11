//
//  Login_SH_ViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/9/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import MBProgressHUD

class Login_SH_ViewController: UIViewController {


    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var loginTitleLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var languageSwitch: UISwitch!
    @IBOutlet var viewModel: LoginViewModel!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
  
    
    // MARK: - UIView Design
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //Configure Switch Design
        // languageSwitch.tintColor = UIColor.init(red: 121.0/255.0, green: 239.0/255.0, blue: 215.0/255.0, alpha: 1)
        // languageSwitch.onTintColor = UIColor.init(red: 121.0/255.0, green: 239.0/255.0, blue: 215.0/255.0, alpha: 1)
       
        languageSwitch.setOn(false, animated: false)
        languageSwitch.addTarget(self, action: #selector(changeLanguage(_:)), for: .valueChanged)
        
        self.navigationController?.navigationBar.backgroundColor =  UIColor.clear
         Helper.lockOrientation(.portrait)
    }

    override func viewDidAppear(_ animated: Bool) {
        refreshUI()
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

 // MARK: - UIElements Actions & Events
   
    @objc func changeLanguage(_ sender: UISwitch) {
        viewModel.switchValueChanged(sender)
        refreshUI()
    }
    @IBAction func login(_ sender: Any) {
      //  super.remove(viewController: self, from: s)
        Settings.sharedInstance.setValue(key: "FirstLogin", value: false as AnyObject)
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Logging in. Please wait"
        
        ServiceManager().doLogin(for: userNameTextField.text!, and: passwordTextField.text!,
                                 onSuccess: { response in
                                    Settings.sharedInstance.setValue(key: "isLoggedIn", value: true as AnyObject)
                                    if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
                                    {
                                        rootVc.remove(viewController: self, from: rootVc)
                                        rootVc.addTabBarControllers()
                                        
                                    }
                                    
        }, onHTTPError: { httperror in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = httperror.description
        }, onError: { error in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = error.localizedDescription
        }, onComplete:  {
            hud.hide(animated: true)
        })
    }

    @IBAction func signUp(_ sender: Any) {
 
        if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
        {
            rootVc.showSignUpViewController()
            rootVc.signUp_ViewController.userObserver.subscribe(onNext: { [weak self] details in
                self?.userNameTextField.text = details.username
                self?.passwordTextField.text = details.password
            }).disposed(by: rootVc.disposeBag)
        }
   
    }
    
    @IBOutlet weak var forgotPassword: UIButton!
    @IBAction func forgotPassword(_ sender: Any) {
        
        let forgot_ViewController : ForgotPassword_SH_ViewController = ForgotPassword_SH_ViewController(nibName: "ForgotPassword_SH_ViewController", bundle: nil)
        if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
        {
            rootVc.addSubView(addChildViewController: forgot_ViewController, on: rootVc)
            //forgot_ViewController.view.slideInFromRight()
        }
    }
    
    @IBAction func showPracticeBoard(_ sender: Any) {
        
        let transDetailViewController = TransDetailViewController(nibName: "TransDetailViewController", bundle: nil)
        self.present(transDetailViewController, animated: true) {
            print("Practice Board Displayed")
        }
        
        
    }
    // MARK: - UI Update
    func refreshUI() {
        Localizator.sharedInstance.reloadLocalisationDictionary()
        loginTitleLbl.text = "LoginPage_Title".localized
        loginBtn.setTitle("LoginPage_Login".localized, for: .normal)
        forgotPasswordBtn.setTitle("LoginPage_ForgotPassword".localized, for: .normal)
        signUpBtn.setTitle("LoginPage_SignUp".localized, for: .normal)
        
        forgotPasswordBtn.alignText()
        signUpBtn.alignText()
        backgroundImg.setBackGroundimage()
        
        //loginTitleLbl.alignText()
       
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}


