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
        
        setTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUnits(for: id!)
    }
    
    
    func setTheme() {
        let colors = ThemeManager.sharedInstance.color
        self.view.backgroundColor = UIColor.clear
        let backgroundLayer = colors?.gl
        backgroundLayer?.frame = view.frame
        self.view.layer.insertSublayer(backgroundLayer!, at: 0)
        // self.view.layoutSublayers(of: backgroundLayer!)
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
        }, onError: { error in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = error.localizedDescription
        }, onComplete: {
            hud.hide(animated: true)
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
