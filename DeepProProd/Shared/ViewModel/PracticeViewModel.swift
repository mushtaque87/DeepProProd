//
//  PracticeViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 4/26/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
private let reuseIdentifier = "scoresCell"


struct ColorVariance {
    let color: UIColor
    let range : ClosedRange<Int>
}


class PracticeViewModel: NSObject,
                            UITableViewDelegate , UITableViewDataSource ,
                            UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var scoreData = Array<Double>()
    var phenomeData = Array<Int>()
    let colors = [ColorVariance(color: UIColor(red: 254/255, green: 74/255, blue: 74/255, alpha: 0.9)  , range: 0...15),
                                ColorVariance(color: UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 0.9)  , range: 16...30),
                                ColorVariance(color: UIColor(red: 0/255, green: 153/255, blue: 204/255, alpha: 0.9)  , range: 31...50),
                                ColorVariance(color: UIColor(red: 143/255, green: 115/255, blue: 212/255, alpha: 0.9)  , range: 51...75),
                                ColorVariance(color: UIColor(red: 22/255, green: 186/255, blue: 120/255, alpha: 0.9)  , range: 76...100)]
    
    
    var wordResult : Word_Prediction?
    var predictionData : Pronunciation_Prediction = Pronunciation_Prediction.init()
    lazy var answersList = [UnitAnswers]()
    
    
    
    //MARK: - Table View Delegate and Data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "report", for: indexPath) as! ReportCell
       
        if(wordResult?.predicted_phonemes?.indices.contains(indexPath.row))!{
            cell.predicted.text = wordResult?.predicted_phonemes?[indexPath.row]
        }
        else{
            cell.predicted.text = ""
        }
        
        if(wordResult?.word_phonemes?.indices.contains(indexPath.row))!{
            cell.actual.text =  wordResult?.word_phonemes?[indexPath.row]
        }
        else{
            cell.predicted.text = ""
        }
        return cell
    }
    
    //MARK: - Collection View Delegate and Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier , for: indexPath) as! Scores_Cell
       // cell.scoreLabel.text = String(format:"%d",scoreData[indexPath.row])
        
        //let unit = answersList[indexPath.row].score
        
        cell.scoreLabel.text = String(format:"%.f",answersList[indexPath.row].score!)
        cell.backgroundColor = colorTheCell(score: Int(answersList[indexPath.row].score!))
        return cell

    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 0.0, right: 10.0)
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

    
    //MARK: - Others
    
    func colorTheCell(score: Int) -> UIColor {
        
        for color in colors
        {
            if(color.range.contains(score)){
                return color.color
            }
        }
        return UIColor(red: 56/255, green: 52/255, blue: 58/255, alpha: 0.9)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
  
    
}
