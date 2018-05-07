//
//  TranslationVC_DataModel.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/12/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

 struct Comment {
    let comment: String
    let color: UIColor
    let range : ClosedRange<Int>
}


struct Word {
    let word: String
    let id: Int?
    let parentId: Int?
    let voice: String?
    let voiceTime : Array<VoiceTime>?
}

struct VoiceTime {
    let startTime : Double
    let endTime : Double
}

struct TappedWord {
    let word : String
    let apperenceCount: Int
}

class TranslationVC_DataModel: NSObject, UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate , UITextViewDelegate{
    
    
    var parentObject: TransDetailViewController!
    var wordArray : Array<Word>?
    var comments : Array<Comment>?
    var wordIndex: Int = 0
    var tappedWord : TappedWord?
    var wordResult : Word_Prediction?
    var player: AVAudioPlayer?
    var playTimer : Timer?
    
    //var correctionView: UITableView!
    var predictionData : Pronunciation_Prediction = Pronunciation_Prediction.init()
   
    //var engWordArray: Array<String>? = ["Hello World", "Good Morning" , "Good Night" , "Happy Birthday" , "Peace be on you" ]
    //var arbicWordArray: Array<String>? = ["مرحبا بالعالم", "صباح الخير" , "تصبح على خير" , "عيد مولد سعيد" , "صلى عليك" ]

    var engWordArray = [Word(word: "Hello World", id: 0, parentId: 1 , voice: "hello_world", voiceTime:[VoiceTime(startTime: 0.0, endTime: 1.0),VoiceTime(startTime: 1.0, endTime: 2.0)]) ,
                        Word(word: "Good Morning" ,id: 1, parentId: 1 , voice: "good_morning" , voiceTime:[VoiceTime(startTime: 0.0, endTime: 0.8),VoiceTime(startTime: 0.8, endTime: 2.0)]) ,
                        Word(word: "Good Night" ,id: 2, parentId: 1 , voice: "good_night" , voiceTime:[VoiceTime(startTime: 0.0, endTime: 0.5),VoiceTime(startTime: 0.5, endTime: 2.0)]) ,
                        Word(word: "Happy Birthday" ,id: 3, parentId: 1 , voice: "happy_birthday" , voiceTime:[VoiceTime(startTime: 0.0, endTime: 1.7),VoiceTime(startTime: 1.7, endTime: 2.2)]) ,
                        Word(word: "Happy Christmas and Happy New Year" , id: 4 , parentId: 1 ,voice: "happy_christmas", voiceTime:[VoiceTime(startTime: 0.5, endTime: 1.0),VoiceTime(startTime: 1.0, endTime: 1.5),VoiceTime(startTime: 1.7, endTime: 1.8),VoiceTime(startTime: 1.8, endTime: 2.3),VoiceTime(startTime: 2.2, endTime: 2.4),VoiceTime(startTime: 2.4, endTime: 3.0)]) ]
    
    var arbicWordArray = [Word(word: "مرحبا بالعالم" ,id: 0, parentId: 1 , voice: "hello_world", voiceTime:[VoiceTime(startTime: 0.0, endTime: 1.0),VoiceTime(startTime: 1.0, endTime: 2.0)]) ,
                        Word(word: "عيد مولد سعيد" , id: 1, parentId: 1 ,voice: "good_morning",voiceTime:[VoiceTime(startTime: 0.0, endTime: 1.0),VoiceTime(startTime: 1.0, endTime: 2.0)]) ,
                        Word(word: "تصبح على خير" , id: 2, parentId: 1 ,voice: "good_night",voiceTime:[VoiceTime(startTime: 0.0, endTime: 1.0),VoiceTime(startTime: 1.0, endTime: 2.0)]) ,
                        Word(word: "صباح الخير" , id: 3, parentId: 1 , voice: "happy_birthday",voiceTime:[VoiceTime(startTime: 0.0, endTime: 1.0),VoiceTime(startTime: 1.0, endTime: 2.0)]) ,
                        Word(word: "عيد ميلاد سعيد وسنة جديدة سعيدة" ,id: 4, parentId: 1 , voice: "happy_christmas",voiceTime:[VoiceTime(startTime: 0.0, endTime: 1.0),VoiceTime(startTime: 1.0, endTime: 2.0)]) ]
   
     var engcomments = [Comment(comment: "That was not even close!!! Please hear the actual voice and try again", color: UIColor(red: 243.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0), range: 0...25),
                            Comment(comment: "You need to improve. Please click on the word and check the phenome list and see where you went wrong.", color: UIColor(red: 253.0/255.0, green: 108.0/255.0, blue: 7.0/255.0, alpha: 1.0) , range: 25...50),
                            Comment(comment: "This was quite close. Well Done!!! Keep practicing to score above 85%", color: UIColor(red: 0.0/255.0, green: 120.0/255.0, blue: 255.0/255.0, alpha: 1.0) , range: 50...75),
                            Comment(comment: "Excellent !!! You are almost perfect now. Try other words and see how you do.", color: UIColor(red: 0/255.0, green: 163.0/255.0, blue: 0/255.0, alpha: 1.0) , range: 75...100)]
    
    var arbiccomments = [Comment(comment: "هذا لم يكن حتى قريبة !!! الرجاء سماع الصوت الفعلي وإعادة المحاولة", color: UIColor(red: 243.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0), range: 0...25),
                       Comment(comment: "تحتاج إلى تحسين. يرجى النقر على كلمة والتحقق من قائمة فينوم ونرى أين ذهبت خطأ.", color: UIColor(red: 253.0/255.0, green: 108.0/255.0, blue: 7.0/255.0, alpha: 1.0) , range: 25...50),
                       Comment(comment: "كان هذا قريبا جدا. أحسنت!!! الحفاظ على ممارسة ليسجل أعلى من %85", color: UIColor(red: 0.0/255.0, green: 120.0/255.0, blue: 255.0/255.0, alpha: 1.0) , range: 50...75),
                       Comment(comment: "ممتاز !!! كنت تقريبا مثالية الآن. حاول كلمات أخرى ونرى كيف تفعل.", color: UIColor(red: 0/255.0, green: 163.0/255.0, blue: 0/255.0, alpha: 1.0) , range: 75...100)]
    
    
    //var wordsAudio: Array<String>?  = ["hello_world","good_morning","good_night","happy_birthday","peace_be_on_you"]
    
     // MARK: - TableView Delegate
    override init() {
        print("Data Model initialised")
        super.init()
        self.reloadScreen()
        /*var info: NSDictionary?
        if let path = Bundle.main.path(forResource: "Settings", ofType: "plist") {
           info = NSDictionary(contentsOfFile: path)
            print(info!["Language"])
        }
        */
     
    }
    
    func reloadScreen() {
        if (Settings.sharedInstance.language == "English") {
            wordArray =  engWordArray
            comments = engcomments
        }
        else{
            wordArray =  arbicWordArray
            comments = arbiccomments
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        for wordData in predictionData.words_Result! {
//            if(wordData.word == self.wordToShow)
//            {
//                self.wordResult = wordData
//                return max((wordData.predicted_phonemes?.count)!, (wordData.word_phonemes?.count)!)
//
//            }
//        }
        
        if let wordData = getWordDataFromString(tappedWord: self.tappedWord!)
        {
            self.wordResult = wordData
            return max((wordData.predicted_phonemes?.count)!, (wordData.word_phonemes?.count)!)

        }
        
        
       // var word_Result: Word_Prediction  =  predictionData.words_Result![section] as! Word_Prediction
       // return max((word_Result.predicted_phonemes?.count)!, (word_Result.word_phonemes?.count)!)
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        headerView.backgroundColor = UIColor.white
        
        //let menuHeaderLabel = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.frame.size.width, height: 28))
        let originalLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width/2 - 40, height: 28))
        //var word_Result: Word_Prediction  =  predictionData.words_Result![section] as! Word_Prediction
        originalLabel.text = "Original"
        originalLabel.font = UIFont(name: "Futura-Bold", size: 18.0)
        originalLabel.textAlignment = NSTextAlignment.center
        // originalLabel.backgroundColor = UIColor.red
        headerView.addSubview(originalLabel)
        
        let predictionLabel = UILabel(frame: CGRect(x: tableView.frame.size.width/2, y: 0, width: tableView.frame.size.width/2 - 40, height: 28))
        predictionLabel.text = "Prediction"
        predictionLabel.font = UIFont(name: "Futura-Bold", size: 18.0)
        predictionLabel.textAlignment = NSTextAlignment.center
       // predictionLabel.backgroundColor = UIColor.green
        headerView.addSubview(predictionLabel)
        
        
        let originalsound = UIButton(frame: CGRect(x: originalLabel.frame.origin.x + originalLabel.frame.size.width , y: 0, width: 25, height: 25))
        originalsound.setImage(UIImage.init(named: "sound.png"), for: UIControlState.normal)
        originalsound.tag = 1
        originalsound.addTarget(self, action: #selector(playVoice), for: UIControlEvents.touchUpInside)
         //headerView.addSubview(originalsound)
        
        let predictionsound = UIButton(frame: CGRect(x: predictionLabel.frame.origin.x + predictionLabel.frame.size.width , y: 0, width: 25, height: 25))
        predictionsound.setImage(UIImage.init(named: "sound.png"), for: UIControlState.normal)
        predictionsound.tag = 2
        predictionsound.addTarget(self, action: #selector(playVoice), for: UIControlEvents.touchUpInside)
       // headerView.addSubview(predictionsound)

        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
         let cell = tableView.dequeueReusableCell(withIdentifier: "report", for: indexPath) as! ReportCell
        //var word_Result: Word_Prediction  =  predictionData.words_Result![indexPath.section] as! Word_Prediction
        //cell.character.text = ""
        
        
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
    
    
    @objc func playVoice(sender: UIButton) -> Void {
        if(sender.tag == 1)
        {
            let word: Word = wordArray![wordIndex]
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: word.voice, ofType: "wav")!)
            
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    //  try AVAudioSession.overrideOutputAudioPort(AVAudioSession.sharedInstance())
                    
                    try! player = AVAudioPlayer(contentsOf: url)
                    
                    //wordToShow
                    let wordArray  = word.word.components(separatedBy: " ")
                    var wordIndex = 0
                   // if(!wordArray.contains(where: {(($0 as? String)?.localizedCaseInsensitiveCompare(tappedWord?.word!) ?? .orderedAscending) == .orderedSame }))
                    
                    
                   /*
                    if(wordArray.contains(where: {(($0 as? String)?.localizedCaseInsensitiveCompare(tappedWord?.word!) ?? .orderedAscending) == .orderedSame }))
                    {
                        return
                    }*/
                    
                    for word in wordArray
                    {
                        if(word.lowercased() == tappedWord?.word)
                        {
                            break;
                        }
                        wordIndex += 1
                    }
                    
                    player?.currentTime = word.voiceTime![wordIndex].startTime
                    player!.prepareToPlay()
                    player!.play()
                    playTimer = Timer.scheduledTimer(timeInterval:(word.voiceTime![wordIndex].endTime - word.voiceTime![wordIndex].startTime)
                        , target: self, selector: #selector(stopVoicePlayBack), userInfo: nil, repeats: false)
                    
                    // playTimer?.fire()
                    //player?.perform(#selector(self.stopVoicePlayBack), with: nil, afterDelay: 1.0)
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                let alert = UIAlertController(title: "Alert", message: "Please record the word using the record button first and then play.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                parentObject.present(alert, animated: true, completion: nil)
                
            }
            
            
        }
        else if (sender.tag == 2)
        {
            
        }
    }
    
    @objc func stopVoicePlayBack(){
        print("Stop Play")
        player?.stop()
        playTimer?.invalidate()

    }
    func fetchComment(score: Int) -> Comment {
        var commentToReturn : Comment?
        for comment in comments!
        {
            if(comment.range.contains(score)){
            commentToReturn = comment
            }
        }
        return commentToReturn!
    }
    
    func resetTextViewContent(textView: UITextView) {
        var topCorrect: CGFloat = (parentObject.wordTextView.bounds.size.height - parentObject.wordTextView.contentSize.height * parentObject.wordTextView.zoomScale)/2.0;
        topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
        textView.contentOffset = CGPoint.init(x: 0, y: -topCorrect)
    }
    
    func tapResponse(recognizer: UITapGestureRecognizer) -> (wordtoshow: TappedWord, word: Word_Prediction?)
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
     //   let textRange: UITextRange = textView.tokenizer.rangeEnclosingPosition(tapPosition, with: UITextGranularity.word, inDirection: UITextLayoutDirection.right.rawValue)
            
           // tappedWord  = textView.text(in: textRange)!
            print(textView.text(in: textRange)!)
            tappedWord = TappedWord(word: textView.text(in: textRange)!, apperenceCount: getTheAppreanceCount(for: textView.text(in: textRange)!, in: textRange))
            return(tappedWord,getWordDataFromString(tappedWord: tappedWord))
        }
//        if let word = getWordDataFromString(wordString: tappedWord)
//        {
//            return (tappedWord , word)
//        }
        
        
        return(tappedWord,getWordDataFromString(tappedWord: tappedWord))
    }
    
    
    func getWordDataFromString(tappedWord:TappedWord) -> Word_Prediction?
    {
        var count = 0
        for wordData in predictionData.words_Result! {
            if(wordData.word == tappedWord.word)
            {
               
                if(tappedWord.apperenceCount == count){
                return wordData
                }
                count += 1
            }
            
        }
      return nil
    }
    
    
    func getTheAppreanceCount(for text:String, in range:UITextRange) -> Int
    {
        
        // let start : UITextRange =
        let end =  parentObject.wordTextView.offset(from: parentObject.wordTextView.beginningOfDocument, to: range.start)
        let fullText = parentObject.wordTextView.text as NSString
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
 // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
    }
 
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        parentObject.wordLabel.text = textField.text
        return true
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if(textView == parentObject.typeTextView)
        {
            resetTextViewContent(textView: parentObject.typeTextView)
            return true
        }
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView == parentObject.typeTextView)
        {
            resetTextViewContent(textView: parentObject.typeTextView)
            
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text.count == 1)
        {
            resetTextViewContent(textView: parentObject.typeTextView)
            
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView == parentObject.typeTextView)
        {
        parentObject.wordTextView.text = textView.text
        parentObject.showTextField()
        resetTextViewContent(textView: parentObject.wordTextView)
        }
       
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
