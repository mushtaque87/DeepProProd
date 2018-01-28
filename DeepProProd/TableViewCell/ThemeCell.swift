//
//  ThemeCell.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/28/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell {


    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImage(forButtonWithTag tag:Int ,  withImage imageName: String)
    {
        if let button = self.contentView.viewWithTag(tag) as? UIButton {
            //Your code
            button.setBackgroundImage(UIImage(named: imageName), for: .normal)
        }
    }
    
}
