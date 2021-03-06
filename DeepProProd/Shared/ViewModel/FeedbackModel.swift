//
//  FeedbackModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/9/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import Foundation

class FeedbackModel: NSObject, UITableViewDelegate , UITableViewDataSource  {
    var feedback : String?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "feedback", for: indexPath) as! FeedbackTableViewCell
        if let feedback = feedback {
            cell.feedbackLabel.text = feedback
        }
        configureCells(for: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func configureCells(for cell:FeedbackTableViewCell) {
        cell.backView.backgroundColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)
    }
    
}
