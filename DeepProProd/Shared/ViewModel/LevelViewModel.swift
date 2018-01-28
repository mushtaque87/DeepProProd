//
//  LevelViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/10/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class LevelViewModel: NSObject, UITableViewDelegate , UITableViewDataSource {

    var parentController: Level_SHViewController?
    var levelArray : LevelList? // = ["Level_Basic".localized,"Level_Intermediate".localized,"Level_Advance".localized]
    
    // Mark: - UITable View Delegate and Data Source
    
    
    override init() {
        do {
             levelArray  = try Helper.parseJson()
            
        } catch  {
            print(error)
        }
        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return parentController!.view.bounds.height / 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as! ChapterContentCell
       // cell.contentLabel.textColor = UIColor.white
        let level = levelArray?.levels[indexPath.row]
        
        cell.contentLabel.text  = level?.levelname.rawValue
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
