//
//  DetailCell.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 7/3/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    //let backgroundLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //backView.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        //self.backgroundColor =  UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        //self.contentView.backgroundColor = UIColor.clear
        valueTextField.isEnabled = false
        
    }
    
    func setTheme() {
        print("setTheme")
        ThemeManager.sharedInstance.setGradientLayer(with: false)
        let colors = ThemeManager.sharedInstance.color?.copy() as! Colors
        // self.backgroundColor = UIColor.clear
        //self.detailsView.layer.removeFromSuperlayer()
       // backgroundLayer.colors = [colors?.colorTop,colors?.colorBottom]
        let backgroundLayer = colors.gl
        backgroundLayer.frame = self.bounds
        self.layer.insertSublayer(backgroundLayer, at: 0)

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
//        backgroundLayer.frame = self.bounds
//        self.layer.insertSublayer(backgroundLayer, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
