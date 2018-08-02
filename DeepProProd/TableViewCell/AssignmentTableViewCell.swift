//
//  AssignmentTableViewCell.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/26/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var assignmentName: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var submissionDate: UILabel!
    @IBOutlet weak var assignmentStatus: UILabel!
    @IBOutlet weak var continueButton: ContinueButton!
    @IBOutlet weak var unitCount: UILabel!
    let backgroundLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.backgroundColor = UIColor.clear
        
        print("awakeFromNib")
        //setTheme()
    }

    func setTheme() {
        print("setTheme")
        let colors = ThemeManager.sharedInstance.color
       // self.backgroundColor = UIColor.clear
        
        
        //self.detailsView.layer.removeFromSuperlayer()
        backgroundLayer.colors = [colors?.colorTop,colors?.colorBottom]
        
    }
    override func didMoveToSuperview() {
        print("didMoveToSuperview")
    }
    override func setNeedsUpdateConstraints() {
        print("setNeedsUpdateConstraints")
    }
    
    override func updateConstraintsIfNeeded() {
        print("updateConstraintsIfNeeded")
    }
        
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutIfNeeded() {
        print("layoutIfNeeded")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
        
        /*setTheme()
        self.detailsView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.detailsView.frame.height)
        backgroundLayer.frame = self.detailsView.frame
        self.detailsView.layer.insertSublayer(backgroundLayer, at: 0)
         */
    }
    
    
    
    override func draw(_ rect: CGRect) {
        print("draw")
        //setTheme()
    }
    
}
