//
//  ReportCell.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/11/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell {

    
    
    @IBOutlet weak var character: UILabel!
    @IBOutlet weak var predicted: UILabel!
    @IBOutlet weak var actual: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
