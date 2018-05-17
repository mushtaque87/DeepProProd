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
    case inProgress = "IN_PROGRESS"
    case assigned = "ASSIGNED"
    case submitted = "SUBMITTED"
}

enum TaskType : String   {
    case practice
    case assignment
    case freeSpeech
}


class AssignmentModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: AssignmentsProtocols?
    var assignmnetList =  Array<FailableDecodable<Assignment>>()
    var practiceList =  Array<FailableDecodable<Practice>>()
    var sectionHeaders = Array<String>()
    var assignmentsForSection = Dictionary<String, Array<FailableDecodable<Assignment>>>()
    var tasktype : TaskType = .practice //default
    var categoryId:Int?
   // var totalAssignmentList : Assignments?
    //var newAssignmentlist = Array<AssignmentsList.Assignments>()
    
    override init() {
        do {
            super.init()
           // totalAssignmentList  = try Helper.getAssignmentList()
            
            /*
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
             */
            
        } catch  {
            print(error)
        }
    }
    
   /*
    func getAssignmnets()
    {
        do {
  
            
       
            
            
        } catch  {
            print(error)
        }
    }
 
 */
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tasktype {
        case .assignment:
            return sectionHeaders.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
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
        switch tasktype {
        case .assignment:
            return fetchNumberOfRowsForSection(for: sectionHeaders[section])
            
        default:
            return practiceList.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        headerView.backgroundColor = UIColor.clear
        let titleLbl : UILabel =  UILabel(frame: CGRect(x: 5, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height/2))
        titleLbl.font = UIFont.boldSystemFont(ofSize: 12)
        titleLbl.textColor = UIColor.white
        switch tasktype {
        case .assignment:
        titleLbl.text = sectionHeaders[section]
            break
        default:
           titleLbl.text = ""
        }
            
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
        switch tasktype {
        case .assignment:
        let assignments = assignmnetList.filter ({(assignment: FailableDecodable<Assignment>) -> Bool in
            return Date().dateFromEpoc((assignment.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy") == sectionHeaders[indexPath.section]
        })
        
        cell.assignmentName.text = assignments[indexPath.row].base?.short_name
        cell.descriptionView.text =  assignments[indexPath.row].base?.description
        cell.submissionDate.text =  String(format:"Due Date: %@",(Date().dateFromEpoc((assignments[indexPath.row].base?.due_date)!).toString(dateFormat: "EEE, d MMM, yyyy")))
        cell.creationDate.text = String(format:"Assigned on: %@",(Date().dateFromEpoc((assignments[indexPath.row].base?.creation_date)!).toString(dateFormat: "EEE, d MMM, yyyy")))
        
        //let formatteddate  = date.dateFromEpoc(1522580569)
       // print(formatteddate.toString(dateFormat: "EEEE,d MMM,yyyy"))
        
        
        if let assignmentStatus =  AssignmentType(rawValue:(assignments[indexPath.row].base?.status)!) {
            cell.assignmentStatus.text = (assignments[indexPath.row].base?.status)!
            switch assignmentStatus {
            case .assigned :
                cell.detailsView.backgroundColor = UIColor(red: 254/255, green: 143/255, blue: 136/255, alpha: 0.9)
            case .inProgress:
                cell.detailsView.backgroundColor = UIColor(red: 248/255, green: 182/255, blue: 130/255, alpha: 0.9)
            case .submitted :
                cell.detailsView.backgroundColor = UIColor(red: 159/255, green: 210/255, blue: 144/255, alpha: 0.9)
          
         }
        }
        
        cell.continueButton.tag = (assignments[indexPath.row].base?.id)!
        cell.continueButton.addTarget(self, action:#selector(showUnitsScreen(_:)) , for: .touchUpInside)
       
        break
            
        default:
            /*
            let practices = practiceList.filter ({(practice: FailableDecodable<Practice>) -> Bool in
                return Date().dateFromEpoc((practice.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy") == sectionHeaders[indexPath.section]
            })*/
            cell.submissionDate.isHidden = true
            cell.assignmentName.text = practiceList[indexPath.row].base?.short_name
            cell.descriptionView.text =  practiceList[indexPath.row].base?.description
            //cell.submissionDate.text =  String(format:"Due Date: %@",(Date().dateFromEpoc((practices[indexPath.row].base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy")))
            cell.creationDate.text = String(format:"Assigned on: %@",(Date().dateFromEpoc((practiceList[indexPath.row].base?.creation_date)!).toString(dateFormat: "EEE, d MMM, yyyy")))
            
            //let formatteddate  = date.dateFromEpoc(1522580569)
            // print(formatteddate.toString(dateFormat: "EEEE,d MMM,yyyy"))
            
            
             if let assignmentStatus =  AssignmentType(rawValue:(practiceList[indexPath.row].base?.status)!) {
             cell.assignmentStatus.text = (practiceList[indexPath.row].base?.status)!
             switch assignmentStatus {
             case .assigned :
             cell.detailsView.backgroundColor = UIColor(red: 254/255, green: 143/255, blue: 136/255, alpha: 0.9)
             case .inProgress:
             cell.detailsView.backgroundColor = UIColor(red: 248/255, green: 182/255, blue: 130/255, alpha: 0.9)
             case .submitted :
             cell.detailsView.backgroundColor = UIColor(red: 159/255, green: 210/255, blue: 144/255, alpha: 0.9)
             
             }
             }
            
            cell.continueButton.tag = (practiceList[indexPath.row].base?.id)!
            cell.continueButton.addTarget(self, action:#selector(showUnitsScreen(_:)) , for: .touchUpInside)
            
            
            break
        }
        
        // FIXME: - Remove the color
       // cell.detailsView.backgroundColor = UIColor(red: 159/255, green: 210/255, blue: 144/255, alpha: 0.9)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        switch tasktype {
        case .assignment:
        let assignments = assignmnetList.filter ({(assignment: FailableDecodable<Assignment>) -> Bool in
            return Date().dateFromEpoc((assignment.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy") == sectionHeaders[indexPath.section]
        })
        
        guard  assignments[indexPath.row].base?.id != nil else {
            return
        }
        break
        default:
            break
        }
        
        
    }
    
    @objc func showUnitsScreen(_ sender:UIButton)
    {
        print(sender.tag)
        delegate?.showAssignmentDetailsScreen(for: sender.tag)

    }
    
    
    func sortAssignmentByDueDate()
    {
        switch tasktype {
        case .assignment:
            assignmnetList.sort {
                ($0.base?.due_date)!  < ($1.base?.due_date)!
            }
            break
        default:
            practiceList.sort {
                ($0.base?.due_date)!  < ($1.base?.due_date)!
            }
            break
        }
       
    }
    
    func fetchUniqueDates()
    {
        sectionHeaders.removeAll()
        switch tasktype {
        case .assignment:
        for assignment in assignmnetList
        {
            if (!sectionHeaders.contains((Date().dateFromEpoc((assignment.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy"))) )
            {
                sectionHeaders.append(Date().dateFromEpoc((assignment.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy"))
            }
        }
            break
        default:
            for practice in practiceList
            {
                if (!sectionHeaders.contains((Date().dateFromEpoc((practice.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy"))) )
                {
                    sectionHeaders.append(Date().dateFromEpoc((practice.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy"))
                }
            }
            break
        }
    }
   
    func fetchNumberOfRowsForSection(for date:String) -> Int
    {
        var rowCount = 0
        switch tasktype {
        case .assignment:
        for assignment in assignmnetList
        {
            if(Date().dateFromEpoc((assignment.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy") == date)
            {
                rowCount += 1
            }
        }
        return rowCount
         default:
            for practice in assignmnetList
            {
                if(Date().dateFromEpoc((practice.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy") == date)
                {
                    rowCount += 1
                }
            }
            return rowCount
        }
    }

    func fetchListOfAssignmentsForDate(for date:String) -> Array<FailableDecodable<Assignment>>
    {
        switch tasktype {
        case .assignment:
        var assignmentListForDate = Array<FailableDecodable<Assignment>>()
        for assignment in assignmnetList
        {
            if(Date().dateFromEpoc((assignment.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy") == date)
            {
                assignmentListForDate.append(assignment)
            }
        }
        return assignmentListForDate
        default:
            var practiceListForDate = Array<FailableDecodable<Assignment>>()
            for practice in assignmnetList
            {
                if(Date().dateFromEpoc((practice.base?.due_date)!).toString(dateFormat: "EEEE, d MMM, yyyy") == date)
                {
                    practiceListForDate.append(practice)
                }
            }
            return practiceListForDate
        }
    }
}
