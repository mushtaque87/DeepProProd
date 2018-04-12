//
//  Assignments.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/26/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation

struct FailableDecodable<Base : Decodable> : Decodable {
    
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
