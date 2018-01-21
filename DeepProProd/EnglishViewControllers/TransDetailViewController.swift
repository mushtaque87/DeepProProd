//
//  TransDetailViewController.swift
//  ScreenTest
//
//  Created by Mushtaque Ahmed on 12/8/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import Charts
import AVFoundation
import  Alamofire

class TransDetailViewController: UIViewController, AVAudioRecorderDelegate , AVAudioPlayerDelegate, CAAnimationDelegate, ServiceProtocols {

    @IBOutlet var vc_DataModel: TranslationVC_DataModel!
    @IBOutlet weak var recordPlayView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var graphProgressView: LineChartView!
    @IBOutlet weak var barProgressView: BarChartView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordTextView: UITextView!
    @IBOutlet weak var typeTextView: UITextView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var wordResultView : wordResult_View?
    
    
    
    var months : [String]!
    var accuracy : [Double]! = []
    var trialCount : Int = 0
    var trials: [Int]! = []
   // var isGraphVisible: Bool = false
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer?
    
    
   
    
    
    
    
    //var pronunce_Prediction : Pronunciation_Prediction?
    // MARK: - UI View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        recordingSession = AVAudioSession.sharedInstance()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPhenomeTable(sender:)))
//        wordLabel.isUserInteractionEnabled = true
//        wordLabel.addGestureRecognizer(tapGesture)
        
        let rightswipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeWord(sender:)))
        rightswipeGesture.direction = .right
       // wordLabel.addGestureRecognizer(rightswipeGesture)
        wordTextView.addGestureRecognizer(rightswipeGesture)
        
        let leftswipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeWord(sender:)))
        leftswipeGesture.direction = .left
       // wordLabel.addGestureRecognizer(leftswipeGesture)
        wordTextView.addGestureRecognizer(leftswipeGesture)

        barProgressView.backgroundColor = UIColor.white
        
        
         wordResultView = wordResult_View(frame: CGRect(x: 10, y: wordLabel.frame.origin.y + wordLabel.frame.size.height/2 + 70 , width: 350, height: 400))
        
        wordResultView?.wordPhenome_Table.delegate = vc_DataModel
        wordResultView?.wordPhenome_Table.dataSource = vc_DataModel
        
        // VC_DataModel.liveEventTableView = correctionView
//        self.correctionView.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "report")
//        self.correctionView.delegate = vc_DataModel
//        self.correctionView.dataSource = vc_DataModel
        
       // pronunce_Prediction = Pronunciation_Prediction.init()
        
        
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                      //  self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
        
        // Do any additional setup after loading the view.
         //months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
         //accuracy = [12.0, 16.0,70.0, 40.0, 60.0, 30.0]
         //setChart(dataPoints: months, values: accuracy)
        
        
        if(Settings.sharedInstance.language == "English")
        {
        commentsLabel.text = "Record the above statement and we will help you pronunce it better !!"
        }
        else{
        commentsLabel.text = "تسجيل البيان أعلاه ونحن سوف تساعدك برونونس ذلك أفضل !!"
        }
        scoreLabel.text = "0 %"
        vc_DataModel.parentObject = self
        
        activityIndicator.isHidden = true
        //wordLabel.text = vc_DataModel.wordArray?[0]
        
        wordTextView.backgroundColor = UIColor.clear
        let word : Word = (vc_DataModel.wordArray?[0])!

        wordTextView.text  = word.word
        vc_DataModel.resetTextViewContent(textView: wordTextView)
        
        typeTextView.backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPhenomeTable(sender:)))
        wordTextView.isUserInteractionEnabled = true
        wordTextView.addGestureRecognizer(tapGesture)
        
         refreshUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshUI() {
        backgroundImage.setBackGroundimage()
    }
    
   // MARK: - UI Events and Actions
    
    @objc func changeWord(sender:UISwipeGestureRecognizer){
        if(sender.direction == .right &&  vc_DataModel.wordIndex > 0) {
            vc_DataModel.wordIndex -= 1
           // wordLabel.slideInFromLeft()
            wordTextView.slideInFromLeft()
        }
        else if (sender.direction == .left &&  vc_DataModel.wordIndex <= (vc_DataModel.wordArray?.count)! - 2) {
           // wordLabel.slideInFromRight()
            wordTextView.slideInFromRight()
            vc_DataModel.wordIndex += 1
        }
        
        
       // wordLabel.text = vc_DataModel.wordArray![vc_DataModel.wordIndex]
        let word : Word = vc_DataModel.wordArray![vc_DataModel.wordIndex]
        wordTextView.text = word.word
        vc_DataModel.resetTextViewContent(textView: wordTextView)
        clearData()
        print(vc_DataModel.wordArray![vc_DataModel.wordIndex])
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Animation Stopped")
    }
    
@objc func showPhenomeTable(sender:UITapGestureRecognizer){
        // ...
    
    //vc_DataModel.wordToShow =  vc_DataModel.tapResponse(recognizer: sender)
    if (vc_DataModel.predictionData.words_Result!.count < 1)
    {
    return
    }
    
    let tappedWord =  vc_DataModel.tapResponse(recognizer: sender)
    vc_DataModel.wordToShow = tappedWord.wordtoshow
    
    if(vc_DataModel.wordToShow!.count > 0 && tappedWord.word != nil)
    {
        wordResultView?.fillDetails(wordToShow: vc_DataModel.wordToShow!, wordscore: (tappedWord.word?.word_score)!)
    self.view.addSubview(wordResultView!)
    wordResultView?.wordPhenome_Table.reloadData()
    wordResultView?.showAnimate()
    }
    }
    
    
    func fillDescriptionView(word : String) -> Void {
       // commentView.isHidden = true
       // graphProgressView.isHidden = true
        //correctionView.isHidden = true
        wordLabel.text = word
        
    }
    
    func setChart(dataPoints: [Int], values: [Double]) {
        graphProgressView.isHidden = false
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i)  , y: values[i] , data: values[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Accuracy")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        graphProgressView.data = lineChartData
        
    }
    
    func setBarChart(values: [Double])-> BarChartData {
        //barChartView.noDataText = "You need to provide data for the chart."
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]) )
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Accuracy")
        //chartDataSet.colors = ChartColorTemplates.colorful()
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = 0.2
        
        //barChartView.data = chartData
        return chartData
    }
    
    
    
    func setBarGraph() {
        barProgressView.drawValueAboveBarEnabled = true
        barProgressView.maxVisibleCount = 100
        
        
        let xAxis = barProgressView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = IntAxisValueFormatter()
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        //leftAxisFormatter.negativeSuffix = " $"
        //leftAxisFormatter.positiveSuffix = " $"
        
        let leftAxis = barProgressView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = barProgressView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = barProgressView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        
        
        
        barProgressView.data = setBarChart(values: accuracy)
        barProgressView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        let ll = ChartLimitLine(limit: 85.0, label: "Target")
        barProgressView.rightAxis.addLimitLine(ll)
        barProgressView.drawValueAboveBarEnabled = true
        
    }
    
    
    @IBAction func closeScreen()
    {
        dismiss(animated: true, completion: nil)

    }
    
//    func loadRecordingUI() {
//        recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
//        recordButton.setTitle("Tap to Record", for: .normal)
//        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
//        recordButton.addTarget(self, action: #selector(record), for: .touchUpInside)
//        view.addSubview(recordButton)
//    }
//
    @IBAction func record()
    {
        
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
        
        
    }
    
    func startRecording() {
        let audioFilename = vc_DataModel.getDocumentsDirectory().appendingPathComponent("recording.wav")
       print(audioFilename)
        do {
            try FileManager.default.removeItem(at: audioFilename)
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
        
        let settings = [
        AVFormatIDKey: Int(kAudioFormatLinearPCM),
        AVSampleRateKey: 16000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        try! AVAudioSession.sharedInstance().setActive(true)
        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder.delegate = self
        audioRecorder.record()
        recordButton.setImage(UIImage(named: "player_stop.png")!, for: UIControlState.normal)
        //recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        commentView.isHidden = false
        graphProgressView.isHidden = false
        
        if success {
            //recordButton.setTitle("Tap to Re-record", for: .normal)
            recordButton.setImage(UIImage(named: "microphonedisabled.png")!, for: UIControlState.normal)
            verifyRecording()
        } else {
            //recordButton.setTitle("Tap to Record", for: .normal)
            recordButton.setImage(UIImage(named: "microphonedisabled.png")!, for: UIControlState.normal)

            // recording failed :(
        }
    }
    
    
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    
    
    func verifyRecording()  {
        //  var services:ServiceManager = ServiceManager()
        //  services.testThatUploadingMultipartForm(file:getDocumentsDirectory().appendingPathComponent("recording.wav"))

        
      
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let serviceManager = ServiceManager()
            serviceManager.delegate = self
            serviceManager.sendAudioForPrediction(file:vc_DataModel.getDocumentsDirectory().appendingPathComponent("recording.wav") , text: wordTextView.text!)
            
        }
    
    
    func returnPredictionValue(response: DataResponse<Any>) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        do {
            
            if (response.result.isFailure) {
                let alert = UIAlertController(title: "Alert", message: "The server didnt respond back. Can you please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
    
                // Dummy Data
//                let filePath = Bundle.main.url(forResource: "Json", withExtension: "")
//                let data: Data = try Data.init(contentsOf: filePath!)
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
//                print(json)
      
            
                //Uncomment for server
                let json = response.result.value as! NSDictionary

                if let rating = json["rating"] as? [String: Any], let word_results: Array<[String: Any]> = rating["word_results"] as? Array<[String: Any]>  {
                
                vc_DataModel.predictionData.total_score =  rating["total_score"] as! Float
//
//                print(word_results.count)
//                print(word_results[0])
//                print(word_results[0]["word"])
//                print(word_results[0]["word_score"])
//                print(word_results[0]["predicted_phonemes"])
//                print(word_results[0]["word_phonemes"])
                
                
                //Fill the Data
                vc_DataModel.predictionData.words_Result?.removeAll()
                for word in word_results {
                    let wordScore : Word_Prediction = Word_Prediction()
                    wordScore.word  = word["word"] as? String
                    wordScore.word_score  = word["word_score"] as! Float
                    wordScore.word_phonemes = word["word_phonemes"] as? Array<String>
                    wordScore.predicted_phonemes = word["predicted_phonemes"] as? Array<String>
                    vc_DataModel.predictionData.words_Result?.append(wordScore)
                    
                }
                
                
                //Color the Words
                    let attributedText = NSMutableAttributedString.init(string: (wordTextView.text?.lowercased())!)
                for wordResult in (vc_DataModel.predictionData.words_Result)! {
                    let range = (wordTextView.text!.lowercased() as NSString).range(of: wordResult.word!)
                    if (wordResult.word_score > 70) {
                        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 0/255.0, green: 124/255.0, blue: 0/255.0, alpha: 1.0) , range: range)
                    } else if (wordResult.word_score < 30) {
                        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 180.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0) , range: range)
                    }
                    else{
                        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue , range: range)
                    }
                    
                }
                wordTextView.attributedText = attributedText
                wordTextView.font = UIFont.boldSystemFont(ofSize: 28.0)
                wordTextView.textAlignment = NSTextAlignment.center
                vc_DataModel.resetTextViewContent(textView: wordTextView)
                
                
                //Show the total Score
                commentView.isHidden = false
                scoreLabel.text = String.init(format: "%.1f ", (vc_DataModel.predictionData.total_score))
                let comment = vc_DataModel.fetchComment(score: Int(vc_DataModel.predictionData.total_score))
                commentsLabel.text = comment.comment
                commentsLabel.textColor = comment.color
                
                //Fill Line Graph
                trialCount += 1
                trials.append(trialCount)
                let totalScore: Double = rating["total_score"] as! Double
                accuracy.append(totalScore)
                
                
                
                //setChart(dataPoints: trials, values: accuracy)
                setBarGraph()
                
                
                //Show the Word Report
                //VC_DataModel.predictionData = pronunce_Prediction!;
                //correctionView.isHidden = true
                // correctionView.reloadData()
            }
            
            //let word_result: Array = (json["rating"]!["word_results"])
            //print(word_result)
            
            
            } //else
        
        } catch let error as NSError {
           // print("Failed reading from URL: \(filePath), Error: " + error.localizedDescription)
    }
    }
    
    @IBAction func showTextField()
    {
        if (typeTextView.isHidden) {
            typeTextView.isHidden = false
            wordLabel.isHidden = true
            wordLabel.isUserInteractionEnabled = false
            wordTextView.isHidden = true
            wordTextView.isUserInteractionEnabled = false
        }
        else{
            typeTextView.isHidden = true
            wordLabel.isHidden = true
            wordLabel.isUserInteractionEnabled = false
            wordTextView.isHidden = false
            wordTextView.isUserInteractionEnabled = true
            
        }
    }
    
    
    
    
    
    @IBAction func playTheText()
    {
        let word: Word = vc_DataModel.wordArray![vc_DataModel.wordIndex]
        if(word.word.lowercased() == wordTextView.text.lowercased() )
        {
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: word.voice, ofType: "wav")!)
        print(alertSound)
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        try! player = AVAudioPlayer(contentsOf: alertSound)
        player!.prepareToPlay()
        player!.play()
        }

        }
        

    
    @IBAction func playTheRecording()
    {
       
          //  guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else { return }
            let url = vc_DataModel.getDocumentsDirectory().appendingPathComponent("recording.wav")
            print(url)
            if FileManager.default.fileExists(atPath: url.path) {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
              //  try AVAudioSession.overrideOutputAudioPort(AVAudioSession.sharedInstance())
                
                try! player = AVAudioPlayer(contentsOf: url)
                player!.prepareToPlay()
                player!.play()
                
               // let player = try AVAudioPlayer(contentsOf: url)
               // guard let player = player else { return }
                //player.prepareToPlay()
                //player.delegate = self
               // player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
            } else {
                let alert = UIAlertController(title: "Alert", message: "Please record the word using the record button first and then play.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
        }
        
        
    }
    
    func clearData()
    {
        accuracy.removeAll()
        setBarGraph()
        
        vc_DataModel.predictionData.words_Result?.removeAll()
        wordTextView.textColor = UIColor.white
        let audioFilename = vc_DataModel.getDocumentsDirectory().appendingPathComponent("recording.wav")
        do {
            try FileManager.default.removeItem(at: audioFilename)
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
    }
    
    @IBAction func showTheGraph()
    {
        if(barProgressView.isHidden){
            barProgressView.isHidden = false
            barProgressView.slideInFromRight()
            self.view.bringSubview(toFront: barProgressView)
        } else {
            barProgressView.slideInFromLeft()
            barProgressView.isHidden = true
        }
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        if flag {
            player.stop()
        }
        
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
