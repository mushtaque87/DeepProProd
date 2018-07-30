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
import RxSwift
import RxCocoa

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
    var tasktype : TaskType = .freeText
    var audioFolderPath: String?
    var currentResultViewType:ResultViewType = .score
    @IBOutlet weak var showResultTypeButton: UIButton!
    @IBOutlet weak var phonemeTable: UITableView!
    @IBOutlet weak var keyboard: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var closPhonemeTableButton: UIButton!
    
    @IBOutlet weak var clearTextButton: UIButton!
    //Record Button
    @IBOutlet weak var recordButton: RecordButton!
    var progressTimer : Timer!
    var progress : CGFloat! = 0
    
    
    //Bar Graph
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    
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
        edgesForExtendedLayout = []
        self.navigationItem.title = "Practice"
        phonemeTable.isHidden = true
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 38/255, green: 78/255, blue: 142/255, alpha: 0.9)
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
        textView.tintColor = UIColor.white

        //textView.layer.cornerRadius = 15
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1
        resetTextViewContent(textView: textView)
        
        scoreCollectionView.layer.borderColor = UIColor.white.cgColor
        scoreCollectionView.layer.borderWidth = 1
        
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
        setLinegraph()
        displayResultType(to: currentResultViewType, from: .graph)
        keyboard.setImage(UIImage(named: "pencil-edit.png"), for: .normal)
        audioFolderPath = Helper.getAudioDirectory(for: tasktype)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(controlKeyboard(sender:)))
        singleTapGesture.numberOfTapsRequired = 2
        textView.addGestureRecognizer(singleTapGesture)
        
        
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(displayWordPhonemeSection(sender:)))
//        longPress.minimumPressDuration = 0.1
//        textView.addGestureRecognizer(longPress)
        
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(displayWordPhonemeSection(sender:)))
        doubleTapGesture.numberOfTapsRequired = 1
        textView.addGestureRecognizer(doubleTapGesture)
        
        //singleTapGesture.require(toFail: doubleTapGesture)
        
         doubleTapGesture.require(toFail: singleTapGesture)
        
        
        //let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(displayWordPhonemeSection(sender:)))
        //textView.addGestureRecognizer(longPressGesture)
        
       // _ = viewModel.isSpeaking.bind(to: expert_AudioButton.rx.image(for: .normal))
        //expert_AudioButton.rx.image().
       
        guard tasktype != TaskType.freeText else {
            textView.text = "Type Here"
            keyboard.setImage(UIImage(named: "pencil-edit.png"), for: .normal)
            textView.isEditable = true
            keyboard.isHidden = true
            feedbackButton.isHidden = true
            textView.isSelectable = true
            textView.inputView?.resignFirstResponder()
            //textView.isUserInteractionEnabled = true
            clearButton.isHidden = false
           clearTextButton.isHidden = true
            return
        }
        clearTextButton.isHidden = true
        feedbackButton.isHidden = false
         keyboard.isHidden = true
        textView.isEditable = false
        

//        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backFromPracticeBoard))
//        self.navigationItem.leftBarButtonItem = newBackButton
        
        //textView.isUserInteractionEnabled = false
        textView.text = viewModel.unitList[unitIndex].question_text
        resetTextViewContent(textView: textView)
        clearAllAudioFile()
        
        expert_AudioButton.layer.setValue(1001, forKey: "row")
        setTheme()
    }

    
    func setTheme() {
       
        /*let colors = ThemeManager.sharedInstance.color
        self.view.backgroundColor = UIColor.clear
        let backgroundLayer = colors?.gl
        backgroundLayer?.frame = self.view.bounds
        self.view.layer.insertSublayer(backgroundLayer!, at: 0)
        */
        
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!,alpha: 0.5)
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.font_Color!)]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTheme()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       //
        
        
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
       // resetTextViewContent(textView: textView)
       /* guard tasktype != TaskType.freeSpeech else {
            return
        }
        textView.text = viewModel.unitList[unitIndex].question_text
        
         */
        resetTextViewContent(textView: textView)
        setTheme()
    }
  
    
    override func viewDidDisappear(_ animated: Bool) {
        guard tasktype == TaskType.freeText else {
            //clearAllAudioFile()
            return
        }
        
        displayResultType(to: .score, from: .graph)
        
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
        case .content:
        ServiceManager().getUnitsAnswer(for:self.viewModel.unitList[index].id!, ofStudent: UserDefaults.standard.string(forKey: "uid")!, onSuccess: { response  in
            
            // let practiceBoardVC = PracticeBoardViewController(nibName:"PracticeBoardViewController",bundle:nil)
            // var unitAnswers = [UnitAnswers]()
            for count in 0..<response.count{
                if let base =  response[count].base {
                    self.viewModel.answersList.append(base)
                    self.viewModel.scoreData.append(base.score!) // Used to store graph scores
                }
            }
            
            hud.hide(animated: true)
            self.reloadCollectionView()
            //self.updateGraph()
            //self.showTheGraph()
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
        default:
            print("FreeSpeech")
            hud.hide(animated: true)
            break
        }
        
        /*
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
                self.reloadCollectionView()
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
 */
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
        //viewModel.stopStreamPlaying()
        
        switch tasktype {
        case .content:
//           viewModel.playStreamAudio(for: "")
//           return
           
            /*
            guard case let audioUrl: String = viewModel.unitList[unitIndex].audio_url! , audioUrl.count > 0 else {
                print("Play TTS")
                viewModel.playTTS(for: textView.text)
                return
            }
            
            viewModel.playStreamAudio(for: audioUrl, of: sender as? UIButton)
           */
            if let audioUrl = viewModel.unitList[unitIndex].audio_url
            {
                guard !audioUrl.isEmpty else {
                    viewModel.playTTS(for: textView.text)
                    return
                }
                viewModel.playStreamAudio(for: audioUrl, of: sender as? UIButton)
                
            }  else {
            viewModel.playTTS(for: textView.text)
            }
            
            break
        case .freeText:
            viewModel.playTTS(for: textView.text)
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
        viewModel.isRecordingOn = false
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
                if tasktype != .freeText {
                    unitId =  self.viewModel.unitList[unitIndex].id!
                    
                }
                grpcService.getWordPredictionFromGRPC(for:UserDefaults.standard.string(forKey: "uid")!, unit:unitId , with: audiodata, and: textView.text!, onSuccess: {(response) in
                
               
                //Fill the Data
                //self.viewModel.predictionData.words_Result?.removeAll()
                var unitAnswer : UnitAnswers?
                var wordResult = [WordResults]()
                for word in response.wordResults {
            
                    wordResult.append(WordResults.init(score: word.score , word: word.word, wordPhonemes: word.wordPhonemes, predictedPhonemes: word.predictedPhonemes))
                }
                //self.textView.attributedText =
                self.setAttributedText(with: self.viewModel.createAttributedText(forText: wordResult))
                    
                
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
                
                self.reloadCollectionView()
                self.scoreCollectionView?.scrollToItem(at: IndexPath(row: self.viewModel.answersList.count/3, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
               /* self.scoreCollectionView?.setContentOffset(CGPoint(x:
                0,  y: self.scoreCollectionView.contentSize.height - self.scoreCollectionView.bounds.size.height), animated: true)
                 */
                self.updateGraph()
                  //  self.showTheGraph()
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
        textView.resignFirstResponder()
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
        
        viewModel.stopPlayingTTS()
        viewModel.stopStreamPlaying()
        
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
            viewModel.isRecordingOn = true
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
    
    func setLineChartData(values: [Double])-> LineChartData {
        //barChartView.noDataText = "You need to provide data for the chart."
        
        //var yVals1 : NSMutableArray = NSMutableArray()
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<values.count
        {
            // let mult:Double = 100.0 / 2.0;
            // let val:Double = (Double) (arc4random_uniform(UInt32(mult))) + 50;
            //yVals1.add(ChartDataEntry.init(x: Double(i), y: values[i]))
            dataEntries.append(ChartDataEntry.init(x: Double(i), y: values[i]))
        }
        
        //data set 1
        let set1: LineChartDataSet = LineChartDataSet.init(values: dataEntries , label: "Accuracy")
        set1.axisDependency = .left;
        set1.setColor(UIColor(red: 31.0/255.0, green: 72.0/255.0, blue: 142.0/255.0, alpha: 1))
        set1.setCircleColor(UIColor(red: 31.0/255.0, green: 72.0/255.0, blue: 142.0/255.0, alpha: 1))
        set1.lineWidth = 4.0;
        set1.circleRadius = 8.0;
        set1.fillAlpha = 255.0/255.0;
        set1.fillColor = UIColor(red: 31.0/255.0, green: 72.0/255.0, blue: 142.0/255.0, alpha: 1)
            //UIColor(red:51.0/255.0, green:181.0/255.0 , blue:229.0/255.0, alpha:1.0)
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = true;
        
        
        /*
        let coloTop = UIColor.red.cgColor
        let colorBottom = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1).cgColor
        let gradientColors = [coloTop, colorBottom] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [0.7, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        set1.drawFilledEnabled = true
        */
        
        let data:LineChartData = LineChartData.init(dataSets: [set1])
        data.setValueTextColor(UIColor.black)
        data.setValueFont(UIFont.systemFont(ofSize: 9.0))
        
        return data
    }
    
    func setLinegraph() -> Void {
        
        //barProgressView.isHidden = true
        //graphProgressView.isHidden = false
        lineChartView.backgroundColor = UIColor.white
        let l: Legend = lineChartView.legend;
        l.form = .line;
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11.0)!
        l.textColor = UIColor.black;
        l.horizontalAlignment = .left;
        l.verticalAlignment = .bottom;
        l.orientation = .horizontal;
        l.drawInside = true;
        lineChartView.rightAxis.enabled = false
        
        let xAxis:XAxis = lineChartView.xAxis;
        xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 11.0)!
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = UIColor.black;
        xAxis.drawGridLinesEnabled = false;
        xAxis.drawAxisLineEnabled = true;
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = IntAxisValueFormatter()
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        
        let leftAxis:YAxis = lineChartView.leftAxis;
        leftAxis.labelTextColor = UIColor.black
        leftAxis.axisMaximum = 100.0;
        leftAxis.axisMinimum = 0.0;
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.drawGridLinesEnabled = true;
        leftAxis.drawZeroLineEnabled = true;
        
        //lineChartView.
        //lineChartView.leftAxis.gridColor = UIColor.white
        //lineChartView.xAxis.gridColor = UIColor.white
        
       // leftAxis.granularityEnabled = false;
        
        
        /*
        let rightAxis:YAxis = lineChartView.rightAxis;
        rightAxis.labelTextColor = UIColor.red;
        rightAxis.axisMaximum = 100.0;
        rightAxis.axisMinimum = 0.0;
        rightAxis.drawGridLinesEnabled = false;
        rightAxis.granularityEnabled = false;
        */
        
        
        
        showTheGraph()
    }
    
    func updateLineGraph()  {
        
        lineChartView.drawGridBackgroundEnabled = true;
        lineChartView.data = setLineChartData(values: viewModel.scoreData)
    }
    
    func setBarChart(values: [Double])-> BarChartData {
        //barChartView.noDataText = "You need to provide data for the chart."
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]) )
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Accuracy")
       // chartDataSet.colors = ChartColorTemplates.material()
        chartDataSet.colors = [UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)]
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
        //updateGraph()
        showTheGraph()
    }
    
    func updateBarGraph()  {
        
        barChartView.data = setBarChart(values: viewModel.scoreData)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.fitBars = true
    }
    
   
    func updateGraph()  {
        if(Settings.sharedInstance.graphType == 0)
        { updateBarGraph()
        }
        else {
            updateLineGraph()
        }
    }
    
    func showTheGraph()
    {
        if(Settings.sharedInstance.graphType == 0)
        {
                updateBarGraph()
                lineChartView.isHidden = true
                barChartView.isHidden = false
                //barChartView.slideInFromRight()
                self.view.bringSubview(toFront: barChartView)
        }
        else{
                updateLineGraph()
                barChartView.isHidden = true
                lineChartView.isHidden = false
                //lineChartView.slideInFromRight()
                self.view.bringSubview(toFront: lineChartView)
        }
    }
    
    func hideTheGraphs(){
        barChartView.isHidden = true
        lineChartView.isHidden = true
    }
    
    //MARK: - Protocols
    func updateExpertAudioButton(isPlaying: Bool) {
        if isPlaying == true {
            expert_AudioButton.setImage(UIImage(named: "speakerstop"), for: .normal)
        } else {
            expert_AudioButton.setImage(UIImage(named: "speakerup"), for: .normal)
        }
    }
    
    func reloadtable() {
        phonemeTable.reloadData()
    }
    
    func reloadCollectionView() {
        scoreCollectionView.reloadData()
    }
    
    func reloadCellInCollectionView(at indexPath:[IndexPath] , isPlaying : Bool) {
       
        if let cell = self.scoreCollectionView.cellForItem(at: indexPath[0]) {
            let cell = cell as! Scores_Cell
        if isPlaying == true {
            cell.audioPlayButton.setImage(UIImage(named: "speakerstop"), for: .normal)
        } else {
            cell.audioPlayButton.setImage(UIImage(named: "speakerup"), for: .normal)
        }
        }
    }
    
    func resetAudioButtonInCollectionView(at count:Int) {
        for row in 0...count {
            if let cell = self.scoreCollectionView.cellForItem(at: IndexPath(row: row , section: 0)) {
                let cell = cell as! Scores_Cell
                cell.audioPlayButton.setImage(UIImage(named: "speakerup"), for: .normal)
            }
       
        }
    }

    func setExpertSpeechButtonImage(set isTTSSpeaking:Bool) {
        if (isTTSSpeaking){
            expert_AudioButton.setImage(UIImage(named: "speakerstop"), for: .normal)
        } else {
            expert_AudioButton.setImage(UIImage(named: "speakerup"), for: .normal)
        }
    }
    
    func showCleanTextButton(isHidden:Bool) {
         guard tasktype == TaskType.freeText else {
            return
        }
        clearTextButton.isHidden = isHidden
    }
    
     // MARK: - Practice Board Action

    @IBAction func clearText(_ sender: Any) {
        
        textView.text = ""
    }
    @IBAction func showResultType(_ sender: Any) {
     
        //let title = showResultTypeButton.title(for: .normal)
        switch currentResultViewType {
        case .score:
            displayResultType(to: .graph , from: .score)
            break
        case .phenomeTable:
            //displayResultType(to: .score, from: currentResultViewType)
            displayResultType(to: .graph, from: currentResultViewType)
            break
        default:
            displayResultType(to: .score, from: .graph)
            break
        }
        
    }
    
    @IBAction func showKeyboard(_ sender: Any) {
        
        //textView.isEditable = textView.isEditable ? !textView.isEditable : !textView.isEditable
        //textView.isUserInteractionEnabled = textView.isUserInteractionEnabled ? !textView.isUserInteractionEnabled : !textView.isUserInteractionEnabled
        if (!textView.isEditable) {
            textView.isEditable = true
            textView.isSelectable = true
            textView.becomeFirstResponder()
            keyboard.setImage(UIImage(named: "pencil-unedit.png"), for: .normal)
        } else {
            textView.isEditable = false
            textView.isSelectable = false
           textView.resignFirstResponder()
            keyboard.setImage(UIImage(named: "pencil-edit.png"), for: .normal)
        }
        
    }
    
    @IBAction func clearTheScores(_ sender: Any) {
       
        guard viewModel.answersList.count > 0 else {
            return
        }
        
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete all the attempts.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Proceed", style: UIAlertActionStyle.default , handler: { (action) in
            self.clearText(sender)
            self.viewModel.clearData()
            self.refreshUI()
        }))
            
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    @objc func controlKeyboard (sender:UILongPressGestureRecognizer) {
       
        if(sender.state == .began ) {
        if(textView.isFirstResponder) {
            textView.isEditable = false
            textView.resignFirstResponder()
            } else {
            textView.isEditable = true
            textView.becomeFirstResponder()
            }
        }
    }
 */
    

    @objc func controlKeyboard (sender:UITapGestureRecognizer){
        guard sender.numberOfTapsRequired == 2 else {
            return
        }
        
        if(textView.isFirstResponder) {
            textView.resignFirstResponder()
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    
    @objc func displayWordPhonemeSection (sender:UITapGestureRecognizer){
       
        guard viewModel.selectedAnswer != nil else {
            print("‼️ No answer is selected. Please select an answer")
            
            return
        }
        
        let tappedWord =  viewModel.tapResponse(recognizer: sender)
        
        guard tappedWord.wordtoshow.word.count > 0 else {
            return
        }
        
        displayResultType(to: .phenomeTable, from: .score)
        self.phonemeTable.scrollToRow(at: IndexPath(row: 0, section: tappedWord.details.section), at: UITableViewScrollPosition.top, animated: true)
        
    }
   
    @IBAction func closePhonemeTableView(_ sender: Any) {
        
        displayResultType(to: .score, from: .phenomeTable)
    }
    
    // MARK: - Operations
    
    func displayResultType(to resultType: ResultViewType  , from currentType:ResultViewType)
    {
        currentResultViewType = resultType
        textView.resignFirstResponder()
        
        /*
        switch currentType {
        case .score:
            //showResultTypeButton.setTitle("S", for: .normal)
             textView.resignFirstResponder()
            //clearButton.setImage(UIImage(named:"trash_black.png"), for: .normal)
            //showResultTypeButton.setImage(UIImage(named:"tiles-view"), for: .normal)
            break
        case .phenomeTable:
             textView.resignFirstResponder()
            //clearButton.setImage(UIImage(named:"trash_black.png"), for: .normal)
            //showResultTypeButton.setImage(UIImage(named:"tiles-view"), for: .normal)
            //showResultTypeButton.setTitle("P", for: .normal)
            break
        default:
            //showResultTypeButton.setTitle("G", for: .normal)
             textView.resignFirstResponder()
            //clearButton.setImage(UIImage(named:"trash_1"), for: .normal)
            //showResultTypeButton.setImage(UIImage(named:"bar-chart"), for: .normal)
            break
        }
        */
        
        switch resultType {
        case .score:
            scoreCollectionView.isHidden = false
            barChartView.isHidden = true
            hideTheGraphs()
            phonemeTable.isHidden = true
            closPhonemeTableButton.isHidden = true
            showResultTypeButton.setImage(UIImage(named:"bar-chart"), for: .normal)
            break
        case .phenomeTable:
            scoreCollectionView.isHidden = true
            barChartView.isHidden = true
            hideTheGraphs()
            phonemeTable.isHidden = false
            closPhonemeTableButton.isHidden = false
            showResultTypeButton.setImage(UIImage(named:"bar-chart"), for: .normal)
            break
        default:
            scoreCollectionView.isHidden = true
            barChartView.isHidden = false
            showTheGraph()
            phonemeTable.isHidden = true
            closPhonemeTableButton.isHidden = true
            showResultTypeButton.setImage(UIImage(named:"tile"), for: .normal)
            break
        }

    }
    
    /*
    func playStreamAudio( for url:String)
    {
        guard streamPlayer.timeControlStatus != .playing else {
            streamPlayer.pause()
            return
        }
        // let url = audioUrl //"http://192.168.71.11:7891/rec.wav"
        let url = "http://192.168.71.11:7891/rec.wav"
        let playerItem = AVPlayerItem(url: URL(string:url)!)
        streamPlayer = AVPlayer(playerItem:playerItem)
        streamPlayer.rate = 1.0;
        streamPlayer.volume = 1.0
        streamPlayer.play()
    }
    */
    
    

    @IBAction func showFeedback(_ sender: Any) {
        let feedbackViewController =     FeedbackViewController(nibName: "FeedbackViewController", bundle: nil)
        feedbackViewController.viewModel.feedback = viewModel.unitList[unitIndex].feedback
        self.navigationController?.pushViewController(feedbackViewController, animated: true)
        
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
        displayResultType(to: .score, from: .graph)
        let word  = viewModel.unitList[unitIndex]
        textView.text = word.question_text
        textView.textColor = UIColor.white
        resetTextViewContent(textView: textView)
        viewModel.clearData()
        refreshUI()
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
        self.textView.font = UIFont(name: ThemeManager.sharedInstance.font_Bold!, size: CGFloat(ThemeManager.sharedInstance.fontSize_Large!))
        self.resetTextViewContent(textView: self.textView)
    }
    
    

    func refreshUI(){
        textView.textColor = UIColor.white
         updateGraph()
         reloadCollectionView()
         reloadtable()
    }
    
    @objc func backFromPracticeBoard() {
        clearAllAudioFile()
        self.navigationController?.popViewController(animated: true)
        
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
