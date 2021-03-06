//
//  assignments.swift
//  DeepProProdTests
//
//  Created by Mushtaque Ahmed on 3/29/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import XCTest
@testable import DeepProProd


class AssignmentsTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testgetAssignment_assignmentListParsedSuccessfully()
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
        XCTAssertEqual(responseModel[0].base?.short_name , "SWO 1")
        XCTAssertEqual(responseModel[1].base?.id , 125)
    }
   
    func testgetUnits_unitListParsedSuccessfully()
    {
        var responseModel: [FailableDecodable<Units>]!
        do {
            let filePath = Bundle.main.url(forResource: "getUnits", withExtension: "txt")
            let data: Data = try Data.init(contentsOf: filePath!)
            
            
            responseModel =  try JSONDecoder()
                .decode([FailableDecodable<Units>].self, from: data)
            
            
            print(responseModel)
        }
        catch  {
            print("decoding failed with error=\(error)")
            
        }
        
        // print(type(of: responseModel))
        XCTAssertEqual(responseModel[0].base?.id , 1234)
        XCTAssertEqual(responseModel[0].base?.creation_date , 1234512345)
      
    }
    
    func testgetUnitsAnswer_answersParsedSuccessfully()
    {
        var responseModel: [FailableDecodable<UnitAnswers>]!
        do {
            let filePath = Bundle.main.url(forResource: "getUnitAnswer", withExtension: "txt")
            let data: Data = try Data.init(contentsOf: filePath!)
            
            
            responseModel =  try JSONDecoder()
                .decode([FailableDecodable<UnitAnswers>].self, from: data)
            
            
            print(responseModel)
        }
        catch  {
            print("decoding failed with error=\(error)")
            
        }
        
        // print(type(of: responseModel))
         XCTAssertEqual(responseModel[0].base?.unit_id , 34)
        XCTAssertEqual(responseModel[0].base?.submission_date , 1234512345)
        
    }
    
    
    func testgetPredictResult_answersParsedSuccessfully()
    {
        var responseModel: [FailableDecodable<UnitAnswers>]!
        do {
            let filePath = Bundle.main.url(forResource: "getUnitAnswer", withExtension: "txt")
            let data: Data = try Data.init(contentsOf: filePath!)
            
            
            responseModel =  try? JSONDecoder().decode([FailableDecodable<UnitAnswers>].self, from: data)
            
            
            print(responseModel)
        }
        catch  {
            print("decoding failed with error=\(error)")
            
        }
        
        // print(type(of: responseModel))
         XCTAssertEqual(responseModel[0].base?.unit_id , 34)
         XCTAssertEqual(responseModel[0].base?.submission_date , 1525094033000)
        
    }
    
    func testEpoc_dateFormattedSuccessfully()
    {
        let date = Date()
        let formatteddate  = date.dateFromEpoc(1522580569)
        print(formatteddate.toString(dateFormat: "EEEE,d MMM,yyyy"))
        XCTAssertEqual(formatteddate.toString(dateFormat: "EEEE,d MMM,yyyy"),"Sunday,1 April,2018")
    }
    
    func testSortDates_datesSortedInAscendingOrderByDueDates()
    {
        
        let studentAssignmentModel = AssignmentModel()
        studentAssignmentModel.tasktype = .assignment
        studentAssignmentModel.sortAssignmentByDueDate()
        
        XCTAssertEqual(studentAssignmentModel.assignmnetList[0].base?.short_name , "SWO 2")
   
    }
    
    func testUniqueDates_fetchSetOfDatesForSection()
    {
        let studentAssignmentModel = AssignmentModel()
        studentAssignmentModel.fetchUniqueDates()
        print(studentAssignmentModel.sectionHeaders)
        
    }
    
    func testNoOfRowsInSection_fetchTheRowCount()
    {
        let studentAssignmentModel = AssignmentModel()
        studentAssignmentModel.fetchUniqueDates()
        for date in studentAssignmentModel.sectionHeaders{
            print("For Dates: \(date)")
           let rowCount = studentAssignmentModel.fetchNumberOfRowsForSection(for: date)
            print(rowCount)
        }
        
    }
    

}
