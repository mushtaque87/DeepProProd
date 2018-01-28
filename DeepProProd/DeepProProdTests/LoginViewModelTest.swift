//
//  LoginViewModelTest.swift
//  DeepProProdTests
//
//  Created by Mushtaque Ahmed on 1/24/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import XCTest
@testable import DeepProProd

class LoginViewModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
 func testSwitch_changesValue()
 {
    let loginVC =  LoginViewModel()
    let switchUI : UISwitch = UISwitch()
    switchUI.setOn(true, animated:false)
    loginVC.switchValueChanged(switchUI)
    XCTAssertEqual(Settings.sharedInstance.language, "Arabic")
    }
}
