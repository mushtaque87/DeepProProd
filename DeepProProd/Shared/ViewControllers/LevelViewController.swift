//
//  Level_SHViewController.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/10/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import MBProgressHUD

class LevelViewController: UIViewController, CategoriesProtocol {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet var viewModel: LevelViewModel!
    @IBOutlet weak var levelTableView: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    @IBOutlet weak var bredCrumCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //fetchCategories()
        
        self.levelTableView.register(UINib(nibName: "AssignmentTableViewCell", bundle: nil), forCellReuseIdentifier: "assignmentListCell")
        viewModel.delegate = self
        
        self.bredCrumCollectionView.register(UINib(nibName: "CrumTitle_Cell", bundle: nil), forCellWithReuseIdentifier: "crumTitle")
       // self.bredCrumCollectionView.register(UINib(nibName: "AssignmentTableViewCell", bundle: nil), forCellReuseIdentifier: "assignmentListCell")
        //bredCrumCollectionView.isPagingEnabled = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        viewModel.currentGroupId = 0
        viewModel.crumList.append(Crums(id: 0, title: "Root"))
        fetchRootContent()
        
        bredCrumCollectionView.collectionViewLayout = layout
        //bredCrumCollectionView.contentSize = CGSize(width: 1000.0, height: bredCrumCollectionView.frame.size.height)
        bredCrumCollectionView.delegate = viewModel
        bredCrumCollectionView.dataSource = viewModel
       // bredCrumCollectionView.backgroundColor = UIColor.white
        bredCrumCollectionView.layer.borderColor = UIColor.white.cgColor
        bredCrumCollectionView.layer.borderWidth = 4
        
        levelTableView.backgroundColor = UIColor.clear
        self.levelTableView.addSubview(self.refreshControl)
        self.navigationItem.title = "Contents"
        refreshUI()
        
        self.backgroundImage.isHidden = true
        
        
        edgesForExtendedLayout = []
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
        setTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshUI()
        viewDidLayoutSubviews()
        self.levelTableView.reloadData()
    }
    //https://stackoverflow.com/questions/48308863/gradient-layer-in-swift-uitableview
    
    func setTheme() {
        let colors = ThemeManager.sharedInstance.color
        let backgroundLayer = colors?.gl
        bredCrumCollectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: bredCrumCollectionView.frame.height)
        backgroundLayer?.frame = bredCrumCollectionView.bounds
        bredCrumCollectionView.layer.insertSublayer(backgroundLayer!, at: 0)
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.backgroundColor_Regular!)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.hexStringToUIColor(hex: ThemeManager.sharedInstance.font_Color!)]
            // self.navigationController?.navigationBar.layer.insertSublayer(barlayer, at: 1)
        
    }

    func fetchRootContent()
    {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Fetching assignments. Please wait"
        
        ServiceManager().getRootContent(ofStudent: UserDefaults.standard.string(forKey: "uid")! , onSuccess: { assignmentlist in
            self.viewModel.contentList = assignmentlist
            self.levelTableView.reloadData()
            self.levelTableView.reloadData()
            hud.hide(animated: true)
        }, onHTTPError: { httperror in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = httperror.description
        }, onError: { error in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = error.localizedDescription
        }, onComplete: {
            hud.hide(animated: true)
        })
        
        
    }
    
    func fetchContentGroup(for id:Int = 0,
                           onSuccess successCompletionHandler: @escaping () -> Void)
    {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Fetching Content. Please wait"
        
        ServiceManager().getContentGroup(for: id, ofStudent: UserDefaults.standard.string(forKey: "uid")! , onSuccess: { assignmentlist in
            self.viewModel.contentList.removeAll()
            self.viewModel.contentList = assignmentlist
            self.levelTableView.scrollsToTop = true
            self.levelTableView.reloadData()
            hud.hide(animated: true)
            successCompletionHandler()
        }, onHTTPError: { httperror in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = httperror.description
        }, onError: { error in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = error.localizedDescription
        }, onComplete: {
            hud.hide(animated: true)
        })
        
        
    }
    
    /*
    func fetchContentsUnit(for id:Int = 0)
    {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Fetching assignments. Please wait"
        
        ServiceManager().getContentUnit(for: id, ofStudent: UserDefaults.standard.string(forKey: "uid")! , onSuccess: { unitList in
            //self.viewModel.categoriesList = assignmentlist
            //Show Units Screen
            
            //self.showUnitScreen(for: )
           // self.levelTableView.reloadData()
            hud.hide(animated: true)
        }, onHTTPError: { httperror in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = httperror.description
        }, onError: { error in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = error.localizedDescription
        }, onComplete: {
            hud.hide(animated: true)
        })
        
        
    }
    */
    
    /*
    func fetchCategories()
    {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Fetching assignments. Please wait"
        
        ServiceManager().getCategories(onSuccess: { assignmentlist in
            self.viewModel.categoriesList = assignmentlist
            self.levelTableView.reloadData()
            hud.hide(animated: true)
        }, onHTTPError: { httperror in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = httperror.description
        }, onError: { error in
            hud.mode = MBProgressHUDMode.text
            hud.label.text = error.localizedDescription
        }, onComplete: {
            hud.hide(animated: true)
        })
        
        
    }
    */
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //fetchRootContent()
        fetchContentGroup(for: viewModel.currentGroupId) {
            // Stay on the same screen
        }
        refreshControl.endRefreshing()
    }
    
    func fetchContentGroup(for content:ContentGroup , actionType:CrumActionType) {
        guard content.has_units == true else {
            fetchContentGroup(for: content.id!) {
                if let id = content.id ,  let title = content.name {
                    self.viewModel.currentGroupId = id
                    switch actionType {
                    case .append:
                        self.viewModel.addCrums(of: Crums(id: id, title: title))
                    case .remove:
                        self.viewModel.removeCrums(till: Crums(id: id, title: title))
                    }
                    self.bredCrumCollectionView.reloadData()
                }
            }
            return
        }
        //Fetch Units
        if let id = content.id {
        //fetchContentsUnit(for: id)
            showUnitScreen(for: id)
        }
    }
    
    func showUnitScreen(for id:Int) {
        
        let unitListViewController =     UnitListViewController(nibName: "UnitListViewController", bundle: nil)
        unitListViewController.id = id
        self.navigationController?.pushViewController(unitListViewController, animated: true)
    }
    
    /*
    func showPracticesScreen(for category:RootContent) {
        //let practiceScreen = AssignmnetDasboardViewController(nibName:"AssignmnetDasboardViewController",bundle:nil)
        //practiceScreen.viewModel.tasktype = .practice
        //practiceScreen.viewModel.categoryId = categoryId
        //self.navigationController?.pushViewController(practiceScreen, animated: true)
        
        
    }
    */
    
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
