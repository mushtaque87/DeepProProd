//
//  StudentAssignmentModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/26/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import UIKit

enum AssignmentType : String   {
    case inProgress = "InProgress"
    case assigned = "Assigned"
    case submitted = "Submitted"
}


class StudentAssignmentModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: assignmentsProtocols?
    var assignmnetList =  Array<FailableDecodable<Assignment>>()
    var sectionHeaders = Array<String>()
    var assignmentsForSection = Dictionary<String, Array<FailableDecodable<Assignment>>>()
   // var totalAssignmentList : Assignments?
    //var newAssignmentlist = Array<AssignmentsList.Assignments>()
    
    override init() {
        do {
            super.init()
           // totalAssignmentList  = try Helper.getAssignmentList()
                let filePath = Bundle.main.url(forResource: "getAssignments", withExtension: "txt")
                let data: Data = try Data.init(contentsOf: filePath!)
                
                assignmnetList =  try JSONDecoder()
                    .decode([FailableDecodable<Assignment>].self, from: data)
   
                print(assignmnetList)
                sortAssignmentByDueDate()
                fetchUniqueDates()
            for section in sectionHeaders{
                assignmentsForSection.updateValue(fetchListOfAssignmentsForDate(for: section), forKey: section)
            }
        } catch  {
            print(error)
        }
    }
    
    /*
    func getAssignmnets()
    {
        do {
            // totalAssignmentList  = try Helper.getAssignmentList()
            let filePath = Bundle.main.url(forResource: "getAssignments", withExtension: "txt")
            let data: Data = try Data.init(contentsOf: filePath!)
            
            assignmnetList =  try JSONDecoder()
                .decode([FailableDecodable<Assignment>].self, from: data)
            
            print(assignmnetList)
            
            
        } catch  {
            print(error)
        }
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        /*
        if let assignmenttype = AssignmentType(rawValue: section) {
            switch assignmenttype {
            case .new:
                return 4
            case .inProgress:
                return 4
            case .submitted:
                return 3
            default:
                return 1
            }
        }
        */
        return fetchNumberOfRowsForSection(for: sectionHeaders[section])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        headerView.backgroundColor = UIColor.clear
        let titleLbl : UILabel =  UILabel(frame: CGRect(x: 5, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height/2))
        titleLbl.font = UIFont.boldSystemFont(ofSize: 12)
        titleLbl.textColor = UIColor.white
        titleLbl.text = sectionHeaders[section]
        titleLbl.alignText()
        titleLbl.backgroundColor = UIColor.clear
        headerView.addSubview(titleLbl)
        //headerView.backgroundColor = UIColor(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1)
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentListCell", for: indexPath) as! AssignmentTableViewCell
       
        //let assignment =  fetchListOfAssignmentsForDate(for: sectionHeaders[indexPath.section])[indexPath.row]
        //let assignment = assignmentsForSection[sectionHeaders[indexPath.section]]![indexPath.row]
        let assignments = assignmnetList.filter ({(assignment: FailableDecodable<Assignment>) -> Bool in
            return Date().dateFromEpoc((assignment.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy") == sectionHeaders[indexPath.section]
        })
        
        cell.assignmentName.text = assignments[indexPath.row].base?.short_name
        cell.descriptionView.text =  assignments[indexPath.row].base?.description
        cell.submissionDate.text =  String(format:"Due Date: %@",(Date().dateFromEpoc((assignments[indexPath.row].base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy")))
        cell.creationDate.text = String(format:"Assigned on: %@",(Date().dateFromEpoc((assignments[indexPath.row].base?.creation_date)!).toString(dateFormat: "EEEE, d MMM, yyyy")))
        
        //let formatteddate  = date.dateFromEpoc(1522580569)
       // print(formatteddate.toString(dateFormat: "EEEE,d MMM,yyyy"))
        
        
        if let assignmentStatus =  AssignmentType(rawValue:(assignments[indexPath.row].base?.assignment_status)!) {
            cell.assignmentStatus.text = (assignments[indexPath.row].base?.assignment_status)!
            switch assignmentStatus {
            case .assigned :
                cell.detailsView.backgroundColor = UIColor(red: 254/255, green: 143/255, blue: 136/255, alpha: 0.9)
            case .inProgress:
                cell.detailsView.backgroundColor = UIColor(red: 248/255, green: 182/255, blue: 130/255, alpha: 0.9)
            case .submitted :
                cell.detailsView.backgroundColor = UIColor(red: 159/255, green: 210/255, blue: 144/255, alpha: 0.9)
          
         }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.showAssignmentDetailsScreen()
    }
    
    
    func sortAssignmentByDueDate()
    {
        assignmnetList.sort {
            ($0.base?.due_date)!  < ($1.base?.due_date)!
        }
    }
    
    func fetchUniqueDates()
    {
        sectionHeaders.removeAll()
        for assignment in assignmnetList
        {
            if (!sectionHeaders.contains((Date().dateFromEpoc((assignment.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy"))) )
            {
                sectionHeaders.append(Date().dateFromEpoc((assignment.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy"))
            }
        }
    }
   
    func fetchNumberOfRowsForSection(for date:String) -> Int
    {
        var rowCount = 0
        for assignment in assignmnetList
        {
            if(Date().dateFromEpoc((assignment.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy") == date)
            {
                rowCount += 1
            }
        }
        return rowCount
    }

    func fetchListOfAssignmentsForDate(for date:String) -> Array<FailableDecodable<Assignment>>
    {
        var assignmentListForDate = Array<FailableDecodable<Assignment>>()
        for assignment in assignmnetList
        {
            if(Date().dateFromEpoc((assignment.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy") == date)
            {
                assignmentListForDate.append(assignment)
            }
        }
        return assignmentListForDate
    }
}
