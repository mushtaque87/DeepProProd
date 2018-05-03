//
//  Level_SHViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/10/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import MBProgressHUD

class Level_SHViewController: UIViewController, CategoriesProtocol {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet var viewModel: LevelViewModel!
    @IBOutlet weak var levelTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchCategories()
        self.levelTableView.register(UINib(nibName: "ChapterContentCell", bundle: nil), forCellReuseIdentifier: "content")
        viewModel.parentController = self
        viewModel.delegate = self
        levelTableView.backgroundColor = UIColor.clear
        self.navigationItem.title = "Courses"

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshUI()
    }

    
    func fetchCategories()
    {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Fetching assignments. Please wait"
        
        ServiceManager().getCategories(onSuccess: { assignmentlist in
            self.viewModel.categoriesList = assignmentlist
            self.levelTableView.reloadData()
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
    
    func showPracticesScreen(for categoryId:Int) {
        let practiceScreen = AssignmnetDasboardViewController(nibName:"AssignmnetDasboardViewController",bundle:nil)
        practiceScreen.viewModel.tasktype = .practice
        practiceScreen.viewModel.categoryId = categoryId
        self.navigationController?.pushViewController(practiceScreen, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func refreshUI() {
        backgroundImage.setBackGroundimage()
    }

}
