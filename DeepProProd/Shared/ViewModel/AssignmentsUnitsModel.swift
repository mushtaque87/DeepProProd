//
//  AssignmentsUnitsModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 4/8/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import UIKit

enum UnitStatus : String   {
    case notStarted = "No Started"
    case inComplete = "Incomplete"
    case completed = "Complete"
}

class AssignmentsUnitsModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: unitsProtocols?
    var unitList =  Array<FailableDecodable<Units>>()

    override init() {
        
        do {
             super.init()
        
          /*
                let filePath = Bundle.main.url(forResource: "getUnits", withExtension: "txt")
                let data: Data = try Data.init(contentsOf: filePath!)
                
                
                unitList =  try JSONDecoder()
                    .decode([FailableDecodable<Units>].self, from: data)
                
                
                print(unitList)
 */

         } catch  {
    print(error)
    }
}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return unitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell", for: indexPath) as! UnitTableViewCell
        cell.contentView.backgroundColor = UIColor.clear
        let unit = unitList[indexPath.row]
        cell.titleLabel.text = unit.base?.question_text
        cell.unitDetailLabel.text = "Status: | Attempts: | Highest Score:"
        cell.unitDescriptionLabel?.text = unit.base?.description
        //cell.detailView.backgroundColor = UIColor(red: 205/255, green: 129/255, blue: 129/255, alpha: 0.9)
        
        /*
        if let unitStatus =  UnitStatus(rawValue:(unit.base?.unit_status)!) {
           // cell.assignmentStatus.text = (unit[indexPath.row].base?.unit_status)!
            switch unitStatus {
            case .notStarted :
                cell.detailView.backgroundColor = UIColor(red: 254/255, green: 143/255, blue: 136/255, alpha: 0.9)
            case .inComplete:
                cell.detailView.backgroundColor = UIColor(red: 248/255, green: 182/255, blue: 130/255, alpha: 0.9)
            case .completed :
                cell.detailView.backgroundColor = UIColor(red: 159/255, green: 210/255, blue: 144/255, alpha: 0.9)
                
            }
        }
         */
        
        cell.detailView.backgroundColor = UIColor(red: 248/255, green: 182/255, blue: 130/255, alpha: 0.9)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.showPronunciationScreen(with: unitList, and: indexPath.row)

    }
    
        
}
