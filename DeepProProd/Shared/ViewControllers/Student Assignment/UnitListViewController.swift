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
    func showPronunciationScreen(with unitsArray:[FailableDecodable<Units>] , and index:Int)
}

class UnitListViewController: UIViewController,unitsProtocols {
 
    

    @IBOutlet weak var unitTableView: UITableView!
    @IBOutlet var viewModel: Assignments_UnitsModel!
    var assignmentId : Int?
    var tasktype : TaskType = .assignment
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.delegate = self
        self.unitTableView.register(UINib(nibName: "UnitTableViewCell", bundle: nil), forCellReuseIdentifier: "unitCell")
        self.navigationItem.title = "Units"
        unitTableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor(red: 112/255, green: 127/255, blue: 134/255, alpha: 0.9)
        
        switch tasktype {
        case .assignment:
            fetchAssignmentUnits()
            break
        default:
             fetchPracticeUnits()
            break
        }
            
        
    }
    
   func fetchAssignmentUnits()
   {
    
    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.mode = MBProgressHUDMode.indeterminate
    hud.label.text = "Fetching Units. Please wait"
    
    ServiceManager().getUnits(for:assignmentId! , of: UserDefaults.standard.string(forKey: "uid")!, onSuccess: { unitlist in
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
            
            ServiceManager().getUnitsForPractices(for:assignmentId!, of: UserDefaults.standard.string(forKey: "uid")!,
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
    
        
   func showPronunciationScreen(with unitsArray:[FailableDecodable<Units>] , and index:Int = 0)
    {
        
        let transDetailViewController: TransDetailViewController = TransDetailViewController(nibName: "TransDetailViewController", bundle: nil)
        var wordArray = Array<Word>()
        for text in unitsArray {
            wordArray.append(Word(word: (text.base?.question_text)!, id:text.base?.unit_id ,parentId:assignmentId , voice: "", voiceTime: nil))
        }
        //transDetailViewController.wordTextView.text = unitsArray[index].base?.question_text
        self.navigationController?.pushViewController(transDetailViewController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            transDetailViewController.vc_DataModel.wordArray = wordArray
            transDetailViewController.wordTextView.text = wordArray[index].word
            
        }

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
