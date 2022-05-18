//
//  ObjectiveBaseVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 6/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ObjectiveBaseVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var collViewMain:UICollectionView!
    @IBOutlet weak var baseView:UIView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrData: [String] = ["CÓMO GANAR",
        "REGLAS",
        "PROMOCIONES",
        "LA PLATAFORMA"]
    var dictObjectiveData: [String:Any] = ["objective1": ["array":[], "description":"", "number":0],
                                           "objective2":["array":[]],
                                           "objective3":["array":[]],
                                           "objective4":["array":[]]
    ]
    var selectedCellIndex:Int = 0
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopBar()

        callAllObjectives()
        lblTitle.text = "Reglas y Objetivos"
        collViewMain.dataSource = self
        collViewMain.delegate = self
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpTopBar()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
            c_TopBar_Ht.constant = 90
        }
        else if strModel == "iPhone Max"
        {
            c_TopBar_Ht.constant = 90
        }
        else if strModel == "iPhone 5"
        {
            
        }
        else{
            c_TopBar_Ht.constant = 110
        }
    }
    
    func loadSubViewControllerAt(index:Int)
    {
        for views in baseView.subviews
        {
            views.removeFromSuperview()
        }
        
        if index == 0
        {
           // Tab 1
            let controller: Objective1VC = AppStoryBoards.Objectives.instance.instantiateViewController(withIdentifier: "Objective1VC_ID") as! Objective1VC
            
            let dictTemp:[String:Any] = self.dictObjectiveData["objective1"] as! [String:Any]
            controller.strDescription = dictTemp["description"] as! String
            controller.numberKPI = dictTemp["number"] as! Int
            controller.arrData = dictTemp["array"] as! [[String:Any]]
            
            controller.view.frame = self.baseView.bounds;
            controller.willMove(toParent: self)
            self.baseView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        else if index == 1
        {
            // Tab 2
            let controller: Objective2VC = AppStoryBoards.Objectives.instance.instantiateViewController(withIdentifier: "Objective2VC_ID") as! Objective2VC

            let dictTemp:[String:Any] = self.dictObjectiveData["objective2"] as! [String:Any]
            controller.arrData = dictTemp["array"] as! [String]
            
            controller.view.frame = self.baseView.bounds;
            controller.willMove(toParent: self)
            self.baseView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        else if index == 2
        {
            // Tab 3
            
            let controller: Objective3VC = AppStoryBoards.Objectives.instance.instantiateViewController(withIdentifier: "Objective3VC_ID") as! Objective3VC
            let dictTemp:[String:Any] = self.dictObjectiveData["objective3"] as! [String:Any]
            controller.arrData = dictTemp["array"] as! [[String:Any]]
            
            controller.view.frame = self.baseView.bounds;
            controller.willMove(toParent: self)
            self.baseView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)

        }
        else if index == 3
        {
            // Tab 4
            let controller: Objective4VC = AppStoryBoards.Objectives.instance.instantiateViewController(withIdentifier: "Objective4VC_ID") as! Objective4VC
            let dictTemp:[String:Any] = self.dictObjectiveData["objective4"] as! [String:Any]
            controller.arrData = dictTemp["array"] as! [[String:Any]]

            controller.view.frame = self.baseView.bounds;
            controller.willMove(toParent: self)
            self.baseView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
    }
}

extension ObjectiveBaseVC
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return (isPad == true) ? .all : .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("--> iPAD Screen Orientation")
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        } else {
            print("portrait")
        }
    }
}

extension ObjectiveBaseVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let str:String = arrData[indexPath.item]
        
        let cell:CellColl_ObjBase = collViewMain.dequeueReusableCell(withReuseIdentifier: "CellColl_ObjBase", for: indexPath) as! CellColl_ObjBase
        cell.lblTitle.text = str
        cell.lblTitle.textColor = .black

        cell.viewLine.backgroundColor = UIColor.lightGray
        if selectedCellIndex == indexPath.item
        {
            cell.viewLine.backgroundColor = k_baseColor
            cell.lblTitle.textColor = k_baseColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       // let str:String = arrData[indexPath.item]
        selectedCellIndex = indexPath.item
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true) // to make cell in ceter on Tap
        collectionView.reloadData()
        loadSubViewControllerAt(index: indexPath.item)
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let str:String = arrData[indexPath.item]
        
        let width  = str.width(withConstrainedHeight: 30, font: UIFont(name: CustomFont.semiBold, size: 18.0)!, minimumTextWrapWidth: 130)
        return CGSize(width: width, height: 50)
    }
}

extension ObjectiveBaseVC
{
    func callAllObjectives()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_Objectives.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
      //                        print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let internalCode:Int = json["internal_code"] as? Int
                {
                    if internalCode != 0
                    {
                        // Display Error
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "Error", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass

                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let strDesc:String = dict["general_objective"] as? String
                            {
                                if let kpi:Int = dict["kpi"] as? Int
                                {
                                    if let arrObj1:[[String:Any]] = dict["ranges"] as? [[String:Any]]
                                    {
                                        let dictTemp:[String:Any] = ["array":arrObj1, "description":strDesc, "number":kpi]
                                        self.dictObjectiveData["objective1"] = dictTemp
                                    }
                                }
                            }
                            if let arrObj2:[String] = dict["rules"] as? [String]
                            {
                                let dictTemp:[String:Any] = ["array":arrObj2]
                                self.dictObjectiveData["objective2"] = dictTemp
                            }
                            if let arrObj3:[[String:Any]] = dict["promotions"] as? [[String:Any]]
                            {
                                let dictTemp:[String:Any] = ["array":arrObj3]
                                self.dictObjectiveData["objective3"] = dictTemp
                            }
                            if let arrObj4:[[String:Any]] = dict["tutorials"] as? [[String:Any]]
                            {
                                let dictTemp:[String:Any] = ["array":arrObj4]
                                self.dictObjectiveData["objective4"] = dictTemp
                            }
                            
                            DispatchQueue.main.async {
                                self.loadSubViewControllerAt(index: 0)
                            }
                        }
                    }
                }
            }
        }
    }
}
