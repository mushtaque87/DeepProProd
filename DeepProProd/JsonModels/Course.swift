//
//  Course.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/23/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation

enum LevelNames : String, Codable {
    case Basic
    case Intermediate
    case Advanced
    // ...
}

struct LevelList: Codable {
    
    struct Levels: Codable {
        let levelname: LevelNames
        let chapters: [Chapters]
        
        struct Chapters : Codable{
            let name: String
            let isLocked: Bool
            let completedPercentage: Int?
        }
    }
    let levels : [Levels]

}


