//
//  PracticeTest.swift
//  DeepProProdTests
//
//  Created by Mushtaque Ahmed on 4/22/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import XCTest
@testable import DeepProProd

class PracticeTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testgetCategory_categoryListParsedSuccessfully()
    {
        var responseModel: [FailableDecodable<Assignment>]!
        do {
            let filePath = Bundle.main.url(forResource: "getAssignments", withExtension: "txt")
            let data: Data = try Data.init(contentsOf: filePath!)
            
            responseModel =  try JSONDecoder()
                .decode([FailableDecodable<Assignment>].self, from: data)
            
            
            print(responseModel)
        }
        catch  {
            print("decoding failed with error=\(error)")
            
        }
        
        // print(type(of: responseModel))
        XCTAssertEqual(responseModel[0].base?.id , 123)
        XCTAssertEqual(responseModel[0].base?.short_name , "AIN")
        XCTAssertEqual(responseModel[1].base?.id , 125)
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testClean_AllAudiofileSucesffully() {
        let practiceBoardVC = PracticeBoardViewController()
        practiceBoardVC.audioFolderPath = Helper.getAudioDirectory(for: .freeSpeech)
        practiceBoardVC.startRecording()
        sleep(5)
        practiceBoardVC.finishRecording(success: true)
        practiceBoardVC.clearAllAudioFile()
        
        let enumerator = FileManager.default.enumerator(atPath: practiceBoardVC.audioFolderPath!)
        while let element = enumerator?.nextObject() as? String {
            if (element.hasSuffix(".wav")) {
                XCTFail("All .wav Files not deleted")
            }
        }
    }
 
    /*
    func testGRPCService_AudioReadSucessfully (){
        let practiceBoardVC = PracticeBoardViewController(nibName:"PracticeBoardViewController",bundle:nil)
       
        practiceBoardVC.currentSessionRecordingCount =  1
        practiceBoardVC.audioFolderPath = Helper.getAudioDirectory(for: .freeSpeech)
        practiceBoardVC.startRecording()
        sleep(5)
        practiceBoardVC.finishRecording(success: true)
        practiceBoardVC.callGRPCService()
 
    } */
    
}
