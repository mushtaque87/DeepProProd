//
//  InfoTableViewCell.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/12/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    let backgroundLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        profileImageButton.layer.borderWidth = 2
        profileImageButton.layer.cornerRadius = 5
        profileImageButton.clipsToBounds = true
        
    }
    
    func setTheme() {
        print("setTheme")
        let colors = ThemeManager.sharedInstance.color
        // self.backgroundColor = UIColor.clear
        
        
        //self.detailsView.layer.removeFromSuperlayer()
        backgroundLayer.colors = [colors?.colorTop,colors?.colorBottom]
        
    }
    
    override func layoutIfNeeded() {
        print("layoutIfNeeded")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
        //setTheme()
        backgroundLayer.frame = self.contentView.bounds
        self.contentView.layer.insertSublayer(backgroundLayer, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
