//
//  Anuncios_NewVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 2/13/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class Anuncios_NewVC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var btnUser:UIButton!
    @IBOutlet weak var btnTab1:UIButton!
    @IBOutlet weak var btnTab2:UIButton!
    @IBOutlet weak var vTab1:UIView!
    @IBOutlet weak var vTab2:UIView!
    @IBOutlet weak var tblView:UITableView!
    
    var dict_user_information:[String:Any] = [:]
    var arrMainData:[[String:Any]] = []
   
    var arr_Tab1:[[String:Any]] = []
    var arr_Tab2:[[String:Any]] = []
    
    var selectedTab = 1  // 1 or 2
    
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
        
        setHeaderGradient(viewBack: vHeader)
    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        callAPIFeeds()
        btnTab_1_Clicked(btn: btnTab1)
    }
    
    @IBAction func btnUserClicked(btn:UIButton)
    {
        let vc: UserProfileVC = AppStoryBoards.HomeTabBarVC.instance.instantiateViewController(withIdentifier: "UserProfileVC_ID") as! UserProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTab_1_Clicked(btn:UIButton)
    {
        // Communicados
        vTab1.backgroundColor = UIColor(named: "App_Blue")!
        vTab2.backgroundColor = .clear
        
        selectedTab = 1
        changeTabData()
    }
    
    @IBAction func btnTab_2_Clicked(btn:UIButton)
    {
        // Promotions
        vTab1.backgroundColor = .clear
        vTab2.backgroundColor = UIColor(named: "App_Blue")!
        selectedTab = 2
        changeTabData()
    }
}

extension Anuncios_NewVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMainData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 240
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrMainData[indexPath.row]
       
        let cell:Cells_Anuncios_NewRow = tableView.dequeueReusableCell(withIdentifier: "Cells_Anuncios_NewRow", for: indexPath) as! Cells_Anuncios_NewRow
        cell.selectionStyle = .none
        cell.lblTitle.text = "..."
        cell.lblSubTitle.text = "..."
        cell.vBk.layer.cornerRadius = 7.0
        cell.vBk.layer.masksToBounds = true
        cell.imgView.image = nil
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(self.btnCellClick(btn:)), for: .touchUpInside)
        
        cell.setGradient()
        
        cell.vTransBlack.isHidden = false
        cell.lblTitle.isHidden = false
        cell.lblSubTitle.isHidden = false
        
        if let show:Bool = dict["display_mode"] as? Bool{
            if show == false{
                cell.vTransBlack.isHidden = true
                cell.lblTitle.isHidden = true
                cell.lblSubTitle.isHidden = true
            }
        }
        
        if let imgStr:String = dict["cover_url"] as? String
        {
            cell.imgView.setImageUsingUrl(imgStr)
        }
        if let title:String = dict["title"] as? String
        {
            if title.count > 20
            {
                cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            else
            {
                cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
            }
            cell.lblTitle.text = title
        }
        if let str:String = dict["publish_date_str"] as? String
        {
            cell.lblSubTitle.text = str
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnCellClick(btn:UIButton)
    {
        let dict:[String:Any] = arrMainData[btn.tag]
      //  print("DICT :: \n", dict)

        if self.selectedTab == 1
        {
            if let str:String = dict["announcement_id"] as? String
            {
                let url = ServiceName.GET_SingleAnnouncement.rawValue
                calltakeToNewsDetail(urlStr: url, value: str, key: "announcement_id")
            }
        }
        else
        {
            if let str:String = dict["promotion_id"] as? String
            {
                let url = ServiceName.GET_SinglePromotion.rawValue
                calltakeToNewsDetail(urlStr: url, value: str, key: "promotion_id")
            }
        }
    }
}

extension Anuncios_NewVC
{
    func callAPIFeeds()
    {
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
        
        let urlStr:String = ServiceName.GET_FeedWrapper.rawValue + uuid
        
        WebService.requestService(url: urlStr, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
       //     print(jsonString)
            
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
                            
                            if let dict:[String:Any] = dictResp["feed"] as? [String:Any]
                            {
                                if let arr:[[String:Any]] = dict["announcements"] as? [[String:Any]]
                                {
                                    self.arr_Tab1 = arr
                                }
                                if let arr:[[String:Any]] = dict["promotions"] as? [[String:Any]]
                                {
                                    self.arr_Tab2 = arr
                                }
                            }
                                
                            DispatchQueue.main.async {
                                self.changeTabData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func changeTabData(){
        if self.selectedTab == 1{
            self.arrMainData = self.arr_Tab1
        }else{
            self.arrMainData = self.arr_Tab2
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
    
    func calltakeToNewsDetail(urlStr:String, value:String, key:String)
    {

        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [key:value]
        WebService.requestService(url: urlStr, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
          //     print(jsonString)
            if error != nil
            {
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
                        
                        if let dictMain:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                let arr:[[String:Any]] = [dictMain]
                                let vc: NewsListVC = AppStoryBoards.NewsDetail.instance.instantiateViewController(withIdentifier: "NewsListVC_ID") as! NewsListVC
                                vc.arrData = arr
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
//    func calltakeToNewsDetail()
//    {
//        var plan_id = ""
//        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan_id.rawValue) as? String
//        {
//            plan_id = id
//        }
//        if plan_id == ""
//        {
//            return
//        }
//
//        self.showSpinnerWith(title: "Cargando...")
//        let param: [String:Any] = ["plan_id":plan_id]
//        WebService.requestService(url: ServiceName.GET_NewsDetail.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
//            self.hideSpinner()
//            //   print(jsonString)
//            if error != nil
//            {
//                print("Error - ", error!)
//                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
//                return
//            }
//            else
//            {
//                if let internalCode:Int = json["internal_code"] as? Int
//                {
//                    if internalCode != 0
//                    {
//                        // Display Error
//                        if let msg:String = json["message"] as? String
//                        {
//                            self.showAlertWithTitle(title: "Error", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
//                            return
//                        }
//                    }
//                    else
//                    {
//                        // Pass
//
//                        if let arrresp:[[String:Any]] = json["response_object"] as? [[String:Any]]
//                        {
//                            DispatchQueue.main.async {
//                                let vc: NewsListVC = AppStoryBoards.NewsDetail.instance.instantiateViewController(withIdentifier: "NewsListVC_ID") as! NewsListVC
//                                vc.arrData = arrresp
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
}
