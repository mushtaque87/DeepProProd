//
//  ContinueButton.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 4/29/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class ContinueButton: UIButton {

    var indexPath : IndexPath = IndexPath(row: 0, section: 0)
    
    required init(indexPath: IndexPath = IndexPath(row: 0, section: 0)) {
        self.indexPath = indexPath
        super.init(frame: .zero)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
