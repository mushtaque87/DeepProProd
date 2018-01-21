//
//  Level_SHViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/10/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class Level_SHViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet var viewModel: LevelViewModel!
    @IBOutlet weak var levelTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.levelTableView.register(UINib(nibName: "ChapterContentCell", bundle: nil), forCellReuseIdentifier: "content")
        viewModel.parentController = self
        levelTableView.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshUI()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func refreshUI() {
        backgroundImage.setBackGroundimage()
    }

}
