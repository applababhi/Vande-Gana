//
//  EmailSupport_NewVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 2/13/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class EmailSupport_NewVC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var btnUser:UIButton!
    @IBOutlet weak var btnTab1:UIButton!
    @IBOutlet weak var btnTab2:UIButton!
    @IBOutlet weak var vTab1:UIView!
    @IBOutlet weak var vTab2:UIView!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var vSelectedTab:UIView!
    @IBOutlet weak var lblNumOfSelections:UILabel!
    
    var dict_user_information:[String:Any] = [:]
    var arrMainData:[[String:Any]] = []
    var arr_Inbox:[[String:Any]] = []
    var arr_Fav:[[String:Any]] = []
    
    var unread_count_str = ""
    var selectedTab = 1 // 1 or 2

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        vTab1.backgroundColor = .clear
        vTab2.backgroundColor = .clear
        
        btnUser.setImage(nil, for: .normal)
        
        btnUser.layer.cornerRadius = 15.0
        btnUser.layer.borderWidth = 1.2
        btnUser.layer.borderColor = UIColor.white.cgColor
        btnUser.layer.masksToBounds = true
                        
        btnTab1.setTitle("Todos", for: .normal)
        btnTab2.setTitle("Favoritos", for: .normal)
        
        setHeaderGradient(viewBack: vHeader)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        callGetEmailWrapper()
        btnTab_1_Clicked(btn: btnTab1)
    }
    
    @IBAction func btnUserClicked(btn:UIButton)
    {
        let vc: UserProfileVC = AppStoryBoards.HomeTabBarVC.instance.instantiateViewController(withIdentifier: "UserProfileVC_ID") as! UserProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTab_1_Clicked(btn:UIButton)
    {
        // Inbox
        vTab1.backgroundColor = UIColor(named: "App_Blue")!
        vTab2.backgroundColor = .clear
        
        selectedTab = 1
        self.changeTabData()
    }
    
    @IBAction func btnTab_2_Clicked(btn:UIButton)
    {
        // Favourite
        vTab1.backgroundColor = .clear
        vTab2.backgroundColor = UIColor(named: "App_Blue")!
        
        selectedTab = 2
        self.changeTabData()
    }
    
    @IBAction func btnSelectAllClicked(btn:UIButton)
    {
        for index in 0..<arrMainData.count{
            var d:[String:Any] = arrMainData[index]
            d["selected"] = true
            arrMainData[index] = d
        }
        
        lblNumOfSelections.text = "Marcar \(arrMainData.count) mensajes como:"
        self.tblView.reloadData()
    }
    
    @IBAction func btnMarkasREADClicked(btn:UIButton)
    {
        let arrSelected = arrMainData.filter{ (dict:[String:Any]) -> Bool in
            if let selected:Bool = dict["selected"] as? Bool{
                if selected == true{
                    return true
                }
            }
            return false
        }
        
        let strMailIds = arrSelected.map{ (dict:[String:Any]) -> String in
            return dict["mail_id"] as! String
        }.joined(separator: ",")
        
        if strMailIds.count > 0{
            callMarkAsRead(mail_ids: strMailIds)
        }
        else{
            self.showAlertWithTitle(title: "Alert", message: "Seleccione los correos electrónicos para marcar como leídos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
    }
    
    @IBAction func btnMarkAsUnreadClicked(btn:UIButton)
    {
        let arrSelected = arrMainData.filter{ (dict:[String:Any]) -> Bool in
            if let selected:Bool = dict["selected"] as? Bool{
                if selected == true{
                    return true
                }
            }
            return false
        }
        
        let strMailIds = arrSelected.map{ (dict:[String:Any]) -> String in
            return dict["mail_id"] as! String
        }.joined(separator: ",")
        
        if strMailIds.count > 0{
            callMarkAsUNRead(mail_ids: strMailIds)
        }
        else{
            self.showAlertWithTitle(title: "Alert", message: "Seleccione los correos electrónicos para marcar como leídos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
    }
}

extension EmailSupport_NewVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMainData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrMainData[indexPath.row]
       
        let cell:Cells_EmailSupport_New = tableView.dequeueReusableCell(withIdentifier: "Cells_EmailSupport_New", for: indexPath) as! Cells_EmailSupport_New
        cell.selectionStyle = .none
        cell.lblTitle.text = "..."
        cell.lblDate.text = "..."
        cell.btnCheckbox.layer.cornerRadius = 12.0
        cell.btnCheckbox.layer.borderColor = UIColor.white.cgColor
        cell.btnCheckbox.layer.borderWidth = 1.0
        cell.btnCheckbox.layer.masksToBounds = true
        cell.btnCheckbox.backgroundColor = .clear
        
        cell.btnCheckbox.tag = indexPath.row
        cell.btnCheckbox.addTarget(self, action: #selector(self.btn_Checkbox(btn:)), for: .touchUpInside)
        
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(self.btnCellClick(btn:)), for: .touchUpInside)

        if let selected:Bool = dict["selected"] as? Bool{
            if selected{
                cell.btnCheckbox.backgroundColor = UIColor(named: "App_Blue")!
            }
        }
        
        if let title:String = dict["subject"] as? String
        {
            cell.lblTitle.textColor = UIColor(named: "App_Blue")!
            cell.lblTitle.text = title
            if let check:Bool = dict["is_read"] as? Bool
            {
                if check == true{
                    cell.lblTitle.textColor = .white
                }
            }
        }
        if let str:String = dict["date_str"] as? String
        {
            cell.lblDate.text = str
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnCellClick(btn:UIButton){
        let dict:[String:Any] = arrMainData[btn.tag]
      
        let vc: EmailFavDetailVC = AppStoryBoards.EmailDetail.instance.instantiateViewController(withIdentifier: "EmailFavDetailVC_ID") as! EmailFavDetailVC
        if let title:String = dict["subject"] as? String
        {
            vc.strHeader = title
        }
        if let mailID:String = dict["mail_id"] as? String
        {
            vc.strMailID = mailID
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btn_Checkbox(btn:UIButton)
    {
        vSelectedTab.isHidden = false
        
        var dict:[String:Any] = arrMainData[btn.tag]
        if let selected:Bool = dict["selected"] as? Bool{
            dict["selected"] = !selected
        }
        arrMainData[btn.tag] = dict
        
        let arrSelected = arrMainData.filter{ (dict:[String:Any]) -> Bool in
            if let selected:Bool = dict["selected"] as? Bool{
                if selected == true{
                    return true
                }
            }
            return false
        }

        lblNumOfSelections.text = "Marcar \(arrSelected.count) mensajes como:"
        if arrSelected.count == 0{
            vSelectedTab.isHidden = true
        }
        tblView.reloadData()
    }
}

extension EmailSupport_NewVC
{
    func callGetEmailWrapper()
    {
        vSelectedTab.isHidden = true
        
        if let tabItems = self.tabBarController?.tabBar.items {
            
            let tabItem = tabItems[4]
            tabItem.badgeValue = nil
        }
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        let urlStr:String = ServiceName.GET_EmailWrapper.rawValue + uuid
        
        WebService.requestService(url: urlStr, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let dictResp:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let dict:[String:Any] = dictResp["general"] as? [String:Any]
                            {
                                if let dictUI:[String:Any] = dict["user_information"] as? [String:Any]
                                {
                                    self.dict_user_information = dictUI
                                    DispatchQueue.main.async {
                                        if let strUrl:String = dictUI["profile_picture_url"] as? String{
                                            let imgView = UIImageView()
                                            imgView.setImageUsingUrl(strUrl)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
                                                self.btnUser.setImage(imgView.image, for: .normal)
                                            }
                                        }
                                    }
                                }
                                
                                if let dictBad:[String:Any] = dict["badges"] as? [String:Any]
                                {
                                    if let badge:String = dictBad["inbox_badge_count_str"] as? String
                                    {
                                        DispatchQueue.main.async {
                                            if let tabItems = self.tabBarController?.tabBar.items {
                                                // In this case we want to modify the badge number of the third tab:
                                                let tabItem = tabItems[4]
                                                
                                                if badge != "" && badge != "0"{
                                                    tabItem.badgeValue = badge
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                if let dictAI:[String:Any] = dict["app_information"] as? [String:Any]
                                {
                                    if let checkUpdate:Int = dictAI["require_software_update"] as? Int
                                    {
                                        if checkUpdate == 1
                                        {
                                            // Show Alert to update
                                            self.showAlertWithTitle(title: "Alerta", message: "Hay una nueva versión de la app disponible.", okButton: "Instalar", cancelButton: "Ahora No", okSelectorName: #selector(self.takeToStore))
                                        }
                                    }
                                }
                            }
                            
                            if let strCount:Int = dictResp["unread_count"] as? Int
                            {
                                self.unread_count_str = "\(strCount)"
                            }
                            
                            if let arr:[[String:Any]] = dictResp["inbox"] as? [[String:Any]]
                            {
                                var arrtemp:[[String:Any]] = []
                                for index in 0..<arr.count{
                                    var d:[String:Any] = arr[index]
                                    d["selected"] = false
                                    arrtemp.append(d)
                                }
                                self.arr_Inbox = arrtemp
                            }
                            if let arr:[[String:Any]] = dictResp["favorites"] as? [[String:Any]]
                            {
                                var arrtemp:[[String:Any]] = []
                                for index in 0..<arr.count{
                                    var d:[String:Any] = arr[index]
                                    d["selected"] = false
                                    arrtemp.append(d)
                                }
                                self.arr_Fav = arrtemp
                            }
                            DispatchQueue.main.async {
                                self.btnTab1.setTitle("Todos (\(self.unread_count_str))", for: .normal)
                                self.changeTabData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callMarkAsRead(mail_ids:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "mail_ids":mail_ids]
        WebService.requestService(url: ServiceName.PUT_MarkAsRead.rawValue, method: .put, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
        //       print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let strM:String = json["message"] as? String
                {
                    self.showAlertWithTitle(title: "Vende y Gana", message: strM, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.refreshView))
                    return
                }
            }
        }
    }
    
    func callMarkAsUNRead(mail_ids:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "mail_ids":mail_ids]
        WebService.requestService(url: ServiceName.PUT_MarkAsUnRead.rawValue, method: .put, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
        //       print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let strM:String = json["message"] as? String
                {
                    self.showAlertWithTitle(title: "Vende y Gana", message: strM, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.refreshView))
                    return
                }
            }
        }
    }
    
    @objc func refreshView(){
        self.callGetEmailWrapper()
    }
    
    func changeTabData(){
        if self.selectedTab == 1{
            self.arrMainData = self.arr_Inbox
        }else{
            self.arrMainData = self.arr_Fav
        }
        
        if self.tblView.delegate == nil
        {
            self.tblView.delegate = self
            self.tblView.dataSource = self
        }
        self.tblView.reloadData()
    }
    
    @objc func takeToStore()
    {
        DispatchQueue.main.async{
            let urlStr = "itms-apps://itunes.apple.com/app/radio-fm/id1004413147?mt=12"
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
        }
        
        // var appID: String = infoDictionary["CFBundleIdentifier"]
        // var url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(appID)")
        // https://apps.apple.com/in/app/whatsapp-desktop/id1147396723?mt=12
        // Homechow : "itunes.apple.com/us/app/homechow/id1435002621?ls=1&mt=8"
    }
}
