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
import RxCocoa



class ProfileViewController: UIViewController, ProfileViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
    

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var myProfileView: MyProfileView!
    
    @IBOutlet weak var profileButton: UIButton!
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
    
   
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
       
       Helper.lockOrientation(.portrait)
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(controlKeyboard(sender:)))
        singleTapGesture.numberOfTapsRequired = 1
        //self.view.addGestureRecognizer(singleTapGesture)
        
        configureEditOptions(with: viewModel.isEditEnabled)
        viewModel.delegate = self
        
       // firstNameField.delegate = viewModel
       // lastNameField.delegate = viewModel
        
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveProfile(_:)))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: "#EFEFF4")
       //_ = viewModel.isEnable.bind(to: navigationItem.rightBarButtonItem?.rx.isEnabled)
        
       // self.view.backgroundColor = UIColor.white
            //UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        
       // var viewArray : Array = (Bundle.main.loadNibNamed("MyProfileView", owner: self, options: nil))!
       //let tempProfileView = MyProfileView().loadNib() as! MyProfileView
        //self.view.addSubview(viewArray[0] as! UIView)
        //view.addSubview(tempProfileView)
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "My Account"
    
        self.navigationController?.navigationBar.tintColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.navigationbar_tintColor!)
//        profileButton.layer.borderColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9).cgColor
//        profileButton.layer.borderWidth = 2
//        profileButton.layer.cornerRadius = profileButton.frame.size.width/2
//        profileButton.clipsToBounds = true
        
        
//        self.view.layer.borderColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9).cgColor
//        self.view.layer.borderWidth = 4
        //self.view.layer.cornerRadius = 55
        self.detailsTable.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        self.detailsTable.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "details")
        self.detailsTable.delegate = viewModel
        self.detailsTable.dataSource = viewModel
        self.detailsTable.backgroundColor = UIColor.clear
        

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardDidShow, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name:NSNotification.Name.UIKeyboardDidHide, object: nil);

        
        guard viewModel.screenType == .edit else {
            return
            
        }
        
        //self.viewModel.details = Profile(first_name: "Mush", last_name: "ahmed" ,email:"email.com", user_attributes: User_attributes(dob: "21-06-1987"))
       // return
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Fetching Profile. Please wait."
        
        ServiceManager().getProfile(for: UserDefaults.standard.string(forKey: "uid")! , onSuccess: { response in
           // self.firstNameField.text = response.first_name
           // self.lastNameField.text = response.last_name
           // self.emailField.text = response.email
            self.viewModel.details = Profile(first_name: response.first_name!, last_name: response.last_name!,email: response.email!, user_attributes: User_attributes(dob: (response.user_attributes?.dob)!))
            self.detailsTable.reloadData()
            //self.dobField.text = response.user_attributes?.dob
            hud.hide(animated: true)
        }, onHTTPError: { httperror in
            hud.hide(animated: true)
            hud.hide(animated: true, afterDelay: 1.5)
        }, onError: { Error in
            hud.hide(animated: true)
            hud.hide(animated: true, afterDelay: 1.5)
        })
    }

    override func viewDidAppear(_ animated: Bool) {
       self.detailsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - UI Action and Events

    @IBAction func saveProfile(_ sender: Any) {
        /*
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
         
         */
        shouldEnableSaveButton(enable: false)
        detailsTable.reloadData()
        
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Saving Profile. Please wait."
        //var dob : String?
        // if let cell : DetailCell = self.detailsTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? DetailCell {
        //     dob =  cell.valueTextField.text
        // }
        
        let profile = Profile(first_name: viewModel.details!.first_name!, last_name: viewModel.details!.last_name!, email: viewModel.details!.email!, user_attributes: User_attributes(dob:(viewModel.details?.user_attributes?.dob)!))
        
        
        ServiceManager().updateProfile(for: UserDefaults.standard.string(forKey: "uid")! , with:profile,  onSuccess: {
            hud.hide(animated: true)
        }, onHTTPError: { httperror in
            hud.hide(animated: true)
            hud.hide(animated: true, afterDelay: 1.5)
        }, onError: { Error in
            hud.hide(animated: true)
            hud.hide(animated: true, afterDelay: 1.5)
        })
        
        //}
    }
    
    func configureEditOptions(with editStatus: Bool) {
        //firstNameField.isEnabled = editStatus
        //lastNameField.isEnabled = editStatus
        
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
    
    @objc func editProfilePic() {
        
        //        guard viewModel.isEditEnabled == true else {
        //            return
        //        }
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            self.pickImage(from: true)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Choose Exisiting Photo", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            self.pickImage(from: false)
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
        }))
        if(Helper.getCurrentDevice() == .pad) {
            if let popoverController = actionsheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.permittedArrowDirections = []
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }
        }
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    func pickImage(from camera:Bool){
        shouldEnableSaveButton(enable: true)
        if(camera) {
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerControllerSourceType.camera
                picker.cameraDevice = .front
                picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: picker.sourceType)!
                //var mediaTypes: Array<AnyObject> = [kUTTypeImage]
                // picker.mediaTypes = mediaTypes
                picker.modalPresentationStyle = .custom;
                // picker.showsCameraControls = true
                // picker.isNavigationBarHidden = false
                // picker.isToolbarHidden = false
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
                
            }
            else{
                NSLog("No Camera.")
            }
        } else {
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: picker.sourceType)!
                //var mediaTypes: Array<AnyObject> = [kUTTypeImage]
                // picker.mediaTypes = mediaTypes
                picker.modalPresentationStyle = .custom;
                // picker.showsCameraControls = true
                // picker.isNavigationBarHidden = false
                // picker.isToolbarHidden = false
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            } else {
                NSLog("No Gallery.")
            }
        }
        
    }
    
    
    //MARK: - Keyboard Notification
    
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
        //moveTextField(up: false, by: keyboardFrame.height)
        
    }
    
    func shouldEnableSaveButton(enable:Bool){
        self.navigationItem.rightBarButtonItem?.isEnabled = enable
    }
    
    
     //MARK: - View Controller Delegates
     //#define kOFFSET_FOR_KEYBOARD 80.0

    func moveTextField(up movedUp: Bool ,by height:CGFloat) {
        //detailsTable.setContentOffset(CGPoint(x: 0, y: textField.center.y - 160), animated: true)
        //[UIView beginAnimations:nil context:NULL];
        //[UIView setAnimationDuration:0.3]; // if you want to slide up the view
        if (movedUp)
        {
        var contentInset:UIEdgeInsets = self.detailsTable.contentInset
        contentInset.bottom = height
        detailsTable.contentInset = contentInset
        } else {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        detailsTable.contentInset = contentInset
        }
        return
        
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
    
    func showEditInfoScreen(for detailType:EditProfileType) {
       
        //        guard viewModel.isEditEnabled == true else {
        //            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //            hud.mode = MBProgressHUDMode.text
        //            hud.label.text = "Please click Edit button to edit details."
        //            hud.hide(animated: true, afterDelay: 1.5)
        //            return
        //        }
        shouldEnableSaveButton(enable: true)
        let profileSelectionTableViewController =     ProfileSelectionTableViewController(nibName: "ProfileSelectionTableViewController", bundle: nil)
        profileSelectionTableViewController.editProfileType = detailType
        profileSelectionTableViewController.details = Profile(first_name: viewModel.details?.first_name, last_name: viewModel.details?.last_name, email: viewModel.details?.email, user_attributes: User_attributes(dob: viewModel.details?.user_attributes?.dob))
        profileSelectionTableViewController.details?.gender = viewModel.details?.gender
        profileSelectionTableViewController.details?.standard = viewModel.details?.standard
        profileSelectionTableViewController.details?.section = viewModel.details?.section
        profileSelectionTableViewController.delegate = self
        self.navigationController?.pushViewController(profileSelectionTableViewController, animated: true)
        
    }
    
    /*
    func showEditNameScreen() {
        
//        guard viewModel.isEditEnabled == true else {
//            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud.mode = MBProgressHUDMode.text
//            hud.label.text = "Please click Edit button to edit details."
//            hud.hide(animated: true, afterDelay: 1.5)
//            return
//        }
        
        let profileSelectionTableViewController =     ProfileSelectionTableViewController(nibName: "ProfileSelectionTableViewController", bundle: nil)
        profileSelectionTableViewController.editProfileType = .name
        profileSelectionTableViewController.details = Profile(first_name: (viewModel.details?.first_name)!, last_name: (viewModel.details?.last_name)!, email: (viewModel.details?.email)!, user_attributes: User_attributes(dob: (viewModel.details?.user_attributes?.dob)!))
        profileSelectionTableViewController.delegate = self
        self.navigationController?.pushViewController(profileSelectionTableViewController, animated: true)
        
    }
    
    func showEditGenderScreen() {
        
//        guard viewModel.isEditEnabled == true else {
//            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud.mode = MBProgressHUDMode.text
//            hud.label.text = "Please click Edit button to edit details."
//            hud.hide(animated: true, afterDelay: 1.5)
//            return
//        }
        
        
        let profileSelectionTableViewController =     ProfileSelectionTableViewController(nibName: "ProfileSelectionTableViewController", bundle: nil)
        profileSelectionTableViewController.editProfileType = .gender
         profileSelectionTableViewController.details = Profile(first_name: (viewModel.details?.first_name)!, last_name: (viewModel.details?.last_name)!, email: (viewModel.details?.email)!, user_attributes: User_attributes(dob: (viewModel.details?.user_attributes?.dob)!))
        profileSelectionTableViewController.delegate = self
        self.navigationController?.pushViewController(profileSelectionTableViewController, animated: true)
    }
    
    func showEditStandardScreen() {
        
//        guard viewModel.isEditEnabled == true else {
//            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud.mode = MBProgressHUDMode.text
//            hud.label.text = "Please click Edit button to edit details."
//            hud.hide(animated: true, afterDelay: 1.5)
//            return
//        }
        
        let profileSelectionTableViewController =     ProfileSelectionTableViewController(nibName: "ProfileSelectionTableViewController", bundle: nil)
        profileSelectionTableViewController.editProfileType = .standard
        profileSelectionTableViewController.details = Profile(first_name: (viewModel.details?.first_name)!, last_name: (viewModel.details?.last_name)!, email: (viewModel.details?.email)!, user_attributes: User_attributes(dob: (viewModel.details?.user_attributes?.dob)!))

        profileSelectionTableViewController.delegate = self
        self.navigationController?.pushViewController(profileSelectionTableViewController, animated: true)
    }
    */
    
    func saveEditedDetails(for editType: EditProfileType, with details:Profile) {
        viewModel.details = details
        self.detailsTable.reloadData()
    }
    
    
    
   
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        self.dismiss(animated: true, completion: { () -> Void in
//            
//        })
        
        //profileButton.setImage(image, for: .normal)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            self.viewModel.details?.profile_image = info["UIImagePickerControllerOriginalImage"] as? UIImage
            self.detailsTable.reloadData()
//            self.profileButton.setImage((info["UIImagePickerControllerOriginalImage"] as! UIImage), for: .normal)
//
       })
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: {() -> Void in
            
                })
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
