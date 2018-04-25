//
//  Protocols.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 4/23/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation


@objc protocol CategoriesProtocol: class {
  @objc optional func showPracticesScreen(for categoryId:Int)
  @objc optional  func reloadtable()
}
