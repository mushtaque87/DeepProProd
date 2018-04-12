//
//  AssignmentTableViewCell.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/26/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var assignmentName: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var submissionDate: UILabel!
    @IBOutlet weak var assignmentStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
