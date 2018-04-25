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
    weak var delegate: CategoriesProtocol?
    //  var levelArray : LevelList? // = ["Level_Basic".localized,"Level_Intermediate".localized,"Level_Advance".localized]
    var categoriesList =  Array<FailableDecodable<Categories>>()

    // Mark: - UITable View Delegate and Data Source
    
    
    /*override init() {
        do {
             //levelArray  = try Helper.parseLevelJson()
            
        } catch  {
            print(error)
        }
        

    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return categoriesList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return parentController!.view.bounds.height / 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as! ChapterContentCell
       // cell.contentLabel.textColor = UIColor.white
        
        
        cell.contentLabel.text  = categoriesList[indexPath.row].base?.name
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.showPracticesScreen!(for: (categoriesList[indexPath.row].base?.id)!)
    }
    
}
