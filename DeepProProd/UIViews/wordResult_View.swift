//
//  wordResult_View.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/17/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class wordResult_View: UIView {
//https://medium.com/written-code/creating-uiviews-programmatically-in-swift-55f5d14502ae
    var shouldSetupConstraints = true
    var close : UIButton!
    var wordPhenome_Table: UITableView!
    var isPhenomeTableVisible = false
    //var wordToShow: String?
    var wordLabel: UILabel?
    var wordScoreLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.close = UIButton(frame:CGRect(x:5, y: 10, width: 20, height: 20))
        self.close.addTarget(self, action: #selector(removeAnimate), for: UIControlEvents.touchUpInside)
        self.close?.setImage(UIImage(named: "close.png"), for: UIControlState.normal)
       // self.addSubview(self.close!)
        self.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        
        wordLabel = UILabel(frame: CGRect(x: 0, y: 10, width: self.frame.size.width, height: 28))
        //var word_Result: Word_Prediction  =  predictionData.words_Result![section] as! Word_Prediction
        //wordLabel?.text = wordToShow
        wordLabel?.textColor = UIColor.white
        wordLabel?.font = UIFont(name: "Futura-Bold", size: 18.0)
        wordLabel?.textAlignment = NSTextAlignment.center
        self.addSubview(wordLabel!)
        
        wordScoreLabel = UILabel(frame: CGRect(x: self.frame.size.width - 40 , y: 10, width: 40 , height: 30))
        //var word_Result: Word_Prediction  =  predictionData.words_Result![section] as! Word_Prediction
        //wordLabel?.text = wordToShow
        wordScoreLabel?.text = "-"
        wordScoreLabel?.textColor = UIColor.white
        wordScoreLabel?.font = UIFont(name: "Futura-Bold", size: 14.0)
        wordScoreLabel?.textAlignment = NSTextAlignment.center
        self.addSubview(wordScoreLabel!)
        
        
        wordPhenome_Table = UITableView(frame:CGRect(x:  0 , y: 40, width: self.frame.size.width, height: (self.frame.size.height-40)))
        self.wordPhenome_Table.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "report")
        self.addSubview(wordPhenome_Table)
        
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillDetails(wordToShow: String , wordscore: Float) -> Void {
        
        
        var color: UIColor = UIColor.white
        if (wordscore > 70) {
            color = UIColor(red: 0/255.0, green: 124/255.0, blue: 0/255.0, alpha: 1.0)
        } else if (wordscore  < 30) {
            color = UIColor(red: 180.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        }
        else{
            color = UIColor.blue
        }
      wordLabel?.text = wordToShow
      wordScoreLabel?.text = String(format: "%2.f", wordscore)
      wordScoreLabel?.textColor = color
      wordLabel?.textColor = color
        
    }
    
    func showAnimate()
    {
        if(self.isPhenomeTableVisible == false)
        {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
           
        });
        self.isPhenomeTableVisible = true
        }
        else{
            removeAnimate()
        }
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            // AutoLayout constraints
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    @objc func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.removeFromSuperview()
                
            }
        });
        self.isPhenomeTableVisible = false
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    

}
