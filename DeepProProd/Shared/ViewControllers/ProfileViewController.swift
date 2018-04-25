//
//  ProfileViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/5/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import MBProgressHUD

enum ScreenType : Int  {
    case view
    case edit
}


class ProfileViewController: UIViewController {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var myProfileView: MyProfileView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var userTypeField: UITextField!
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var adressField: UITextView!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    
    
    var isEditEnabled : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editProfile(_:)))
      
        
        
       // var viewArray : Array = (Bundle.main.loadNibNamed("MyProfileView", owner: self, options: nil))!
       //let tempProfileView = MyProfileView().loadNib() as! MyProfileView
        //self.view.addSubview(viewArray[0] as! UIView)
        //view.addSubview(tempProfileView)
        // Do any additional setup after loading the view.
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Fetching Profile. Please wait."
        
        
        ServiceManager().getProfile(for: UserDefaults.standard.string(forKey: "uid")! , onSuccess: { response in
            self.nameField.text = response.first_name! + " " + response.last_name!
            self.emailField.text = response.email
            hud.hide(animated: true)
        }, onHTTPError: { httperror in
            hud.hide(animated: true)
        }, onError: { Error in
            hud.hide(animated: true)
        },onComplete: {
            hud.hide(animated: true)
        })
        
    }

    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func editProfile(_ sender: Any) {
        
        if (!isEditEnabled){
           myProfileView.fadeOut()
            isEditEnabled = true
        }else
        {
            myProfileView.fadeIn()
            isEditEnabled = false
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

}
