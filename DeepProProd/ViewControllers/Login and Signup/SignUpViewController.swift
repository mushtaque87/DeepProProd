//
//  SignUpViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/12/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import RxSwift
import MBProgressHUD
class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate , SignUpViewDelegate{
    
    

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet var viewModel: SignupViewModel!
    @IBOutlet weak var detailsTableView: UITableView!
    
    //RxSwift
    private var userinfo = Variable(user())
    var userObserver:Observable<user> {
        return userinfo.asObservable()
    }
    let disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Helper.getCurrentDevice() == .phone) {
            Helper.lockOrientation(.portrait)
        } 
        refreshUI()
        self.navigationItem.title = "Sign Up"
        //_ =  ageTxtField.rx.text.map {$0 ?? ""}.bind(to:viewModel.dob)

            viewModel.dobObserver.subscribe(onNext: { [weak self] details in
                print("Dob : \(details)")
                //self?.login(nil)
            }).disposed(by: disposeBag)
        viewModel.delegate = self
         Helper.lockOrientation(.portrait)
        //self.backgroundImage.isHidden = true
        self.view.backgroundColor = UIColor.white
        
        
        self.detailsTableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "details")
        self.detailsTableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "labelCell")
        self.detailsTableView.delegate = viewModel
        self.detailsTableView.dataSource = viewModel
        self.detailsTableView.backgroundColor = UIColor.clear
        
       // profileImageButton.layer.borderColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9).cgColor
        profileImageButton.layer.borderColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9).cgColor
        profileImageButton.layer.borderWidth = 2
        profileImageButton.layer.cornerRadius = profileImageButton.frame.size.width/2
        profileImageButton.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardDidShow, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name:NSNotification.Name.UIKeyboardDidHide, object: nil);


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    //MARK: - Actions and Events
    
    @IBAction func editProfilePic(_ sender: Any) {
        
        guard viewModel.isEditEnabled == true else {
            return
        }
        
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

  
    @IBAction func close(_ sender: Any) {
       self.dismiss(animated: true) {
            print("Dismmised")
        }
    }
    
    // Do any additional setup after loading the view.
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
        guard ((viewModel.currentTextField?.tag) != SignUpDetails.dob.rawValue) else {
            return
        }
        
        if (movedUp)
        {
            var contentInset:UIEdgeInsets = self.detailsTableView.contentInset
            contentInset.bottom = height
            detailsTableView.contentInset = contentInset
        } else {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            detailsTableView.contentInset = contentInset
        }
        return
            
            UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        var rect = self.view.frame;
        if (movedUp)
        {
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            if  (self.view.frame.origin.y >= 0)
            {
                //viewModel.isKeyboardOnScreen = true
                if(Helper.getCurrentDevice() == .phone) {
                    rect.origin.y -= height;
                    rect.size.height += height;
                }
                
            }
        }
        else
        {
            // revert back to the normal state.
            //viewModel.isKeyboardOnScreen = false
            if(Helper.getCurrentDevice() == .phone) {
                rect.origin.y += height;
                rect.size.height -= height;
            }
        }
        self.view.frame = rect;
        
        //[UIView commitAnimations];
        UIView.commitAnimations()
    }
    
    //MARK: - Picker View Delegates
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        //        self.dismiss(animated: true, completion: { () -> Void in
        //
        //        })
        
        profileImageButton.setImage(image, for: .normal)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            self.profileImageButton.setImage((info["UIImagePickerControllerOriginalImage"] as! UIImage), for: .normal)
            
        })
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    
    //MARK: - Network Calls
    func signUp() {
       
        //RxSwift
        //self.userinfo.value = user(username: self.emailTxtField.text!, password: self.passordTextField.text!)
        //return

        if(isDetailsFilled())
        {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.label.text = "Signing up. Please wait"
            
           
          let  requestBody = viewModel.createSignUpBody(firstname: viewModel.details.firstname!, lastname: viewModel.details.lastname!, email: viewModel.details.email!, password: viewModel.details.password!,  dob: viewModel.details.dob!, gender: viewModel.details.gender!)
            
            ServiceManager().doSignUp(withBody: requestBody, onSuccess: { result in
                //self.clearData()
                hud.mode = MBProgressHUDMode.text
                hud.label.text = "Account created ! Please Login now."
            } , onHTTPError: { httperror in
                hud.mode = MBProgressHUDMode.text
                hud.label.text = httperror.description
                hud.hide(animated: true, afterDelay: 1.5)
            }, onError: { error in
                hud.mode = MBProgressHUDMode.text
                hud.label.text = error.localizedDescription
                hud.hide(animated: true, afterDelay: 1.5)
            })
        }
        
        print("end of signup")
    }
   
    //MARK:- View Controller Delegates
    
    func showEditInfoScreen(for detailType:EditProfileType) {
        
        //        guard viewModel.isEditEnabled == true else {
        //            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //            hud.mode = MBProgressHUDMode.text
        //            hud.label.text = "Please click Edit button to edit details."
        //            hud.hide(animated: true, afterDelay: 1.5)
        //            return
        //        }
        
        let profileSelectionTableViewController =     ProfileSelectionTableViewController(nibName: "ProfileSelectionTableViewController", bundle: nil)
        profileSelectionTableViewController.editProfileType = detailType
        profileSelectionTableViewController.editProfileScreenType = .signUp
        profileSelectionTableViewController.signUpDetails = viewModel.details
        profileSelectionTableViewController.signUpDelegate = self
        self.navigationController?.pushViewController(profileSelectionTableViewController, animated: true)
        //self.present(profileSelectionTableViewController, animated: true, completion: nil)
        
        
    }
    
    //    func saveEditedDetails(for editType: EditProfileType, with details:Profile) {
    //      //  viewModel.details = details
    //
    //    }
    
    func saveEditedDetails(for editType: EditProfileType, with details: SignUpData) {
        self.detailsTableView.reloadData()
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
        
        //backgroundImage.setBackGroundimage()
        
        //loginTitleLbl.alignText()
        
    }
    
    /*
    func clearData()
    {
        self.firstNameTxtField.text = ""
        self.lastNameTxtField.text = ""
        self.emailTxtField.text = ""
        self.passordTextField.text = ""
        self.confirmPasswordTxtField.text = ""
        self.ageTxtField.text = ""
        
    }
    */
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
  
    func isDetailsFilled() -> Bool {
        
        guard viewModel.details.password != nil && viewModel.details.password?.count != 0 &&
            viewModel.details.confirmpassword != nil && viewModel.details.confirmpassword?.count != 0 &&
            viewModel.details.email != nil && viewModel.details.email?.count != 0 &&
            viewModel.details.firstname != nil && viewModel.details.firstname?.count != 0 &&
            viewModel.details.lastname != nil && viewModel.details.lastname?.count != 0
            else {
                if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
                {
                    /*
                    let alert = UIAlertController(title: "Warning", message:"All the Details are not filled properly" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    rootVc.present(alert, animated: true, completion: nil)
                     */
                    
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.mode = .text
                    hud.label.text = "Please insert correct details."
                    hud.hide(animated: true, afterDelay: 1.5)
//                    let infoView = InfoView.init(frame: self.view.bounds);
//                    hud.customView = infoView
//                    hud.customView?.bringSubview(toFront: infoView)
//                    hud.show(animated: true)
                    
                }
            return false
        }
        
        guard viewModel.details.password == viewModel.details.confirmpassword else {
            
            /*
            if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
            {
                let alert = UIAlertController(title: "Warning", message:"password and confirm password field are not same" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                rootVc.present(alert, animated: true, completion: nil)
                
            }*/
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.label.text = "Password and Confirm password field are not same"
            hud.hide(animated: true, afterDelay: 1.5)
            return false
        }
        
        return true
    }
 
    
}
