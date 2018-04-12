//
//  AssignmnetDasboardViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/27/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit


protocol assignmentsProtocols: class {
    func showAssignmentDetailsScreen()
    func reloadtable()
}

class AssignmnetDasboardViewController: UIViewController,assignmentsProtocols  {
    @IBOutlet weak var assignmentListTableView: UITableView!
    @IBOutlet var viewModel: StudentAssignmentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignmentListTableView.register(UINib(nibName: "AssignmentTableViewCell", bundle: nil), forCellReuseIdentifier: "assignmentListCell")
        viewModel.delegate = self
       // viewModel.getAssignmnets()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Assignment Dashboard"
        assignmentListTableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor(red: 112/255, green: 127/255, blue: 134/255, alpha: 0.9)
    }

    override func viewDidAppear(_ animated: Bool) {
       // assignmentListTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAssignmentDetailsScreen() {
        let unitListViewController =     UnitListViewController(nibName: "UnitListViewController", bundle: nil)
        self.navigationController?.pushViewController(unitListViewController, animated: true)
    }
    
   func reloadtable()
   {
    assignmentListTableView.reloadData()
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
