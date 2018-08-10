//
//  UnitTableViewCell.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 4/9/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class UnitTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var unitDetailLabel: UILabel!
    @IBOutlet weak var unitDescriptionLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var continueButton: ContinueButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
      
        // self.layer.borderColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!,alpha:1).cgColor
        //self.layer.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
