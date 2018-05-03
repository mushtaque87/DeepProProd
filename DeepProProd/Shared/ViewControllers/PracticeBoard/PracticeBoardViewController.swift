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


enum resultViewType  :  Int {
    case score
    case graph
    case phenomeTable
}

class PracticeBoardViewController : UIViewController, AVAudioRecorderDelegate , AVAudioPlayerDelegate, PracticeBoardProtocols {
   

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var expert_AudioButton: UIButton!
  
    @IBOutlet weak var scoreCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    var tasktype : TaskType = .assignment
    
    @IBOutlet weak var phonemeTable: UITableView!
    
    
   //Record Button
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
    var phenomeTableIsVisible: Bool = false
    
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
        
        let rightswipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeResultType(sender:)))
        rightswipeGesture.direction = .right
        rightswipeGesture.cancelsTouchesInView = false
        resultView.addGestureRecognizer(rightswipeGesture)
        
        
        let leftswipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeResultType(sender:)))
        leftswipeGesture.direction = .left
        leftswipeGesture.cancelsTouchesInView = false
        resultView.addGestureRecognizer(leftswipeGesture)
        
        /*
        let rightswipeGestureForGraph = UISwipeGestureRecognizer(target: self, action: #selector(changeResultType(sender:)))
        rightswipeGestureForGraph.direction = .right
        barChartView.addGestureRecognizer(rightswipeGestureForGraph)
        
        let leftswipeGestureForGraph = UISwipeGestureRecognizer(target: self, action: #selector(changeResultType(sender:)))
        leftswipeGestureForGraph.direction = .left
        barChartView.addGestureRecognizer(leftswipeGestureForGraph)
        */
        
        
        //self.wordPhenome_Table.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "report")
        //self.addSubview(wordPhenome_Table)
        
        //textView.layer.cornerRadius = 15
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.borderWidth = 1
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
        
    }

    override func viewDidAppear(_ animated: Bool) {
       // resetTextViewContent(textView: textView)
        textView.text = viewModel.unitList[unitIndex].question_text
        resetTextViewContent(textView: textView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      

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
            ServiceManager().getAssignmentsUnitsAnswers(forUnit:self.viewModel.unitList[index].unit_id!, ofAssignment:self.assignmentId  , ofStudent: UserDefaults.standard.string(forKey: "uid")!, onSuccess: { response  in
                
               // let practiceBoardVC = PracticeBoardViewController(nibName:"PracticeBoardViewController",bundle:nil)
                // var unitAnswers = [UnitAnswers]()
                for count in 0..<response.count{
                    if let base =  response[count].base {
                        self.viewModel.answersList.append(base)
                        self.viewModel.scoreData.append(base.score!)
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
            
        default:
            ServiceManager().getAssignmentsUnitsAnswers(forUnit:viewModel.unitList[index].unit_id!, ofAssignment:self.assignmentId  , ofStudent: UserDefaults.standard.string(forKey: "uid")!, onSuccess: { response  in
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
            
            let audioData =  try? Data(contentsOf: viewModel.getDocumentsDirectory().appendingPathComponent("recording.wav"))
            //let encodedString = audioData?.base64EncodedString()
            
            try grpcService.getWordPredictionFromGRPC(for:UserDefaults.standard.string(forKey: "uid")! ,assignment:self.assignmentId  , unit:self.viewModel.unitList[unitIndex].unit_id! , with: audioData!, and: textView.text!, onSuccess: {(response) in
                
               
                //Fill the Data
                self.viewModel.predictionData.words_Result?.removeAll()
                var unitAnswer : UnitAnswers?
                var wordResult = [WordResults]()
                for word in response.wordResults {
                  
                    /*let wordScore : Word_Prediction = Word_Prediction()
                    wordScore.word  = word.word
                    wordScore.word_score  = word.score
                    wordScore.word_phonemes = word.wordPhonemes
                    wordScore.predicted_phonemes = word.predictedPhonemes
                    self.viewModel.predictionData.words_Result?.append(wordScore)
                     */
                    wordResult.append(WordResults.init(score: Int(word.score) , word: word.word, wordPhonemes: word.wordPhonemes, predictedPhonemes: word.predictedPhonemes))
                }
                unitAnswer = UnitAnswers(score: Double(response.score) , predictJson: Prediction_result_json(wordResults: wordResult))
                if let unit = unitAnswer
                {
                self.viewModel.answersList.insert(unit, at: 0)
                self.viewModel.scoreData.append(unit.score!)
                }
                hud.hide(animated: true)
                
                self.scoreCollectionView.reloadData()
                self.updateGraph()
                
                
            }, onFailure: { error in

                hud.mode = MBProgressHUDMode.text
                hud.label.text = error as? String
                
            }, onComplete:  {
                hud.hide(animated: true)
            })
        } catch (let error) {
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
        print(viewModel.getDocumentsDirectory())
        
        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(PracticeBoardViewController.updateProgress), userInfo: nil, repeats: true)
        
        let audioFilename = viewModel.getDocumentsDirectory().appendingPathComponent("recording.wav")
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
        recordButton.setProgress(progress)
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
}
