//
//  ServerIntegration.swift
//  DeepProProdTests
//
//  Created by Mushtaque Ahmed on 2/7/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import XCTest
@testable import DeepProProd

class ServerIntegrationTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_SuccessfulLogin()
    {
        let si = ServiceManager()
        si.trialLogin()
    }
}
