//
//  LevelViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/10/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

struct Crums {
    let id: Int
    let title : String
}

enum CrumActionType  :  Int {
    case append
    case remove
 
}

class LevelViewModel: NSObject, UITableViewDelegate , UITableViewDataSource,                             UICollectionViewDelegate ,UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout{
    private let reuseIdentifier = "crumTitle"
    weak var delegate: CategoriesProtocol?
    //  var levelArray : LevelList? // = ["Level_Basic".localized,"Level_Intermediate".localized,"Level_Advance".localized]
    var contentList =  Array<FailableDecodable<ContentGroup>>()
    var crumList = Array<Crums>()
    var currentGroupId = 0
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
     
        return contentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as! ChapterContentCell
       // cell.contentLabel.textColor = UIColor.white
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentListCell", for: indexPath) as! AssignmentTableViewCell
       
        if let name = contentList[indexPath.row].base?.name {
             print("Title : \(name)")
            cell.assignmentName.text = name
            cell.detailsView.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
        }
         if let description = contentList[indexPath.row].base?.description {
         cell.descriptionView.text = description
        }
        if let createdDate = contentList[indexPath.row].base?.creation_date {
            cell.creationDate.text = String(format:"Created on: %@",(Date().dateFromEpoc(Double(createdDate)).toString(dateFormat: "EEE, d MMM, yyyy")))
        }
        cell.continueButton.isHidden = true
        cell.assignmentStatus.isHidden = true
        cell.submissionDate.isHidden = true
        cell.unitCount.isHidden = true
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // delegate?.showPracticesScreen(for: (categoriesList[indexPath.row].base)!)
        if let contentDetails  = contentList[indexPath.row].base {
        delegate?.fetchContentGroup(for: contentDetails, actionType: .append)
        }
    }
    
    //MARK: - Collection View Delegate and Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return crumList.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier , for: indexPath) as! CrumTitle_Cell
        cell.titleLbl.text = crumList[indexPath.row].title
        //cell.backgroundColor =  UIColor.red
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let crum = crumList[indexPath.row]
        delegate?.fetchContentGroup(for: ContentGroup(id:crum.id , name: crum.title), actionType: .remove)
        
    }
    
    func addCrums(of content:Crums) {
        if !crumList.contains(where: {$0.id == content.id}) {
        crumList.append(content)
        }
         print(crumList)
    }
    
    func removeCrums (till content:Crums) {
        for index in stride(from: crumList.count - 1, to: 0, by: -1){
            if crumList[index].id != content.id {
                crumList.remove(at: index)
            } else {
                break
            }
        }
        print(crumList)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    fileprivate let sectionInsets = UIEdgeInsets(top: -1.0, left: 0.0, bottom: -1.0, right: 0.0)
    fileprivate let itemsPerRow: CGFloat = 100
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
       // let widthPerItem = availableWidth / itemsPerRow
        let crumTitle = crumList[indexPath.row]
        let crumWidth = CGFloat(7 * crumTitle.title.count)
        //return CGSize(width: crumWidth , height: 60.0)
        return CGSize(width: 100.0, height: 70.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
  

    
}


