//
//  SignUpViewModel.swift
//  DeepProProdTests
//
//  Created by Mushtaque Ahmed on 3/1/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import XCTest
@testable import DeepProProd

class SignUpViewModel: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
 
    func testSignUp_requestBodyCreatedSuccessfully()
    {
        let signUpViewModel =  SignupViewModel()
        let signUpRequest = signUpViewModel.createSignUpBody(firstname: "mushtaque", lastname: "ahmed", email: "m@a.com", password: "ahmed1987", age: "27", dob: "21/06/1987", gender: 0)
        
        let encoder = JSONEncoder()
        do {
        let jsondata = try encoder.encode(signUpRequest)
           
            let decoder = JSONDecoder()
            let requestparam  = try! decoder.decode(SignUpRequest.self, from: jsondata)
            XCTAssertEqual(requestparam.first_name, "mushtaque")
        } catch {
             
        }

     
        
    }
    
}
