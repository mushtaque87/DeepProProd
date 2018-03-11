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

class ForgotPassword_SH_ViewController: UIViewController , CAAnimationDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var                                                                                                                                        titleLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var restButton: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet var viewModel: ForgetPasswordViewModel!
    var forgotViewModel = ForgetPasswordViewModel()
    weak var delegate: ViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshUI()
        _ =  emailTextField.rx.text.map {$0 ?? ""}.bind(to:forgotViewModel.email)
        _ = forgotViewModel.isValid.bind(to: resetBtn.rx.isEnabled)
        
        Helper.lockOrientation(.portrait)
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UIActions and Events

    @IBAction func reset(_ sender: Any) {
       
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
            if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
            {
                rootVc.showInfoAlertView(with: result.success == true ? "Password Reset Successful!!!  Check email." : "Password Reset failed. Please try again.")
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
    
    @IBAction func close(_ sender: Any) {
    self.view.slideBackToLeft(duration:1.0 , completionDelegate: self)
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
