//
//  Date.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 2/20/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
extension Date
    
{
    //"yyyy-MM-dd HH:mm:ss"
    func toString( dateFormat format  : String = "yyyy-MM-dd HH:mm:ss") -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
   
}
