//
//  PracticeViewModel.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 4/26/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import Charts
import AVFoundation

private let reuseIdentifier = "scoresCell"


struct ColorVariance {
    let color: UIColor
    let range : ClosedRange<Int>
}


class PracticeViewModel: NSObject,
                            UITableViewDelegate , UITableViewDataSource ,
                        UICollectionViewDelegate ,UICollectionViewDataSource,
                        UICollectionViewDelegateFlowLayout, ChartViewDelegate,
                        UITextViewDelegate  {
    var scoreData = Array<Double>()
    var phenomeData = Array<Int>()
    let colors = [ColorVariance(color: UIColor(red: 254/255, green: 74/255, blue: 74/255, alpha: 0.9)  , range: 0...15),
                                ColorVariance(color: UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 0.9)  , range: 16...30),
                                ColorVariance(color: UIColor(red: 0/255, green: 153/255, blue: 204/255, alpha: 0.9)  , range: 31...50),
                                ColorVariance(color: UIColor(red: 143/255, green: 115/255, blue: 212/255, alpha: 0.9)  , range: 51...75),
                                ColorVariance(color: UIColor(red: 22/255, green: 186/255, blue: 120/255, alpha: 0.9)  , range: 76...100)]
    
    
   // var wordResult : Word_Prediction?
    var predictionData : Pronunciation_Prediction = Pronunciation_Prediction.init()
    lazy var answersList = [UnitAnswers]()
    lazy var unitList = [Units]()
    var selectedAnswer: Prediction_result_json?
    weak var delegate: PracticeBoardProtocols?
    var streamPlayer = AVPlayer()
    
    //lazy var unitList =  Array<FailableDecodable<Units>>()
    
    
    //MARK: - Table View Delegate and Data source
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width/2, height: 28))
        //headerView.backgroundColor = UIColor(red: 196.0/255.0, green: 194.0/255.0, blue: 255.0/255.0, alpha: 1)
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "report", for: IndexPath(row: 0, section: section)) as! ReportCell
        cell.contentView.backgroundColor  = UIColor(red: 196.0/255.0, green: 194.0/255.0, blue: 255.0/255.0, alpha: 1)
        cell.actual.text = selectedAnswer?.wordResults![section].word
        cell.actual.font = UIFont(name: "Poppins-Bold", size: 22.0)
        cell.actual.textColor = UIColor.white
        cell.actual.textAlignment = NSTextAlignment.center
        cell.actual.backgroundColor = UIColor.clear
        //headerView.addSubview(wordLabel)
        
        if let score = selectedAnswer?.wordResults![section].score {
            cell.predicted.text = String(format:"%.f",score)
        } else{
            cell.predicted.text = "--"
        }
        cell.predicted.font = UIFont(name: "Poppins-Bold", size: 22.0)
        cell.predicted.textColor = UIColor.white
        cell.predicted.textAlignment = NSTextAlignment.center
        cell.predicted.backgroundColor = UIColor.clear
        
        /*
        let wordLabel = UILabel(frame: CGRect(x: cell.actual.frame.origin.x, y: 0, width: cell.actual.frame.size.width, height: 28))
        wordLabel.text = selectedAnswer?.wordResults![section].word
        wordLabel.font = UIFont(name: "Poppins-Bold", size: 22.0)
        wordLabel.textColor = UIColor.white
        wordLabel.textAlignment = NSTextAlignment.center
        wordLabel.backgroundColor = UIColor.clear
        headerView.addSubview(wordLabel)
 
        
        let scoreLabel = UILabel(frame: CGRect(x: cell.predicted.frame.origin.x , y: 0, width: cell.predicted.frame.size.width , height: 28))
        if let score = selectedAnswer?.wordResults![section].score {
        scoreLabel.text = String(format:"%d",score)
        } else{
            scoreLabel.text = "--"
        }
        scoreLabel.font = UIFont(name: "Poppins-Bold", size: 22.0)
        scoreLabel.textColor = UIColor.white
        scoreLabel.textAlignment = NSTextAlignment.center
        scoreLabel.backgroundColor = UIColor.clear
        headerView.addSubview(scoreLabel)
        */
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let wordResult = selectedAnswer?.wordResults {
            return wordResult.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let wordResult = selectedAnswer?.wordResults {
            return max((wordResult[section].predictedPhonemes?.count)!, (wordResult[section].wordPhonemes?.count)!)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "report", for: indexPath) as! ReportCell
       
        if(selectedAnswer?.wordResults![indexPath.section].predictedPhonemes?.indices.contains(indexPath.row))!{
            cell.predicted.text = selectedAnswer?.wordResults![indexPath.section].predictedPhonemes?[indexPath.row]
        }
        else{
            cell.predicted.text = ""
        }
        
        if(selectedAnswer?.wordResults![indexPath.section].wordPhonemes?.indices.contains(indexPath.row))!{
            cell.actual.text =  selectedAnswer?.wordResults![indexPath.section].wordPhonemes?[indexPath.row]
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
        if let submissionDate = answersList[indexPath.row].submission_date {
             cell.submissionDateLabel.text =  String(format:"%@",(Date().dateFromEpoc(submissionDate).toString(dateFormat: "dd MMM, yyyy")))
        } else {
             cell.submissionDateLabel.text = ""
        }

        cell.audioPlayButton.tag = indexPath.row
        cell.audioPlayButton.addTarget(self, action: #selector(playUserAudio(_:)), for: .touchUpInside)
        cell.backgroundColor = colorTheCell(score: Int(answersList[indexPath.row].score!))
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedAnswer =  answersList[indexPath.row].prediction_result_json
        delegate?.reloadtable()
        delegate?.displayResultType(to: .phenomeTable, from: .score)
        
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
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        selectedAnswer =  answersList[Int(entry.x)].prediction_result_json
        delegate?.reloadtable()
        delegate?.displayResultType(to: .phenomeTable, from: .graph)
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase)
    {
        print("chartValueNothingSelected")
    }
    
    @objc func playUserAudio(_ sender: UIButton)
    {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        if let url = answersList[sender.tag].audio_url{
        let playerItem = AVPlayerItem(url: URL(string:url)!)
        streamPlayer = AVPlayer(playerItem:playerItem)
        streamPlayer.rate = 1.0;
        streamPlayer.volume = 1.0
        streamPlayer.play()
        }
            
        } catch let error {
            print(error.localizedDescription)
            
        }
            
        
    }
    
  // MARK: - TextView Delegate
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
       
        delegate?.resetTextViewContent(textView:textView)
        return true
     
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
      
            delegate?.resetTextViewContent(textView: textView)
            
      
    }
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text.count == 1)
        {
            delegate?.resetTextViewContent(textView: textView)
            
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
       
            //parentObject.wordTextView.text = textView.text
            //parentObject.showTextField()
            delegate?.resetTextViewContent(textView: textView)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

  
    
}
