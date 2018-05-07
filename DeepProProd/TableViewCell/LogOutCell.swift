//
//  LogOutCell.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/16/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class LogOutCell: UITableViewCell {

    @IBOutlet weak var logOut: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
