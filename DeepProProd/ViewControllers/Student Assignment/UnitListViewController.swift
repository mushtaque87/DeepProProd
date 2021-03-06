//
//  AssignmentDetailViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/27/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol unitsProtocols: class {
    func showPronunciationScreen(with unitsArray:[FailableDecodable<ContentUnits>] , and index:Int)
    func submitAssignment()
}

class UnitListViewController: UIViewController,unitsProtocols {
 
    

    @IBOutlet weak var unitTableView: UITableView!
    @IBOutlet var viewModel : Assignments_UnitsModel!
    var id : Int?
    var tasktype : TaskType = .content
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.delegate = self
        self.unitTableView.register(UINib(nibName: "UnitTableViewCell", bundle: nil), forCellReuseIdentifier: "unitCell")
        self.unitTableView.register(UINib(nibName: "LogOutCell", bundle: nil), forCellReuseIdentifier: "logout")
        self.navigationItem.title = "Units"
        unitTableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.white //UIColor(red: 112/255, green: 127/255, blue: 134/255, alpha: 0.9)
        
        /*
        switch tasktype {
        case .assignment:
            fetchAssignmentUnits()
            break
        default:
            fetchPracticeUnits()
            break
        }
        */
        
       // setTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       //setTheme()
        //viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUnits(for: id!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTheme()
    }
    
    func setTheme() {
        /* let colors = ThemeManager.sharedInstance.color
       self.view.backgroundColor = UIColor.clear
        let backgroundLayer = colors?.gl
        backgroundLayer?.frame = self.view.bounds
        self.view.layer.insertSublayer(backgroundLayer!, at: 0)*/
        self.navigationController?.navigationBar.tintColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.navigationbar_tintColor!)
        
       // self.view.backgroundColor = UIColor.hexStringToUIColor(hex:  ThemeManager.sharedInstance.backgroundColor_Light!)
        
       // self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.font_Color!)]
        
        // self.view.layoutSublayers(of: backgroundLayer!)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //  let navcolor = colors?.copy() as! Colors
         let colors = ThemeManager.sharedInstance.color
         let navgradient = CAGradientLayer()
        //let navgradient = ThemeManager.sharedInstance.color?.gl
        // let barlayer = navcolors.gl
         navgradient.colors = [colors?.colorTop,colors?.colorBottom]
        navgradient.frame = CGRect(x: 0, y:0, width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!)
        // (self.navigationController?.navigationBar.bounds)!
        self.navigationController?.view.layer.insertSublayer(navgradient, at: 1)
        
        
    }
    
    
    /*
   func fetchAssignmentUnits()
   {
    
    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.label.text = "Fetching Units. Please wait"
    
    ServiceManager().getAssignmentsUnits(for:assignmentId! , of: UserDefaults.standard.string(forKey: "uid")!, onSuccess: { unitlist in
        hud.hide(animated: true)
        self.viewModel.unitList = unitlist
        self.unitTableView.reloadData()
        
    }, onHTTPError: { httperror in
        hud.mode = MBProgressHUDMode.text
        hud.label.text = httperror.description
    }, onError: { error in
        hud.mode = MBProgressHUDMode.text
        hud.label.text = error.localizedDescription
    }, onComplete: {
        hud.hide(animated: true)
    })
    
    }
        
        
        func fetchPracticeUnits(){
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.label.text = "Fetching Units. Please wait"
            
            ServiceManager().getPracticesUnits(for:assignmentId!, of: UserDefaults.standard.string(forKey: "uid")!,
                onSuccess: { unitlist in
                hud.hide(animated: true)
                self.viewModel.unitList = unitlist
                self.unitTableView.reloadData()
                
            }, onHTTPError: { httperror in
                hud.mode = MBProgressHUDMode.text
                hud.label.text = httperror.description
            }, onError: { error in
                hud.mode = MBProgressHUDMode.text
                hud.label.text = error.localizedDescription
            }, onComplete: {
                hud.hide(animated: true)
            })
            
        }
 
 */
    func fetchUnits(for id:Int){
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Fetching assignments. Please wait"
        
        ServiceManager().getContentUnit(for: id, ofStudent: UserDefaults.standard.string(forKey: "uid")! , onSuccess: { unitList in
            //self.viewModel.categoriesList = assignmentlist
            //Show Units Screen
            self.viewModel.unitList = unitList
            self.unitTableView.reloadData()
            //self.showUnitScreen(with: unitList)
            // self.levelTableView.reloadData()
            hud.hide(animated: true)
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
    
    
   func showPronunciationScreen(with unitsArray:[FailableDecodable<ContentUnits>] , and index:Int = 0)
    {
        
       
        let practiceBoardVC = PracticeBoardViewController(nibName:"PracticeBoardViewController",bundle:nil)
        practiceBoardVC.unitIndex = index
        practiceBoardVC.tasktype = self.tasktype
       
        /*
        if let assignmentId = self.assignmentId {
        practiceBoardVC.assignmentId = assignmentId
        }
         */
        
        
        for units in self.viewModel.unitList {
            if let base = units.base{
            practiceBoardVC.viewModel.unitList.append(base)
            }
        }
        self.navigationController?.pushViewController(practiceBoardVC, animated: true)
 
        
        
        
 
        
        /*
        let transDetailViewController: TransDetailViewController = TransDetailViewController(nibName: "TransDetailViewController", bundle: nil)
        var wordArray = Array<Word>()
        for text in unitsArray {
            wordArray.append(Word(word: (text.base?.question_text)!, id:text.base?.unit_id ,parentId:assignmentId , voice: "", voiceTime: nil))
        }
        transDetailViewController.boardType = .account
        //transDetailViewController.wordTextView.text = unitsArray[index].base?.question_text
        self.navigationController?.pushViewController(transDetailViewController, animated: true)
 
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            transDetailViewController.vc_DataModel.wordArray = wordArray
            transDetailViewController.vc_DataModel.wordIndex = index
            transDetailViewController.wordTextView.text = wordArray[index].word
            transDetailViewController.refreshUI()
        }
       */
        

    }

   @objc func submitAssignment() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Submitting Content. Please wait"
        
    ServiceManager().updateAssignmentStatus(for: self.id!, of: UserDefaults.standard.string(forKey: "uid")!, with: "SUBMITTED", onSuccess: { response in
             hud.hide(animated: true)
        }, onHTTPError: { httperror in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = httperror.description
        }, onError: { error in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = error.localizedDescription
        }, onComplete: {
             hud.hide(animated: true)
        })
    }
    func DLog(message: String, function: String = #function) {
        #if DEBUG
            print("\(function): \(message)")
        #endif
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
