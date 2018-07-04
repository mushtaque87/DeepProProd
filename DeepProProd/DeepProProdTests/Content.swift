//
//  Content.swift
//  DeepProProdTests
//
//  Created by Mushtaque Ahmed on 6/4/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import XCTest
@testable import DeepProProd

class Content: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetContent_RetreivedSuccessfully() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var responseModel: [FailableDecodable<RootContent>]!
        do {
            let filePath = Bundle.main.url(forResource: "getContent", withExtension: "txt")
            let data: Data = try Data.init(contentsOf: filePath!)
            
            
            responseModel =  try JSONDecoder()
                .decode([FailableDecodable<RootContent>].self, from: data)
            
            
            print(responseModel)
        }
        catch  {
            print("decoding failed with error=\(error)")
            
        }
        
        // print(type(of: responseModel))
        XCTAssertEqual(responseModel[0].base?.id , 5)
        XCTAssertEqual(responseModel[0].base?.parent_id , nil)
    }
    
    
    func testGetContentUnit_RetreivedSuccessfully() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var responseModel: [FailableDecodable<ContentUnits>]!
        do {
            let filePath = Bundle.main.url(forResource: "getContentUnit", withExtension: "txt")
            let data: Data = try Data.init(contentsOf: filePath!)
            
            
            responseModel =  try JSONDecoder()
                .decode([FailableDecodable<ContentUnits>].self, from: data)
            
            
            print(responseModel)
        }
        catch  {
            print("decoding failed with error=\(error)")
            
        }
        
        // print(type(of: responseModel))
        XCTAssertEqual(responseModel[0].base?.id , 1)
        XCTAssertEqual(responseModel[1].base?.audio_url , "http://www.thesoundarchive.com/simpsons/homer/mburger.wav")
        XCTAssertEqual(responseModel[1].base?.description , "philosophy")
        
        
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
