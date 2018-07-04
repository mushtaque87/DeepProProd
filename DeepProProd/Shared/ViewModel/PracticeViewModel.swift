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
import RxSwift

private let reuseIdentifier = "scoresCell"


struct ColorVariance {
    let color: UIColor
    let range : ClosedRange<Int>
}


class PracticeViewModel: NSObject,
                            UITableViewDelegate , UITableViewDataSource ,
                        UICollectionViewDelegate ,UICollectionViewDataSource,
                        UICollectionViewDelegateFlowLayout, ChartViewDelegate,
                        UITextViewDelegate, AVAudioPlayerDelegate,
                        AVSpeechSynthesizerDelegate,
                        AVAssetResourceLoaderDelegate{
    
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
    lazy var unitList = [ContentUnits]()
    var selectedAnswer: Prediction_result_json?
    weak var delegate: PracticeBoardProtocols?
    var streamPlayer = AVPlayer()
    var isTTSSpeaking : Bool = false
    var isStreamPlaying : Bool = false
    var isRecordingOn : Bool = false
    var playingIndexPath : IndexPath?
    let speechSynthesizer = AVSpeechSynthesizer()
    /*var isSpeaking : Observable<Bool> {
        return Observable.
    }*/
    
   /* var isValid : Observable<Bool> {
        
        return Observable.combineLatest(email.asObservable(),password.asObservable()) { email , password in
            email.count > 0 && email.contains("@") && email.contains(".com")
            
        }
    }
    */
    
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
        cell.audioPlayButton.layer.setValue(indexPath.row, forKey: "row")
        cell.audioPlayButton.addTarget(self, action: #selector(playUserAudio(_:)), for: .touchUpInside)
       /*
        if cell.isPlaying == true {
            cell.audioPlayButton.setImage(UIImage(named: "player_stop"), for: .normal)
        } else {
            cell.audioPlayButton.setImage(UIImage(named: "speaker"), for: .normal)
        }*/
        cell.backgroundColor = colorTheCell(score: Int(answersList[indexPath.row].score!))
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedAnswer =  answersList[indexPath.row].prediction_result_json
        delegate?.reloadtable()
        if let wordResult = selectedAnswer?.wordResults {
        delegate?.setAttributedText(with: createAttributedText(forText: wordResult))
        delegate?.displayResultType(to: .phenomeTable, from: .score)
        } else{
            print("ℹ️ No Phoneme data available")
        }
        
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

    //MARK: - Speech Synthesizer Delegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("😀 Expert didStart Speaking")
        isTTSSpeaking = true
        delegate?.setExpertSpeechButtonImage(set: true)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
         print("🤬 Expert didFinish Speaking")
        isTTSSpeaking = false
        delegate?.setExpertSpeechButtonImage(set: false)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("🤬 Expert didPause Speaking")
        isTTSSpeaking = false
        delegate?.setExpertSpeechButtonImage(set: false)
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("🤬 Expert didCancel Speaking")
        isTTSSpeaking = false
        delegate?.setExpertSpeechButtonImage(set: false)
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
        if let wordResult = selectedAnswer?.wordResults {
            delegate?.setAttributedText(with: createAttributedText(forText: wordResult))
            delegate?.displayResultType(to: .phenomeTable, from: .score)
        } else{
            print("ℹ️ No Phoneme data available")
        }
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase)
    {
        print("chartValueNothingSelected")
    }
    
    //MARK: - Audio Play Operations
    func playTTS(for text:String)
    {
        guard !isRecordingOn else {
            return
        }
        
        if (speechSynthesizer.isSpeaking) {
            stopPlayingTTS()
        } else
        {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                //  try AVAudioSession.overrideOutputAudioPort(AVAudioSession.sharedInstance())
                
                let speechUtterance = AVSpeechUtterance(string: text)
                speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                speechUtterance.pitchMultiplier = 1.0
                speechUtterance.volume = 1.0
                speechSynthesizer.delegate = self
                speechSynthesizer.speak(speechUtterance)
                
            } catch let error {
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    func stopPlayingTTS() {
        if (isTTSSpeaking) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    @objc func playUserAudio(_ sender: UIButton)
    {
        //Dont Play if Recording is on.
        guard !isRecordingOn else {
            return
        }
        //Reset Expert Audio before playing user audio
        stopPlayingTTS()
        delegate?.setExpertSpeechButtonImage(set: false)
        delegate?.resetAudioButtonInCollectionView(at: answersList.count - 1)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        if let url = answersList[sender.tag].audio_url {
            playStreamAudio(for: url, of: sender)
         }
        else {
            print("❌ Audio Url is not available")
            }
            
        } catch let error {
            print(error.localizedDescription)
            
        }
    }
    
    
    func playStreamAudio( for url:String , of button:UIButton?)
    {
        //Dont Play if Recording is on.
        guard !isRecordingOn else {
            return
        }
        
        guard streamPlayer.timeControlStatus != .playing else {
            stopStreamPlaying()
//            if let playingIndexPath = playingIndexPath {
//                delegate?.reloadCellInCollectionView(at: [playingIndexPath], isPlaying: false)
//            }
            return
        }
        // let url = audioUrl //"http://192.168.71.11:7891/rec.wav"
       // let url = "http://192.168.71.11:7891/rec.wav"
       // let asset = AVURLAsset(url: URL(string: "http://192.168.71.11:7891/rec.wav")!)
       // asset.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
        let playerItem = AVPlayerItem(url: URL(string:url)!)
        // let playerItem = AVPlayerItem(asset: asset)
        streamPlayer = AVPlayer(playerItem:playerItem)
        streamPlayer.rate = 1.0;
        streamPlayer.volume = 1.0
        streamPlayer.play()
        isStreamPlaying = true
        
        if let button = button {
            let row : Int = (button.layer.value(forKey: "row")) as! Int
            playingIndexPath  = IndexPath(row: row, section: 0)
            
            if playingIndexPath?.row == 1001 {
                delegate?.updateExpertAudioButton(isPlaying: true)
            } else {
            delegate?.reloadCellInCollectionView(at: [playingIndexPath!], isPlaying: true)
            }
            
             NotificationCenter.default.addObserver(self, selector:#selector(playerDidFinishPlaying(_:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: streamPlayer.currentItem )
             //NotificationCenter.default.post(name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: streamPlayer.currentItem, userInfo: ["row" : row])
           
            //NotificationCenter.default.post(name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: streamPlayer.currentItem, userInfo: ["row":row])
           
            
        
        }

    }
    
    func stopStreamPlaying() {
        if(isStreamPlaying) {
            isStreamPlaying = false
            streamPlayer.pause()
            if let playingIndexPath = playingIndexPath {
                if playingIndexPath.row == 1001 {
                    delegate?.updateExpertAudioButton(isPlaying: false)
                } else {
                    delegate?.reloadCellInCollectionView(at: [playingIndexPath], isPlaying: false)
                }
            }

        }
    }
    
   @objc func playerDidFinishPlaying(_ notification: NSNotification) {
        print("playerDidFinishPlaying")
        isStreamPlaying = false
    if playingIndexPath?.row == 1001 {
        delegate?.updateExpertAudioButton(isPlaying: false)
    } else {
        delegate?.reloadCellInCollectionView(at: [playingIndexPath!], isPlaying: false)
    }
//    if let userInfo = notification.userInfo {
//        if let row = userInfo["row"] {
//
//        }
//   }

    
   // delegate?.reloadCellInCollectionView(at: [IndexPath(row: row, section: 0)], isPlaying: false)

   
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    func createAttributedText(forText words_Result:[WordResults]) -> NSMutableAttributedString
    {
        
        let attributedString = NSMutableAttributedString()
        for word in words_Result {
            var color: UIColor = UIColor.black
            
            if let score = word.score {
            if (score > 70.0) {
                color = UIColor(red: 8.0/255.0, green: 206.0/255.0, blue: 2.0/255.0, alpha: 1.0)
            } else if (score < 30.0) {
                color = UIColor(red: 255.0/255.0, green: 69.0/255.0, blue: 40.0/255.0, alpha: 1.0)
            }
            else{
                color = UIColor(red: 232.0/255.0, green: 224.0/255.0, blue: 0/255.0, alpha: 1.0)
                
                }
                
            }
            let attributedSubString = NSAttributedString(string: word.word!, attributes: [NSAttributedStringKey.foregroundColor : color])
            
            attributedString.append(attributedSubString)
            attributedString.append(NSAttributedString.init(string: " "))
        }
        
        return attributedString
        
    }

    func tapResponse(recognizer: UITapGestureRecognizer) -> (wordtoshow: TappedWord, details: (wordPhoneme:WordResults?, section:Int))
    {
        // var tappedWord = ""
        let textView:UITextView =  recognizer.view as! UITextView
        let location: CGPoint = recognizer.location(in: textView)
        
        let position:CGPoint = CGPoint(x: location.x, y: location.y)
        
        //get location in text from textposition at point
        let tapPosition: UITextPosition = textView.closestPosition(to: position )!
        
        var tappedWord : TappedWord = TappedWord(word: "", apperenceCount: 0)
        //fetch the word at this position (or nil, if not available)
        if let textRange = textView.tokenizer.rangeEnclosingPosition(tapPosition, with: UITextGranularity.word, inDirection: UITextLayoutDirection.right.rawValue)
        {
     
            print(textView.text(in: textRange)!)
            tappedWord = TappedWord(word: textView.text(in: textRange)!, apperenceCount: getTheAppreanceCount(for: textView.text(in: textRange)!, in:textView, within: textRange))
            return(tappedWord,getWordDataFromString(of: tappedWord))
        }
        return(tappedWord,getWordDataFromString(of: tappedWord))
    }
    
    func getTheAppreanceCount(for text:String, in textView: UITextView, within range:UITextRange) -> Int
    {
        
        // let start : UITextRange =
        let end =  textView.offset(from: textView.beginningOfDocument, to: range.start)
        let fullText = textView.text as NSString
        let subString = fullText.substring(with:NSRange(location: 0, length: end))
        print("Substring : \(subString)")
        
        let wordArray = subString.components(separatedBy: " ")
        var appreanceCount = 0
        for word in wordArray
        {
            if(word.count > 0 && word == text){
                print(word)
                appreanceCount += 1
            }
        }
        print("AppereanceCount \(appreanceCount)")
        return appreanceCount
    }
    
    func getWordDataFromString(of tappedWord:TappedWord) -> (wordPhoneme:WordResults?, section:Int)
    {
        var count = 0
        var section = 0
        if let  wordResults = selectedAnswer?.wordResults {
           
        for wordData in wordResults {
            if(wordData.word == tappedWord.word)
            {
                
                if(tappedWord.apperenceCount == count){
                    return (wordData,section)
                }
                count += 1
            }
            section += 1
        }
        }
        else {
             print("‼️ WordResult array is empty)")
        }
        return (nil,0)
    }
    
    func clearData()
    {
        scoreData.removeAll()
        answersList.removeAll()
        selectedAnswer = nil
        
    }
    
   
  // MARK: - TextView Delegate
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if(textView.text == "Type Here"){
            textView.text = ""
            textView.textColor = UIColor.white
        }
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
            if(textView.text == ""){
                textView.text = "Type Here"
                textView.textColor = UIColor.lightGray
            }
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

extension UITextView {

    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        UIMenuController.shared.isMenuVisible = false
        
        /*
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
        print("paste")
        return true
        }
        */
        return false
}
    
}
