//
//  NameTableViewCell.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/12/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell {

    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        
        textFieldOne.layer.borderColor = UIColor.white.cgColor
        textFieldOne.layer.borderWidth = 1
        textFieldOne.layer.masksToBounds = true
        textFieldOne.layer.cornerRadius = 5
        
        textFieldTwo.layer.borderColor = UIColor.white.cgColor
        textFieldTwo.layer.borderWidth = 1
        textFieldTwo.layer.masksToBounds = true
        textFieldTwo.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
