//
//  AssignmentDetailViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/27/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class UnitListViewController: UIViewController {

    @IBOutlet weak var unitTableView: UITableView!
    @IBOutlet var viewModel: AssignmentsUnitsModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
          self.unitTableView.register(UINib(nibName: "UnitTableViewCell", bundle: nil), forCellReuseIdentifier: "unitCell")
        self.navigationItem.title = "unit List"
        unitTableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor(red: 112/255, green: 127/255, blue: 134/255, alpha: 0.9)
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
