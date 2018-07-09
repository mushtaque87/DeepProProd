//
//  FeedbackTableViewCell.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/9/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {

   
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
       // backView.frame = CGRect(x: 5, y: 0, width: self.frame.width, height: self.frame.height - 5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
