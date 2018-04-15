//
//  ServerIntegration.swift
//  DeepProProdTests
//
//  Created by Mushtaque Ahmed on 2/7/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import XCTest
import Mockingjay
import Quick
import Nimble

@testable import DeepProProd

class ServerIntegrationTest: QuickSpec {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    override func spec() {
        super.spec()
        let email = TokenManager.shared.currentDateTime().toString(dateFormat: "ddMMYYHHmmss")+"@gmail.com"
        let password = "123"
        var details = LoginResponse(uid: "", access_token: "", refresh_token: "", expires_in: 0, refresh_expires_in: 0)
        
        print("username : \(email) \n password : \(password)")
        describe("1_SignUpApi") {
            context("success") {
                it("returns response") {
                    let signUpmodel = SignupViewModel()
                    var serverResponse: SignUpResponse?
                    ServiceManager().doSignUp(withBody:signUpmodel.createSignUpBody(firstname: "Mushtaque", lastname: "Ahmed", email: email , password: password , age: "21-06-1987", dob: "21-06-1987", gender: 0),
                                              onSuccess: { response in
                                                serverResponse = response
                                                details.uid = response.uid
                    }, onHTTPError: { httperror in
                        
                    }, onError: { error  in
                        
                    }, onComplete: {
                        
                    })
                    expect(serverResponse).toEventuallyNot(beNil(), timeout: 4)
                    //expect(serverResponse?.uid) == "123123123123"
                }
            }
        }
        
        
        describe("2_LoginApi") {
            context("success") {
                it("returns response") {
                    
                    var serverResponse: LoginResponse?
                    ServiceManager().doLogin(for: email , and: password , onSuccess: { response in
                        // XCTAssertEqual(response.uid, "123123123123")
                        
                        serverResponse = response
                        details.uid = response.uid
                        print("UID \((details.uid))")
                    }, onHTTPError: { httperror in
                        //XCTFail(httperror.description)
                    }, onError: { error in
                        // XCTFail(error.localizedDescription)
                    },  onComplete:   {
                        
                    })
                    expect(serverResponse).toEventuallyNot(beNil(), timeout: 2)
                    expect(serverResponse?.uid).toEventuallyNot(beNil(), timeout: 2)
                    
                }
                    
                    context("error") {
                        it("returns error") {
                            
                        }
                }
            }
        }
        
       
       /*
        describe("3_ForgotPasswordApi") {
            context("success") {
                it("returns response") {
                    
                    var serverResponse: ForgotPasswordResponse?
                    ServiceManager().forgotPassword(for: "", onSuccess: { response in
                        serverResponse = response
                    }, onHTTPError: { httperror in
                        
                    }, onError: { error in
                        
                    }, onComplete: {
                        
                    })
                    expect(serverResponse).toEventuallyNot(beNil(), timeout: 2)
                    expect(serverResponse?.success) == true
                    
                }
            }
        }
        */
        
        
        describe("4_Test_ProfileApi") {
            context("success") {
                it("returns response") {
                    var serverResponse: Profile?
                    ServiceManager().getProfile(for: details.uid , onSuccess: {response in
                        serverResponse = response 
                    }, onHTTPError: { httperror in
                        
                    }, onError: { error in
                        
                    })
                    expect(serverResponse).toEventuallyNot(beNil(), timeout: 10)
                    expect(serverResponse?.email) == email
                    expect(serverResponse?.first_name) == "Mushtaque"
                    expect(serverResponse?.last_name) == "Ahmed"

                }
            }
        }
        
    }
    
    /*
    func test_SuccessfulLogin()
    {
        
        it("returns server response") {
            var returnedUserData: LoginResponse?
            
                
                ServiceManager().doLogin(for: "mushtaque@gmail.com", and: "123", onSuccess: { response  in
                   // XCTAssertEqual(response.uid, "123123123123")
                    returnedUserData = response
                }, onHTTPError: { httperror in
                    //XCTFail(httperror.description)
                }, onError: { error in
                    // XCTFail(error.localizedDescription)
                },  onComplete:   {
                    
                })

                
                expect(returnedUserData).toEventuallyNot(beNil(), timeout: 20)
                
            }
        }
// waitForExpectations(timeout: 15, handler: nil)
 */
    
}
