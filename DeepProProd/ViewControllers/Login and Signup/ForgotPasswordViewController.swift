//
//  ForgotPassword_SH_ViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/12/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class ForgotPasswordViewController: UIViewController , CAAnimationDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var                                                                                                                                        titleLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var restButton: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet var viewModel: ForgetPasswordViewModel!
    var forgotViewModel = ForgetPasswordViewModel()
    weak var delegate: ViewControllerDelegate?
    lazy var shadow = NSShadow()
    //MARK: - View Life Cycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Helper.getCurrentDevice() == .phone) {
            Helper.lockOrientation(.portrait)
        } 
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Forgot Password"
        refreshUI()
        _ =  emailTextField.rx.text.map {$0 ?? ""}.bind(to:forgotViewModel.email)
        _ = forgotViewModel.isValid.bind(to: resetBtn.rx.isEnabled)
        
        Helper.lockOrientation(.portrait)
        self.backgroundImage.isHidden = true
        //self.view.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        //self.navigationController?.navigationBar.barTintColor = UIColor.red
       
        shadow.shadowColor = UIColor.darkGray
        shadow.shadowBlurRadius = 1.0
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)

        //setTheme()
    }
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setTheme()
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        setTheme()
    }
    override func viewDidLayoutSubviews() {
        //setTheme()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTheme() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.navigationbar_tintColor!)
        
        //        let colors = ThemeManager.sharedInstance.color
        //        self.view.backgroundColor = UIColor.clear
        //        let backgroundLayer = colors?.gl
        //        backgroundLayer?.frame = self.view.bounds
        //        self.view.layer.insertSublayer(backgroundLayer!, at: 0)
        
        //self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.font_Color!),NSAttributedStringKey.shadow:shadow]
        
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //  let navcolor = colors?.copy() as! Colors
        // let navgradient = CAGradientLayer()
        let navgradient = ThemeManager.sharedInstance.color?.gl
        // let barlayer = navcolors.gl
        // navgradient.colors = [colors?.colorTop,colors?.colorBottom]
        navgradient?.frame = CGRect(x: 0, y:0, width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!)
        // (self.navigationController?.navigationBar.bounds)!
        self.navigationController?.view.layer.insertSublayer(navgradient!, at: 1)
        
        
        
        // self.navigationController?.navigationBar.layer.insertSublayer(barlayer, at: 1)
        
        
        
        //        let colorOne = Colors()
        //        let navbarlayer = colorOne.gl
        //        navbarlayer.frame = self.view.bounds
        //        self.view.layer.insertSublayer(navbarlayer, at: 0)
        
    }
    
    
    // MARK: - UIActions and Events

    @IBAction func reset(_ sender: Any) {
        emailTextField.resignFirstResponder()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Resetting Password.."
        /*
        let onSuccess: (ForgotPasswordResponse) -> Void = { result in
            if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
            {
                rootVc.showInfoAlertView(with: result.success == true ? "Password Reset Successful!!!  Check email." : "Password Reset failed. Please try again.")
            }
        }
 
        let onComplete: () -> Void =  {
            hud.hide(animated: true)
        }
         */
        
        ServiceManager().forgotPassword(for: self.emailTextField.text!, onSuccess: { result in
           /* if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
            {
                rootVc.showInfoAlertView(with: result.success == true ? "Password Reset Successful!!!  Check email." : "Password Reset failed. Please try again.")
              
            }*/
            hud.mode = MBProgressHUDMode.text
            if (result.success == true) {
            
            hud.label.text = "Password Reset Successfully"
            } else {
                hud.label.text = "Password Reset Failed"
            }
        }, onHTTPError: { httperror in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = httperror.description
            hud.hide(animated: true, afterDelay: 1.5)
        }, onError: { error in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = error.localizedDescription
            hud.hide(animated: true, afterDelay: 1.5)
        })
    }
    
    @IBAction func close(_ sender: Any) {
    
        self.dismiss(animated: true) {
            print("Dismmised")
        }
        
//        if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController {
//            rootVc.remove(viewController: self, from: rootVc)
//        }
//
        //self.view.slideBackToLeft(duration:1.0 , completionDelegate: self)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController {
                    rootVc.remove(viewController: self, from: rootVc)
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
    
    // MARK: - UI Update
    func refreshUI() {
        
        backgroundImage.setBackGroundimage()
        
        //loginTitleLbl.alignText()
        
    }
    
    func removeViewController() {
        if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
        {
            rootVc.remove(viewController: self, from: rootVc)
        }
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    

}
