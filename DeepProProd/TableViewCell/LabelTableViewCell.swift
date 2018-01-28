//
//  LabelTableViewCell.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/16/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.alignText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
