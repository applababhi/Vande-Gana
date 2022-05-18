//
//  EntListVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 7/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class EntListVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!
    var arrData:[[String:Any]] = []

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func callViewWillAppearios13(notfication: NSNotification) {
            self.viewWillAppear(true)
        }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.callViewWillAppearios13(notfication:)), name: Notification.Name("viewWillAppear_EntListVC"), object: nil)
        
        setUpTopBar()
        lblTitle.text = "Entrenamiento"
    }

    override func viewWillAppear(_ animated: Bool) {
        callGetList()
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
}

extension EntListVC
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

extension EntListVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 240
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict: [String:Any] = arrData[indexPath.row]
        
        let cell:CellEntList = tableView.dequeueReusableCell(withIdentifier: "CellEntList", for: indexPath) as! CellEntList
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblViewMore.layer.cornerRadius = 6.0
        cell.lblViewMore.layer.masksToBounds = true
        
        if let str:String = dict["title"] as? String
        {
            cell.lblTitle.text = str
        }
        if let imgStr:String = dict["cover_url"] as? String
        {
            cell.imgView.setImageUsingUrl(imgStr)
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict: [String:Any] = arrData[indexPath.row]
        if let str:String = dict["course_id"] as? String
        {
            if let strT:String = dict["title"] as? String
            {
                callTrackingVerMosTapped(course_id: str, title:strT)
            }
        }
    }
}

extension EntListVC
{
    func callGetList()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_EnterList.rawValue, method: .get, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
          //  print(jsonString)
            
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
                        self.arrData.removeAll()

                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            DispatchQueue.main.async {
                                
                                self.arrData = arr
                                
                                if self.tblView.delegate == nil
                                {
                                    self.tblView.dataSource = self
                                    self.tblView.delegate = self
                                }
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callDetailWithCorseId(courseID:String, title:String)
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["course_id":courseID]
        WebService.requestService(url: ServiceName.GET_EnterListDetail.rawValue, method: .get, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
        //    print(jsonString)
            
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
                            DispatchQueue.main.async {
                                let vc: EntListDetailVC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListDetailVC_ID") as! EntListDetailVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.strTitle = title
                                vc.dictMain = dict
                                
                                if let di2:[String:Any] = dict["quizz_information"] as? [String:Any]
                                {
                                    if let check:Bool = di2["has_quizz"]  as? Bool
                                    {
                                        vc.check_showTomarTest = check
                                    }
                                }
                                
                                vc.modalPresentationStyle = .overFullScreen
                                vc.modalPresentationCapturesStatusBarAppearance = true
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension EntListVC
{
    func callTrackingVerMosTapped(course_id:String, title:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "object_id":course_id]
        WebService.requestService(url: ServiceName.POST_TrackerVerMosTap.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //   print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                self.callDetailWithCorseId(courseID: course_id, title: title)
            }
        }
    }
}
