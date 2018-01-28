//
//  LanguageTableViewCell.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/16/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var titlLbl: UILabel!
    @IBOutlet weak var languageSwitch: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titlLbl.alignText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
 
    
}
