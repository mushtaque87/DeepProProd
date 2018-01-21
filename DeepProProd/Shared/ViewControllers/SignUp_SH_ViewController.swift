//
//  SignUpViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/12/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class SignUp_SH_ViewController: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var informationLbl: UILabel!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet var viewModel: SignupViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Event and Action
  
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Dismmised")
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
