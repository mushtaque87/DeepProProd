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
    case assigned = "ASSIGNED"
    case submitted = "SUBMITTED"
    case reviewed = "REVIEWED"
}

class Assignments_UnitsModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: unitsProtocols?
    var unitList =  Array<FailableDecodable<ContentUnits>>()
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
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard unitList.count != 0 else {
//            return 0
//        }
        return unitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
        if(indexPath.row > unitList.count - 1)
        {
            let submitCell =  tableView.dequeueReusableCell(withIdentifier: "logout", for: indexPath) as! LogOutCell
            submitCell.logOut.titleLabel?.textAlignment = .center
            submitCell.logOut.setTitle("Submit", for: .normal)
            submitCell.logOut.setBackgroundImage(UIImage(named: "white button"), for: .normal)
            submitCell.logOut.setTitleColor(UIColor(red: 88/255, green: 153/255, blue: 95/255, alpha: 0.9), for: .normal)
            submitCell.contentView.backgroundColor = UIColor.clear
            submitCell.selectionStyle = UITableViewCellSelectionStyle.none
            submitCell.logOut.addTarget(self, action: #selector(submitAssignment), for: .touchUpInside)

            return submitCell
            
        }
        */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell", for: indexPath) as! UnitTableViewCell
        cell.contentView.backgroundColor = UIColor.clear
        let unit = unitList[indexPath.row]
        cell.titleLabel.text = unit.base?.question_text
        //cell.titleLabel.text = "unit.base?.question_text cell.titleLabel.text = unit.base?.question_text"
       // cell.unitDetailLabel.text = String(format:"Status: %d| Attempts: %d| Highest Score:%d",(unitList[indexPath.row].base?.unit_status)!,(unitList[indexPath.row].base?.attempts)!,(unitList[indexPath.row].base?.highest_score)!);
        cell.unitDetailLabel.isHidden = true
        var metaDataText = "Status: "
        if let status = unitList[indexPath.row].base?.status
        {
            cell.unitDetailLabel.isHidden = false
            metaDataText = String(format:"%@%@",metaDataText,status)
        }
        metaDataText = metaDataText + " | Attempts: "
        if let attempts = unitList[indexPath.row].base?.attempts
        {
            cell.unitDetailLabel.isHidden = false
            metaDataText = String(format:"%@%d",metaDataText,attempts)
        }
        metaDataText = metaDataText + " | Highest Score: "
        if let highestScore = unitList[indexPath.row].base?.highest_score
        {
            cell.unitDetailLabel.isHidden = false
            metaDataText = String(format:"%@%.2f",metaDataText,highestScore)
        }
        
        
        cell.unitDetailLabel.text = metaDataText
        
        cell.unitDescriptionLabel?.text = unit.base?.description
        //cell.detailView.backgroundColor = UIColor(red: 205/255, green: 129/255, blue: 129/255, alpha: 0.9)
        
        
        if let unitStatus =  UnitStatus(rawValue:(unit.base?.status)!) {
           // cell.assignmentStatus.text = (unit[indexPath.row].base?.unit_status)!
            switch unitStatus {
            case .assigned:
                cell.detailView.backgroundColor = UIColor(red: 201/255, green: 74/255, blue: 74/255, alpha: 0.9)
                break
            case .submitted :
                cell.detailView.backgroundColor = UIColor(red: 88/255, green: 153/255, blue: 95/255, alpha: 0.9)
                break
            case .reviewed:
                cell.detailView.backgroundColor = UIColor(red: 227/255, green: 183/255, blue: 225/255, alpha: 0.9)
                break
             default:
                cell.detailView.backgroundColor = UIColor(red: 201/255, green: 74/255, blue: 74/255, alpha: 0.9)
            }
        }
        
        //cell.continueButton.tag = (unitList[indexPath.row].base?.id)!
        //cell.continueButton.indexPath = indexPath
        //cell.continueButton.addTarget(self, action:#selector(showUnitsScreen(_:)) , for: .touchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //cell.detailView.backgroundColor = UIColor(red: 248/255, green: 182/255, blue: 130/255, alpha: 0.9)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        guard indexPath.row < unitList.count - 1 else {
//            return
//        }
        
        delegate?.showPronunciationScreen(with: unitList, and: indexPath.row)

        //let unit = unitList[indexPath.row]
       
        /* ServiceManager().getAnswers(for: 1, for:(unit.base?.unit_id)! , of: UserDefaults.standard.string(forKey: "uid")! , onSuccess: {response in
            
        }, onHTTPError: { httperror in
            
        }, onError: { error in
            
        }, onComplete: {
            
        })*/
        
        //delegate?.showPronunciationScreen(with: unitList, and: indexPath.row)

    }
    
    @objc func showUnitsScreen(_ sender:UIButton)
    {
        print(sender.tag)
        delegate?.showPronunciationScreen(with: unitList, and: (sender as! ContinueButton).indexPath.row)

    }
    
    @objc func submitAssignment()
    {
       delegate?.submitAssignment()
    }
        
}
