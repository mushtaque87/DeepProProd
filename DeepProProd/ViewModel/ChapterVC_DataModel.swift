//
//  ChapterVC_DataModel.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/20/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit

enum ChapterType {
    case alphabet
    case numbers
    case places
    case noun
    case adverbs
    case adjective
    case word
}

struct ChapterData {
    var dataArray : Array<String>
    let chapterType: ChapterType
    
}

class ChapterVC_DataModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var viewController : UIViewController!
    
    var chapterData = [ChapterData(dataArray: ["A","B","C","D","E","F","G","H","I","K","L","M","N",
                                               "O","P","Q","R","S","T","U","V","W","X","Y","Z"], chapterType: ChapterType.alphabet),
                       ChapterData(dataArray: ["0","1","2","3","4","5","6","7","8","9"], chapterType: ChapterType.numbers),
                       ChapterData(dataArray: ["Office","Hospital","Palace","Church","Parking Lot","Basement","Kitchen","Wash room", "Bedroom", "Police Station","Highway" ], chapterType: ChapterType.places),
                       ChapterData(dataArray: ["Person","Animal","Place","Thing","Idea","Money","Horse","Love","Emotion"], chapterType: ChapterType.noun),
                       ChapterData(dataArray: ["Believe","Fear","Wonder","Know","Recognise","Hear","Call"], chapterType: ChapterType.adverbs),
                       ChapterData(dataArray: ["Huge","Smooth","Pleasant","Intelligent","Wise","Beautiful","Horrible","Intresting","Unpleasent","Nerdy"], chapterType: ChapterType.adjective)]
    
    var dataArray: Array<String>?
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return (dataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as! ChapterContentCell
        cell.contentLabel.text = dataArray?[indexPath.row]
        cell.contentLabel.textColor = UIColor(red: CGFloat((5.0 * Double((dataArray?.count)! - indexPath.row))/255.0), green: CGFloat((10.0 * Double((dataArray?.count)! - indexPath.row))/255.0), blue: CGFloat((15.0 * Double((dataArray?.count)! - indexPath.row))/255.0), alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let transDetailViewController: TransDetailViewController = TransDetailViewController(nibName: "TransDetailViewController", bundle: nil)
        //viewController.present(transDetailViewController, animated: true, completion: nil)
        viewController.navigationController?.pushViewController(transDetailViewController, animated: true)
    }
    
    func fetchData(type: ChapterType) {
        for data in chapterData {
            if(data.chapterType == type){
                 dataArray?.removeAll()
                 dataArray =  data.dataArray
            }
        }
    }
    
    
}
