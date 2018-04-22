//
//  AssignmnetDasboardViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/27/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import MBProgressHUD



protocol assignmentsProtocols: class {
    func showAssignmentDetailsScreen(for id:Int)
    func reloadtable()
}

class AssignmnetDasboardViewController: UIViewController,assignmentsProtocols  {
    @IBOutlet weak var assignmentListTableView: UITableView!
    @IBOutlet var viewModel: StudentAssignmentModel!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignmentListTableView.register(UINib(nibName: "AssignmentTableViewCell", bundle: nil), forCellReuseIdentifier: "assignmentListCell")
        viewModel.delegate = self
       // viewModel.getAssignmnets()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Assignment Dashboard"
        assignmentListTableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor(red: 112/255, green: 127/255, blue: 134/255, alpha: 0.9)
        self.assignmentListTableView.addSubview(self.refreshControl)
        
        fetchAssignments()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
       // assignmentListTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchAssignments()
    {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Fetching assignments. Please wait"
        
        ServiceManager().getassignments(for: UserDefaults.standard.string(forKey: "uid")! , onSuccess: { assignmentlist in
            self.viewModel.assignmnetList = assignmentlist
            self.viewModel.sortAssignmentByDueDate()
            self.viewModel.fetchUniqueDates()
            for section in self.viewModel.sectionHeaders{
                self.viewModel.assignmentsForSection.updateValue(self.viewModel.fetchListOfAssignmentsForDate(for: section), forKey: section)
            }
            self.assignmentListTableView.reloadData()
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
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchAssignments()
        refreshControl.endRefreshing()
    }
    func showAssignmentDetailsScreen(for id:Int) {
        
        let unitListViewController =     UnitListViewController(nibName: "UnitListViewController", bundle: nil)
        unitListViewController.assignmentId = id
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
