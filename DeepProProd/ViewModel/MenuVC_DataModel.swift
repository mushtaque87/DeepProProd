//
//  MenuVC_DataModel.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/11/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit

private let reuseIdentifier = "menucell"

struct ChapterSyllabus {
    let chapterTitle :  String
    let chapterImage: UIImage
}

class MenuVC_DataModel: NSObject, UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var lessonList = [ChapterSyllabus(chapterTitle: "Alphabets", chapterImage: UIImage(named: "abc.png")!),
                      ChapterSyllabus(chapterTitle: "Numbers", chapterImage: UIImage(named: "numbers.png")!),
                      ChapterSyllabus(chapterTitle: "Places", chapterImage: UIImage(named: "hospital.png")!),
                      ChapterSyllabus(chapterTitle: "Nouns", chapterImage: UIImage(named: "brain_spawn.png")!),
                      ChapterSyllabus(chapterTitle: "Verbs", chapterImage: UIImage(named: "my_work.png")!),
                      ChapterSyllabus(chapterTitle: "Adjective", chapterImage: UIImage(named: "idea.png")!),
                      ChapterSyllabus(chapterTitle: "Words", chapterImage: UIImage(named: "emblem_library.png")!)]
    
    var viewController : UIViewController!
    
    
    
    override init() {
    //lessonList = ["Alphabets", "Numbers", "Places", "Nouns", "Verbs", "Adjective" ,  "Words"]
   
        
    }
    
     // MARK: UICollectionViewDataSource
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return lessonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier , for: indexPath) as! Menu_Cell
         let lesson   = lessonList[indexPath.row] as ChapterSyllabus
        cell.lessonTitle.text = lesson.chapterTitle
        cell.chapterImage.image = lesson.chapterImage
        // Configure the cell
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
     func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        /*
        let lesson   = lessonList[indexPath.row] as ChapterSyllabus
        switch lesson.chapterTitle {
        case "Alphabets":
            let chapterViewController : ChapterContentViewController = ChapterContentViewController(nibName: "ChapterContentViewController", bundle: nil)
            chapterViewController.chapterType = ChapterType.alphabet
            viewController.navigationController?.pushViewController(chapterViewController, animated: true)
            break
        case "Numbers":
            let chapterViewController : ChapterContentViewController = ChapterContentViewController(nibName: "ChapterContentViewController", bundle: nil)
            chapterViewController.chapterType = ChapterType.numbers
            viewController.navigationController?.pushViewController(chapterViewController, animated: true)
            break
        case "Places":
            let chapterViewController : ChapterContentViewController = ChapterContentViewController(nibName: "ChapterContentViewController", bundle: nil)
            chapterViewController.chapterType = ChapterType.places
            viewController.navigationController?.pushViewController(chapterViewController, animated: true)
            break
        case "Nouns":
            let chapterViewController : ChapterContentViewController = ChapterContentViewController(nibName: "ChapterContentViewController", bundle: nil)
            chapterViewController.chapterType = ChapterType.noun
            viewController.navigationController?.pushViewController(chapterViewController, animated: true)
            break
        case "Verbs":
            let chapterViewController : ChapterContentViewController = ChapterContentViewController(nibName: "ChapterContentViewController", bundle: nil)
            chapterViewController.chapterType = ChapterType.adverbs
            viewController.navigationController?.pushViewController(chapterViewController, animated: true)
            break
        case "Adjective":
            let chapterViewController : ChapterContentViewController = ChapterContentViewController(nibName: "ChapterContentViewController", bundle: nil)
            chapterViewController.chapterType = ChapterType.adjective
            viewController.navigationController?.pushViewController(chapterViewController, animated: true)
            break
            
        default:
            let transDetailViewController: TransDetailViewController = TransDetailViewController(nibName: "TransDetailViewController", bundle: nil)
            //viewController.present(transDetailViewController, animated: true, completion: nil)
            viewController.navigationController?.pushViewController(transDetailViewController, animated: true)

            //transDetailViewController.fillDescriptionView(word: lessonList[indexPath.row] as String)
        }*/
        return true
 
    }
    
    
    
    
     // MARK: UICollectionViewDelegateFlowLayout
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
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
