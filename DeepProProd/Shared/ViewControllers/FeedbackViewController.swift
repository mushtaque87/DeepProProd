//
//  FeedbackViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/9/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var feedbackTableView: UITableView!
    lazy var viewModel =  FeedbackModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.feedbackTableView.register(UINib(nibName: "FeedbackTableViewCell", bundle: nil), forCellReuseIdentifier: "feedback")
        self.feedbackTableView.delegate = viewModel
        self.feedbackTableView.dataSource = viewModel
        self.feedbackTableView.backgroundColor = UIColor.white
        self.navigationItem.title = "Feedback"
        // Do any additional setup after loading the view.
    }

    func getFeedbacksForUnit() {
        
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
