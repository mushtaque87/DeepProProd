//
//  String.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 2/20/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
extension String
    
{
    func toDate(dateFormat format  : String =  "yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date!
    }
}
