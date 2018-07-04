//
//  Protocols.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 4/23/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation


protocol CategoriesProtocol: class {
   //func showPracticesScreen(for category:RootContent)
    //func fetchContentGroup(for content:ContentGroup)
     func fetchContentGroup(for content:ContentGroup , actionType:CrumActionType)
}
