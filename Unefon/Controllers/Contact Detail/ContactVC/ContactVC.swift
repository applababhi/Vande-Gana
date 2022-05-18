//
//  ContactVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 5/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ContactVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrData = ["phone", "email", "create", "list"]
    var dictData:[String:Any] = [:]
    var isInnerTableShow = true
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.callViewWillAppearios13(notfication:)), name: Notification.Name("viewWillAppear_ContactVC"), object: nil)
        
        setUpTopBar()
        lblTitle.text = "Contacto"
    }
  
    override func viewWillAppear(_ animated: Bool) {
        if isInnerTableShow == false
        {
            callGetContactHeader_fromLogin()
        }
        else
        {
            callGetContactHeader_fromDashboard()
        }
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func createClicked(btn:UIButton)
    {
        let vc: CreateTicketVC = AppStoryBoards.Contact.instance.instantiateViewController(withIdentifier: "CreateTicketVC_ID") as! CreateTicketVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func callClicked(btn:UIButton)
    {
        if let strPhone:String = dictData["phone"] as? String
        {
            let url: NSURL = URL(string: "TEL://\(strPhone)")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func emailClicked(btn:UIButton)
    {
        if let strEmail:String = dictData["email"] as? String
        {
            if let url = URL(string: "mailto:\(strEmail)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
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

extension ContactVC
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

extension ContactVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let str: String = arrData[indexPath.row]
        
        if str == "phone"
        {
            return 80
        }
        else if str == "email"
        {
            return 80
        }
        else if str == "create"
        {
            return 115
        }
        else
        {
            // list
            
            if let arr:[[String:Any]] = dictData["list"] as? [[String:Any]]
            {
                // return arr.count *
                let other3LblWidth = CGFloat(25+86+109) //  25  86  109
                var heightTotalRows = 0.0
                for di in arr
                {
                    if let title:String = di["problem_description"] as? String
                    {
                        let width = (tableView.frame.size.width - other3LblWidth)
                        let height = title.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.semiBold, size: 20.0)!)
                        
                        heightTotalRows = heightTotalRows + Double(height)
                    }
                }
//                print("- - - - - >", heightTotalRows)
                return CGFloat(heightTotalRows + 40) // 40 for label
            }
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let str: String = arrData[indexPath.row]
        
        if str == "phone"
        {
            let cell:CellContact_Phone = tableView.dequeueReusableCell(withIdentifier: "CellContact_Phone", for: indexPath) as! CellContact_Phone
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            cell.btnLink.setTitle("", for: .normal)
            
            if let strPhone:String = dictData["phone"] as? String
            {
                cell.lblTitle.text = "Llámanos"
                cell.btnLink.setTitle(strPhone, for: .normal)
            }
            
            cell.btnLink.addTarget(self, action: #selector(self.callClicked(btn:)), for: .touchUpInside)
            
            return cell
        }
        else if str == "email"
        {
            let cell:CellContact_Phone = tableView.dequeueReusableCell(withIdentifier: "CellContact_Phone", for: indexPath) as! CellContact_Phone
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            cell.btnLink.setTitle("", for: .normal)
            
            if let strEmail:String = dictData["email"] as? String
            {
                cell.lblTitle.text = "Escríbenos"
                cell.btnLink.setTitle(strEmail, for: .normal)
            }
            
            cell.btnLink.addTarget(self, action: #selector(self.emailClicked(btn:)), for: .touchUpInside)
            
            return cell
        }
        else if str == "create"
        {
            let cell:CellContact_Create = tableView.dequeueReusableCell(withIdentifier: "CellContact_Create", for: indexPath) as! CellContact_Create
            cell.selectionStyle = .none

            cell.btnCreate.layer.cornerRadius = 5.0
            cell.btnCreate.layer.masksToBounds = true
            
            if isInnerTableShow == false
            {
                // from Login Screen
                cell.btnCreate.isHidden = true
            }
            
            cell.btnCreate.addTarget(self, action: #selector(self.createClicked(btn:)), for: .touchUpInside)
            
            return cell
        }
        else
        {
            // list
            let cell:CellContact_List = tableView.dequeueReusableCell(withIdentifier: "CellContact_List", for: indexPath) as! CellContact_List
            cell.selectionStyle = .none
            
            if let arr:[[String:Any]] = dictData["list"] as? [[String:Any]]
            {
                cell.completion = { (ticketID:String) in
                    print("TicketID Tap from Inner Table -> ", ticketID)
                    
                    let vc: ContactDetailVC = AppStoryBoards.Contact.instance.instantiateViewController(withIdentifier: "ContactDetailVC_ID") as! ContactDetailVC
                    vc.strTicketID = ticketID
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalPresentationCapturesStatusBarAppearance = true
                    self.presentModal(vc: vc)
                }
                
                cell.arrList = arr
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
}

extension ContactVC
{
    func callGetContactHeader_fromLogin()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        WebService.requestService(url: ServiceName.GET_ContactHeader.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        self.arrData.removeAll()
                        self.dictData.removeAll()
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                if let strP:String = dict["phone_number"] as? String
                                {
                                    self.arrData.append("phone")
                                    self.dictData["phone"] = strP
                                }
                                if let strE:String = dict["mail_address"] as? String
                                {
                                    self.arrData.append("email")
                                    self.dictData["email"] = strE
                                }
                                self.arrData.append("create")
                                
                                
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
    
    func callGetContactHeader_fromDashboard()
    {
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan_id.rawValue) as? String
        {
            plan_id = id
        }
        if plan_id == ""
        {
            return
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        WebService.requestService(url: ServiceName.GET_ContactHeader.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        self.arrData.removeAll()
                        self.dictData.removeAll()
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                if let strP:String = dict["phone_number"] as? String
                                {
                                    self.arrData.append("phone")
                                    self.dictData["phone"] = strP
                                }
                                if let strE:String = dict["mail_address"] as? String
                                {
                                    self.arrData.append("email")
                                    self.dictData["email"] = strE
                                }
                                self.arrData.append("create")
                                self.perform(#selector(self.callGetTickets), with: nil, afterDelay: 0.2)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func callGetTickets()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_UserTicketsContact.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
      //      print(jsonString)
            
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

                        if let arrTickets:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrData.append("list")
                            self.dictData["list"] = arrTickets

                            DispatchQueue.main.async {
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
}
