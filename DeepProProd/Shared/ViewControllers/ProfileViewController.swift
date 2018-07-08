//
//  ProfileViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/5/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import MBProgressHUD
import RxSwift

enum ScreenType : Int  {
    case view
    case edit
}


class ProfileViewController: UIViewController, ProfileViewDelegate {
  
    

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var myProfileView: MyProfileView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var userTypeField: UITextField!
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var adressField: UITextView!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var detailsTable: UITableView!
    var viewModel = ProfileViewModel()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        
       Helper.lockOrientation(.portrait)
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(controlKeyboard(sender:)))
        singleTapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTapGesture)
        
        configureEditOptions(with: viewModel.isEditEnabled)
        viewModel.delegate = self
        
        firstNameField.delegate = viewModel
        lastNameField.delegate = viewModel
        
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editProfile(_:)))
      
        self.view.backgroundColor = UIColor.white
            //UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        
       // var viewArray : Array = (Bundle.main.loadNibNamed("MyProfileView", owner: self, options: nil))!
       //let tempProfileView = MyProfileView().loadNib() as! MyProfileView
        //self.view.addSubview(viewArray[0] as! UIView)
        //view.addSubview(tempProfileView)
        // Do any additional setup after loading the view.
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Fetching Profile. Please wait."
        
        profileImage.layer.borderColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9).cgColor
        profileImage.layer.borderWidth = 6
        profileImage.layer.cornerRadius = 55
        
        
//        self.view.layer.borderColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9).cgColor
//        self.view.layer.borderWidth = 4
        //self.view.layer.cornerRadius = 55
        
        self.detailsTable.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "details")
        self.detailsTable.delegate = viewModel
        self.detailsTable.dataSource = viewModel
        self.detailsTable.backgroundColor = UIColor.white
        
        ServiceManager().getProfile(for: UserDefaults.standard.string(forKey: "uid")! , onSuccess: { response in
            self.firstNameField.text = response.first_name
            self.lastNameField.text = response.last_name
            self.emailField.text = response.email
            self.viewModel.details = Profile(first_name: response.first_name!, last_name: response.last_name!, user_attributes: User_attributes(dob: (response.user_attributes?.dob)!))
            self.detailsTable.reloadData()
            //self.dobField.text = response.user_attributes?.dob
            hud.hide(animated: true)
        }, onHTTPError: { httperror in
            hud.hide(animated: true)
        }, onError: { Error in
            hud.hide(animated: true)
        },onComplete: {
            hud.hide(animated: true)
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardDidShow, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name:NSNotification.Name.UIKeyboardDidHide, object: nil);

        
    }

    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func editProfile(_ sender: Any) {
        
        if (!viewModel.isEditEnabled){
          // myProfileView.fadeOut()
            self.navigationItem.rightBarButtonItem?.title = "Save"
            viewModel.isEditEnabled = true
            configureEditOptions(with: viewModel.isEditEnabled)
            detailsTable.reloadData()
        }else
        {
           // myProfileView.fadeIn()
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            viewModel.isEditEnabled = false
            configureEditOptions(with: viewModel.isEditEnabled)
            detailsTable.reloadData()
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.label.text = "Saving Profile. Please wait."
            //var dob : String?
           // if let cell : DetailCell = self.detailsTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? DetailCell {
           //     dob =  cell.valueTextField.text
           // }
            
            let profile = Profile(first_name: firstNameField.text! , last_name: lastNameField.text! , user_attributes: User_attributes(dob:(viewModel.details?.user_attributes?.dob)!))
            ServiceManager().updateProfile(for: UserDefaults.standard.string(forKey: "uid")! , with:profile,  onSuccess: { 
                hud.hide(animated: true)
            }, onHTTPError: { httperror in
                hud.hide(animated: true)
            }, onError: { Error in
                hud.hide(animated: true)
            },onComplete: {
                hud.hide(animated: true)
            })

        }
    }
    
    func configureEditOptions(with editStatus: Bool) {
        firstNameField.isEnabled = editStatus
        lastNameField.isEnabled = editStatus
        
//        for rowCount in 0...detailsTable.numberOfRows(inSection: 0) {
//            if let cell : DetailCell = self.detailsTable.cellForRow(at: IndexPath(row: rowCount, section: 0)) as? DetailCell {
//                cell.valueTextField.isEnabled = editStatus
//            }
//        }
       // dobField.isEnabled = editStatus
       // userTypeField.isEnabled = editStatus
      //  dobField.isEnabled = editStatus
       // contactField.isEnabled = editStatus
    }
    
    @objc func controlKeyboard (sender:UITapGestureRecognizer){
        guard sender.numberOfTapsRequired == 1   else {
            return
        }
        if let currentTextfield = viewModel.currentTextField {
        if(currentTextfield.isFirstResponder) {
            currentTextfield.resignFirstResponder()
        } else {
            currentTextfield.becomeFirstResponder()
        }
        }
    }
    
     //MARK: - Protocol
     //#define kOFFSET_FOR_KEYBOARD 80.0

    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print("keyboardFrame: \(keyboardFrame)")
        moveTextField(up: true, by: keyboardFrame.height)
    }
    
    @objc func keyboardHidden(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print("keyboardFrame: \(keyboardFrame)")
        moveTextField(up: false, by: keyboardFrame.height)
        
    }
    
    func moveTextField(up movedUp: Bool ,by height:CGFloat) {
        //detailsTable.setContentOffset(CGPoint(x: 0, y: textField.center.y - 160), animated: true)
        //[UIView beginAnimations:nil context:NULL];
        //[UIView setAnimationDuration:0.3]; // if you want to slide up the view
        guard ((viewModel.currentTextField?.tag)! < 99) else {
            return
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        var rect = self.view.frame;
        if (movedUp)
        {
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            if  (self.view.frame.origin.y >= 0)
            {
            viewModel.isKeyboardOnScreen = true
                if(Helper.getCurrentDevice() == .phone) {
                    rect.origin.y -= height;
                    rect.size.height += height;
                }
            
            }
        }
        else
        {
            // revert back to the normal state.
            viewModel.isKeyboardOnScreen = false
            if(Helper.getCurrentDevice() == .phone) {
            rect.origin.y += height;
            rect.size.height -= height;
            }
        }
        self.view.frame = rect;
        
        //[UIView commitAnimations];
        UIView.commitAnimations()
    }
    /*
     MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
