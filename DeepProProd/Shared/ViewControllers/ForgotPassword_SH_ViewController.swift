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

class ForgotPassword_SH_ViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var                                                                                                                                        titleLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var restButton: UIButton!
    
    @IBOutlet var viewModel: ForgetPasswordViewModel!
    var forgotViewModel = ForgetPasswordViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshUI()
        _ =  emailTextField.rx.text.map {$0 ?? ""}.bind(to:forgotViewModel.email)
        _ = forgotViewModel.isValid.bind(to: resetBtn.rx.isEnabled)
    }
    @IBOutlet weak var resetBtn: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UIActions and Events

    @IBAction func reset(_ sender: Any) {
        
        
        let requestComplete: (ForgotPasswordResponse) -> Void = { result in
            
            if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
            {
                

                rootVc.showInfoAlertView(with: result.success == true ? "Password Reset Successful!!!  Check email." : "Password Reset failed. Please try again.")
            }
        }

        ServiceManager().forgotPassword(for: self.emailTextField.text!, with: requestComplete)
    }
    
    @IBAction func close(_ sender: Any) {
//
//        self.dismiss(animated: true) {
//            print("Dismmised")
//        }
//
        if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
        {
            
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
    

}
