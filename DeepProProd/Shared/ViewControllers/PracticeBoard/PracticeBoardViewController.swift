//
//  PracticeBoard.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 4/25/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import AVFoundation
import MBProgressHUD
import Charts
import  Alamofire
import gRPC


enum ResultViewType  :  Int {
    case score
    case graph
    case phenomeTable
}

class PracticeBoardViewController : UIViewController, AVAudioRecorderDelegate , AVAudioPlayerDelegate, PracticeBoardProtocols {
   

    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var expert_AudioButton: UIButton!
    @IBOutlet weak var scoreCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    var tasktype : TaskType = .freeSpeech
    var audioFolderPath: String?
    var currentResultViewType:ResultViewType = .score
    @IBOutlet weak var showResultTypeButton: UIButton!
    @IBOutlet weak var phonemeTable: UITableView!
    @IBOutlet weak var keyboard: UIButton!
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var clearButton: UIButton!
    
   //Record Button
    let speechSynthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var recordButton: RecordButton!
    var progressTimer : Timer!
    var progress : CGFloat! = 0
    
    
    //Bar Graph
    @IBOutlet weak var barChartView: BarChartView!
    
    
    
    var viewModel = PracticeViewModel()
    var unitIndex = 0;
    var assignmentId = 0;
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer?
    var streamPlayer = AVPlayer()
    var phenomeTableIsVisible: Bool = false
    var currentSessionRecordingCount: Int = 1
    let grpcService = GRPCServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phonemeTable.isHidden = true
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 102/255, green: 204/255, blue: 204/255, alpha: 0.9)
        viewModel.delegate = self
        self.scoreCollectionView.register(UINib(nibName: "Scores_Cell", bundle: nil), forCellWithReuseIdentifier: "scoresCell")
        scoreCollectionView.delegate = viewModel
        scoreCollectionView.dataSource = viewModel
        
        barChartView.backgroundColor =  UIColor.white
        
        
        fetchUnitAnswers(for: unitIndex)
        self.phonemeTable.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "report")
        phonemeTable?.delegate = viewModel
        phonemeTable?.dataSource = viewModel
        
        let rightswipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeWord(sender:)))
        rightswipeGesture.direction = .right
        //rightswipeGesture.cancelsTouchesInView = false
        textView.addGestureRecognizer(rightswipeGesture)
        
        
        let leftswipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeWord(sender:)))
        leftswipeGesture.direction = .left
        //leftswipeGesture.cancelsTouchesInView = false
        textView.addGestureRecognizer(leftswipeGesture)
        
        textView.delegate = viewModel


        //textView.layer.cornerRadius = 15
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1
        resetTextViewContent(textView: textView)
        
        recordingSession = AVAudioSession.sharedInstance()
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
        //scoreCollectionView.isHidden = true
        setBarGraph()
        displayResultType(to: currentResultViewType, from: .graph)
        keyboard.setImage(UIImage(named: "do-not-touch"), for: .normal)
        audioFolderPath = Helper.getAudioDirectory(for: tasktype)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(displayWordPhonemeSection(sender:)))
        textView.addGestureRecognizer(tapGesture)
        
        
        guard tasktype != TaskType.freeSpeech else {
            textView.text = "Type Here or there but type here only"
            textView.isEditable = false
            keyboard.isHidden = false
            //textView.isUserInteractionEnabled = true
            clearButton.isHidden = false
           
            return
        }
        
        textView.isEditable = false
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backFromPracticeBoard))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        //textView.isUserInteractionEnabled = false
        textView.text = viewModel.unitList[unitIndex].question_text
        resetTextViewContent(textView: textView)
        clearAllAudioFile()
    }

    override func viewDidAppear(_ animated: Bool) {
       // resetTextViewContent(textView: textView)
       /* guard tasktype != TaskType.freeSpeech else {
            return
        }
        textView.text = viewModel.unitList[unitIndex].question_text
        
         */
        resetTextViewContent(textView: textView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard tasktype == TaskType.freeSpeech else {
            //clearAllAudioFile()
            return
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUnitAnswers(for index: Int){
        //Validate if the answers is available then return back the
        
        
        let hud = MBProgressHUD.showAdded(to: resultView , animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Fetching Unit History. Please wait"
        
        switch tasktype {
        case .assignment:
            ServiceManager().getAssignmentsUnitsAnswers(forUnit:self.viewModel.unitList[index].id!, ofAssignment:self.assignmentId  , ofStudent: UserDefaults.standard.string(forKey: "uid")!, onSuccess: { response  in
                
               // let practiceBoardVC = PracticeBoardViewController(nibName:"PracticeBoardViewController",bundle:nil)
                // var unitAnswers = [UnitAnswers]()
                for count in 0..<response.count{
                    if let base =  response[count].base {
                        self.viewModel.answersList.append(base)
                        self.viewModel.scoreData.append(base.score!) // Used to store graph scores
                    }
                }
                
                hud.hide(animated: true)
                self.scoreCollectionView.reloadData()
                self.updateGraph()
               // self.navigationController?.pushViewController(practiceBoardVC, animated: true)
                
                
            }, onHTTPError: { (httperror) in
                hud.mode = MBProgressHUDMode.text
                hud.label.text = httperror.description
            }, onError: { (error) in
                hud.mode = MBProgressHUDMode.text
                hud.label.text = error.localizedDescription
            },onComplete: {
                hud.hide(animated: true)
            })
           break
        case .practice:
            ServiceManager().getAssignmentsUnitsAnswers(forUnit:viewModel.unitList[index].id!, ofAssignment:self.assignmentId  , ofStudent: UserDefaults.standard.string(forKey: "uid")!, onSuccess: { response  in
                hud.hide(animated: true)
            }, onHTTPError: { (httperror) in
                hud.mode = MBProgressHUDMode.text
                hud.label.text = httperror.description
            }, onError: { (error) in
                hud.mode = MBProgressHUDMode.text
                hud.label.text = error.localizedDescription
            },onComplete: {
                hud.hide(animated: true)
            })
            
            break
        default:
            print("FreeSpeech")
            hud.hide(animated: true)
            break
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

    func resetTextViewContent(textView: UITextView) {
        var topCorrect: CGFloat = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale)/2.0;
        topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
        textView.contentOffset = CGPoint.init(x: 0, y: -topCorrect)
    }
    
    @IBAction func playExpertVoice(_ sender: Any) {
        
        switch tasktype {
        case .assignment , .practice:
        if let audioUrl = viewModel.unitList[unitIndex].audio_url
        {
            let url = audioUrl //"http://192.168.71.11:7891/rec.wav"
            let playerItem = AVPlayerItem(url: URL(string:url)!)
            streamPlayer = AVPlayer(playerItem:playerItem)
            streamPlayer.rate = 1.0;
            streamPlayer.volume = 1.0
            streamPlayer.play()
        }
        else {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                //  try AVAudioSession.overrideOutputAudioPort(AVAudioSession.sharedInstance())
            
                let speechUtterance = AVSpeechUtterance(string: textView.text)
                speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                speechUtterance.pitchMultiplier = 1.0
                speechUtterance.volume = 1.0
                speechSynthesizer.speak(speechUtterance)
                
            } catch let error {
            print(error.localizedDescription)
                
            }
            
        }
            break
        case .freeSpeech:
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                //  try AVAudioSession.overrideOutputAudioPort(AVAudioSession.sharedInstance())
                
                let speechUtterance = AVSpeechUtterance(string: textView.text)
                speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                speechUtterance.pitchMultiplier = 1.0
                speechUtterance.volume = 1.0
                speechSynthesizer.speak(speechUtterance)
                
            } catch let error {
                print(error.localizedDescription)
                
            }
            break
        }
        
    }
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        if flag {
            player.stop()
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
         self.progressTimer.invalidate()
        if success {
                callGRPCService()
        } else {
            
        }
    }
    
    
    func callGRPCService()
    {
        // activityIndicator.isHidden = false
        // activityIndicator.startAnimating()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        // hud.label.text = "Predicting Score"
        
        do {
            let audioFilePath = URL(fileURLWithPath: audioFolderPath!).appendingPathComponent("recording\(currentSessionRecordingCount).wav")
            print(audioFilePath)
            
           // let audioData =  try? Data(contentsOf: viewModel.getDocumentsDirectory().appendingPathComponent(String(format:"recording\(currentSessionRecordingCount).wav")))
            
            let audioData =  try? Data(contentsOf: audioFilePath)
            
            //let encodedString = audioData?.base64EncodedString()
            if let audiodata = audioData {
                var unitId : Int = 0
                if tasktype != .freeSpeech {
                    unitId =  self.viewModel.unitList[unitIndex].id!
                    
                }
                grpcService.getWordPredictionFromGRPC(for:UserDefaults.standard.string(forKey: "uid")! ,assignment:self.assignmentId  , unit:unitId , with: audiodata, and: textView.text!, onSuccess: {(response) in
                
               
                //Fill the Data
                //self.viewModel.predictionData.words_Result?.removeAll()
                var unitAnswer : UnitAnswers?
                var wordResult = [WordResults]()
                for word in response.wordResults {
            
                    wordResult.append(WordResults.init(score: word.score , word: word.word, wordPhonemes: word.wordPhonemes, predictedPhonemes: word.predictedPhonemes))
                }
                //self.textView.attributedText =
                self.setAttributedText(with: self.viewModel.createAttributedText(forText: wordResult))
                
                //unitAnswer = UnitAnswers(score: Double(response.score) , predictJson: Prediction_result_json(wordResults: wordResult) )
                
                /*unitAnswer = UnitAnswers(score: Double(response.score), predictJson: Prediction_result_json(wordResults: wordResult) ,
                                         audio_url: self.viewModel.getDocumentsDirectory().appendingPathComponent(String(format:"recording\(self.currentSessionRecordingCount).wav")).absoluteString,
                                         submission_date:Date().timeIntervalSince1970 * 1000)
                */
                    
                
                unitAnswer = UnitAnswers(score: Double(response.score), predictJson: Prediction_result_json(wordResults: wordResult) ,
                                         audio_url: URL(fileURLWithPath:  self.audioFolderPath!).appendingPathComponent(String(format:"recording\(self.currentSessionRecordingCount).wav")).absoluteString,
                                         submission_date:Date().timeIntervalSince1970 * 1000)
                
                
                
                
                
                
                self.currentSessionRecordingCount += 1
                if let unit = unitAnswer
                {
               // self.viewModel.answersList.insert(unit, at: 0)
                self.viewModel.answersList.append(unit)
                self.viewModel.scoreData.append(unit.score!)
                }
                hud.hide(animated: true)
                
                self.viewModel.selectedAnswer = self.viewModel.answersList.last?.prediction_result_json
                self.phonemeTable.reloadData()
                
                self.scoreCollectionView.reloadData()
                self.scoreCollectionView?.scrollToItem(at: IndexPath(row: self.viewModel.answersList.count/3, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
               /* self.scoreCollectionView?.setContentOffset(CGPoint(x:
                0,  y: self.scoreCollectionView.contentSize.height - self.scoreCollectionView.bounds.size.height), animated: true)
                 */
                self.updateGraph()
                //self.clearData()
               // self.fetchUnitAnswers(for: self.unitIndex)
                
            }, onFailure: { error in

                hud.mode = MBProgressHUDMode.text
                hud.label.text = error as? String
                
            }, onComplete:  {
                hud.hide(animated: true)
            })
            } else {
                hud.mode = MBProgressHUDMode.text
                hud.label.text = "File is corrupted or cant be read. Try again."
                hud.hide(animated: true)
            }
            
        }
        catch (let error) {
            hud.mode = MBProgressHUDMode.text
            hud.label.text = error.localizedDescription
            print(error)
        }
            
        
    }
    
    @IBAction func recordAndPredict(_ sender: Any) {
        
        //viewModel.scoreData.insert(Double(arc4random_uniform(100)), at: 0)
        //scoreCollectionView.reloadData()
        //updateGraph()
        // return
        print("Recording: ", (sender as! RecordButton).buttonState == .recording)
        switch (sender as! RecordButton).buttonState {
        case .recording:
            //record()
            startRecording()
        case .idle:
            // stop()
            finishRecording(success: true)
        case .hidden:
            // stop()
            finishRecording(success: true)
        }
        
        /*
         if audioRecorder == nil {
         startRecording()
         } else {
         finishRecording(success: true)
         }
         */
        
    }
    
    /*
    @IBAction func fetchGRPCResponse(_ button: RecordButton) {
       // viewModel.scoreData.append(Double(Int(arc4random_uniform(101))))
        scoreCollectionView.reloadData()
        
        print("Recording: ", button.buttonState == .recording)
        switch button.buttonState {
        case .recording:
            //record()
            startRecording()
        case .idle:
           // stop()
            finishRecording(success: true)
        case .hidden:
           // stop()
            finishRecording(success: true)
        }
        
        /*
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
        */
    }
    */
 
    
    func startRecording() {
        
        
        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(PracticeBoardViewController.updateProgress), userInfo: nil, repeats: true)
        
            let audioFilename = URL(fileURLWithPath:audioFolderPath!).appendingPathComponent(String(format:"recording\(currentSessionRecordingCount).wav"))
           // let audioFilename = viewModel.getDocumentsDirectory().appendingPathComponent(String(format:"recording\(currentSessionRecordingCount).wav"))
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
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
    
        do {
    
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
            try! AVAudioSession.sharedInstance().setActive(true)
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            //recordButton.setImage(UIImage(named: "player_stop.png")!, for: UIControlState.normal)
            //recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
      
    }
    
    @objc func updateProgress() {
        
        let maxDuration = CGFloat(5) // Max duration of the recordButton
        
        progress = progress + (CGFloat(0.05) / maxDuration)
        if let recordButton = recordButton {
        recordButton.setProgress(progress)
        }
        if progress >= 1 {
            progress = 0
            // progressTimer.invalidate()
            // stop()
        }
        
    }
    
    // MARK: -  Graphs
    
    func setBarChart(values: [Double])-> BarChartData {
        //barChartView.noDataText = "You need to provide data for the chart."
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]) )
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Accuracy")
       // chartDataSet.colors = ChartColorTemplates.material()
        chartDataSet.colors = [UIColor(red: 31.0/255.0, green: 72.0/255.0, blue: 142.0/255.0, alpha: 1)]
        let chartData = BarChartData(dataSet: chartDataSet)
        if(values.count < 4){
            chartData.barWidth = 0.2
        }else{
            chartData.barWidth = 0.9
        }
        
        
        //barChartView.data = chartData
        return chartData
    }
    
    
    
    func setBarGraph() {
        barChartView.drawValueAboveBarEnabled = true
        barChartView.maxVisibleCount = 20
        barChartView.delegate = viewModel
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IntAxisValueFormatter()
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        //leftAxisFormatter.negativeSuffix = " $"
        //leftAxisFormatter.positiveSuffix = " $"
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.35
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        leftAxis.axisMaximum = 100
        
        
        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = false
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        
        /*
         let l = barProgressView.legend
         l.horizontalAlignment = .left
         l.verticalAlignment = .bottom
         l.orientation = .horizontal
         l.drawInside = false
         l.form = .circle
         l.formSize = 9
         l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
         l.xEntrySpace = 4
         */
        
        
      
        let ll = ChartLimitLine(limit: 85.0, label: "")
        barChartView.leftAxis.addLimitLine(ll)
        barChartView.drawValueAboveBarEnabled = true
        updateGraph()
        
    }
    
    func updateGraph()  {
        barChartView.data = setBarChart(values: viewModel.scoreData)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.fitBars = true
    }
    
    func reloadtable() {
        phonemeTable.reloadData()
    }
    
     // MARK: - Practice Board Action
    @objc func displayWordPhonemeSection (sender:UITapGestureRecognizer){
        
        guard viewModel.selectedAnswer != nil else {
            print("‼️ No answer is selected. Please select an answer")
            
            return
        }
        let tappedWord =  viewModel.tapResponse(recognizer: sender)
        displayResultType(to: .phenomeTable, from: currentResultViewType)
        self.phonemeTable.scrollToRow(at: IndexPath(row: 0, section: tappedWord.details.section), at: UITableViewScrollPosition.top, animated: true)
    
    }
    
    @IBAction func showResultType(_ sender: Any) {
     
        //let title = showResultTypeButton.title(for: .normal)
        switch currentResultViewType {
        case .score:
            displayResultType(to: .score, from: .graph)
            break
        case .phenomeTable:
            displayResultType(to: .score, from: currentResultViewType)
            break
        default:
            displayResultType(to: .graph, from: .score)
            break
        }
        
    }
    
    func displayResultType(to resultType: ResultViewType  , from currentType:ResultViewType)
    {
        currentResultViewType = currentType
        switch currentType {
        case .score:
            //showResultTypeButton.setTitle("S", for: .normal)
            showResultTypeButton.setImage(UIImage(named:"scoreTiles"), for: .normal)
            break
        case .phenomeTable:
            showResultTypeButton.setTitle("P", for: .normal)
            break
        default:
            //showResultTypeButton.setTitle("G", for: .normal)
            showResultTypeButton.setImage(UIImage(named:"graphButton"), for: .normal)

            break
        }
        
        switch resultType {
        case .score:
            scoreCollectionView.isHidden = false
            barChartView.isHidden = true
            phonemeTable.isHidden = true
            break
        case .phenomeTable:
            scoreCollectionView.isHidden = true
            barChartView.isHidden = true
            phonemeTable.isHidden = false
            break
        default:
            scoreCollectionView.isHidden = true
            barChartView.isHidden = false
            phonemeTable.isHidden = true
            break
        }

    }
    
    @objc func changeWord(sender:UISwipeGestureRecognizer){
       
        
        if(sender.direction == .right &&  unitIndex > 0) {
            unitIndex -= 1
            // wordLabel.slideInFromLeft()
            textView.slideInFromLeft()
        }
        else if (sender.direction == .left &&  unitIndex <= viewModel.unitList.count - 2) {
            // wordLabel.slideInFromRight()
            textView.slideInFromRight()
            unitIndex += 1
        }
        
        guard  unitIndex < viewModel.unitList.count else {
            return
        }
        // wordLabel.text = vc_DataModel.wordArray![vc_DataModel.wordIndex]
        
        let word  = viewModel.unitList[unitIndex]
        textView.text = word.question_text
        resetTextViewContent(textView: textView)
        clearData()
        fetchUnitAnswers(for: unitIndex)
        //
 
    }
    
    @objc func changeResultType(sender:UISwipeGestureRecognizer){
//        guard wordResultView?.isPhenomeTableVisible != true else {
//            return
//        }
        
        /*
        if phenomeTableIsVisible
        {
            phenomeTableIsVisible = false
            if(sender.direction == .right) {
                print("Show Score")
            }
            else if (sender.direction == .left) {
                    print("Show Graph")
                }
            

        }
         */
        
        
        if(sender.direction == .right) {
          print("Swipe Right")
            scoreCollectionView.isHidden = false
            barChartView.isHidden = true
            phonemeTable.isHidden = true
        }
        else if (sender.direction == .left) {
            print("Swipe Left")
            scoreCollectionView.isHidden = true
            barChartView.isHidden = true
            phonemeTable.isHidden = false
        }
    }
    
    func setAttributedText(with text:NSAttributedString) {
        self.textView.attributedText = text
        self.textView.textAlignment = NSTextAlignment.center
        self.textView.font = UIFont.boldSystemFont(ofSize: 18.0)
        self.resetTextViewContent(textView: self.textView)
    }
    
    func clearData()
    {
        viewModel.scoreData.removeAll()
        updateGraph()
        viewModel.answersList.removeAll()
        self.scoreCollectionView.reloadData()
        viewModel.selectedAnswer = nil
        reloadtable()
    }
   
    @IBAction func showKeyboard(_ sender: Any) {
        
        textView.isEditable = textView.isEditable ? !textView.isEditable : !textView.isEditable
        //textView.isUserInteractionEnabled = textView.isUserInteractionEnabled ? !textView.isUserInteractionEnabled : !textView.isUserInteractionEnabled
        if (textView.isEditable) {
            keyboard.setImage(UIImage(named: "do-not-touch.png"), for: .normal)
        } else {
            keyboard.setImage(UIImage(named: "keypad.png"), for: .normal)
        }
        print(textView.isUserInteractionEnabled)
        
    }
    
    @objc func backFromPracticeBoard() {
        clearAllAudioFile()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func clearTheScores(_ sender: Any) {
        clearData()
    }
    
    
    @objc func clearAllAudioFile() {

        let enumerator = FileManager.default.enumerator(atPath: URL(fileURLWithPath: audioFolderPath!).path)
        while let element = enumerator?.nextObject() as? String {
            // element is wav file
            if (element.hasSuffix(".wav")) {
                //print(element)
                do {
                    try FileManager.default.removeItem(at: URL(fileURLWithPath: audioFolderPath!).appendingPathComponent(element))
                } catch let error as NSError {
                    print("Error: \(error)")
                }
            }
            
        }
        
    }
    
    
    
    
}
