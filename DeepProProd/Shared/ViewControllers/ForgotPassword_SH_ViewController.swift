//
//  ForgotPassword_SH_ViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/12/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class ForgotPassword_SH_ViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var                                                                                                                                        titleLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var viewModel: ForgetPasswordViewModel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshUI()
    }
    @IBOutlet weak var resetBtn: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UIActions and Events

    @IBAction func reset(_ sender: Any) {
        
    }
    
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
