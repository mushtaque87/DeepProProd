//
//  MyProfileView.swift
//  DeepProProdTests
//
//  Created by Mushtaque Ahmed on 3/5/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class MyProfileView: NibView {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var userType: UILabel!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // Circular Profile Pic
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = #colorLiteral(red: 0, green: 0.407166779, blue: 0.2167538702, alpha: 1).cgColor
    }
 

}
