//
//  SignUpViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/12/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import RxSwift

class SignUp_SH_ViewController: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var informationLbl: UILabel!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet var viewModel: SignupViewModel!
    
    //RxSwift
    private var userinfo = Variable(user())
    var userObserver:Observable<user> {
        return userinfo.asObservable()
    }
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUI()

        //_ =  ageTxtField.rx.text.map {$0 ?? ""}.bind(to:viewModel.dob)

            viewModel.dobObserver.subscribe(onNext: { [weak self] details in
                self?.ageTxtField.text = details
                print("Dob : \(details)")
                //self?.login(nil)
            }).disposed(by: disposeBag)
    }
    
        // Do any additional setup after loading the view.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Event and Action
  
    @IBAction func close(_ sender: Any) {
      /*  self.dismiss(animated: true) {
            print("Dismmised")
        } */
        
        if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
        {
            rootVc.remove(viewController: rootVc.signUp_ViewController, from: rootVc)
        }
    }
    
    
    @IBAction func signUp(_ sender: Any) {
       
        //RxSwift
        self.userinfo.value = user(username: self.emailTxtField.text!, password: self.passordTextField.text!)
        return
        let requestComplete: (Any) -> Void = { result in
           
            Settings.sharedInstance.setValue(key: "isLoggedIn", value: true as AnyObject)
           
                if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
                {
                        rootVc.remove(viewController: rootVc.login_ViewController, from: rootVc)
                        rootVc.remove(viewController: rootVc.signUp_ViewController, from: rootVc)

                        rootVc.addTabBarControllers()
               
                }
            }

        
        if(isDetailsFilled())
        {
            viewModel.createSignUpBody(firstname: firstNameTxtField.text!, lastname: lastNameTxtField.text!, email: emailTxtField.text!, password: passordTextField.text!, age: ageTxtField.text!, dob: "", gender: genderSwitch.selectedSegmentIndex)
            
            ServiceManager().doSignUp(with: emailTxtField.text!, firstName: firstNameTxtField.text!, lastName: lastNameTxtField.text!, password: confirmPasswordTxtField.text!, with: requestComplete)
        }
        
        print("end of signup")
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
    
    func isDetailsFilled() -> Bool {
        
        guard passordTextField.text?.count != 0 &&
            passordTextField.text?.count != 0 &&
            confirmPasswordTxtField.text?.count != 0 &&
            emailTxtField.text?.count != 0 &&
            firstNameTxtField.text?.count != 0 &&
            lastNameTxtField.text?.count != 0
            else {
                if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
                {
                    let alert = UIAlertController(title: "Warning", message:"All the Details are not filled properly" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    rootVc.present(alert, animated: true, completion: nil)
                    
                }
            return false
        }
        
        guard passordTextField.text == confirmPasswordTxtField.text else {
            
            if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
            {
                let alert = UIAlertController(title: "Warning", message:"password and confirm password field are not same" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                rootVc.present(alert, animated: true, completion: nil)
                
            }
            return false
        }
        
        return true
    }

}
