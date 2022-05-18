//
//  Rankings_NewVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 2/13/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class Rankings_NewVC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var btnUser:UIButton!
    @IBOutlet weak var btnTab1:UIButton!
    @IBOutlet weak var btnTab2:UIButton!
    @IBOutlet weak var vTab1:UIView!
    @IBOutlet weak var vTab2:UIView!
    @IBOutlet weak var tblView:UITableView!
    
    var dict_user_information:[String:Any] = [:]
    var arrRows:[String] = []
    
    var arr_Ranks:[[String:Any]] = []    
    var arr_CollectionView:[[String:Any]] = []
    
    var arr_general_periods:[[String:Any]] = []
    var arr_regional_periods_FULL:[[String:Any]] = []
    var arr_regional_periods:[[String:Any]] = []
    
    var dict_general_leaderboard:[String:Any] = [:]
    var dict_regional_leaderboard:[String:Any] = [:]

    var general_leaderboard_message = ""
    var regional_leaderboard_message = ""
        
    var selectedTab = 1 // 1 or 2
    
    var picker : UIPickerView!
    var reffTapTF:UITextField!
    var dict_SelectedGeneralPeriod:[String:Any] = [:]
    var dict_SelectedRegionPeriod:[String:Any] = [:]
    
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
        
        callGetRankings()
        btnTab_1_Clicked(btn: btnTab1)
    }
    
    @IBAction func btnUserClicked(btn:UIButton)
    {
        let vc: UserProfileVC = AppStoryBoards.HomeTabBarVC.instance.instantiateViewController(withIdentifier: "UserProfileVC_ID") as! UserProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTab_1_Clicked(btn:UIButton)
    {
        // GENERAL
        vTab1.backgroundColor = UIColor(named: "App_Blue")!
        vTab2.backgroundColor = .clear
        
//        if picker != nil{
//            picker = nil
//        }
//        if reffTapTF != nil{
//            reffTapTF = nil
//        }
//        
//        dict_SelectedGeneralPeriod = [:]
//        dict_SelectedRegionPeriod = [:]
        
        selectedTab = 1
        self.changeTabData()
    }
    
    @IBAction func btnTab_2_Clicked(btn:UIButton)
    {
        // REGIONS
        vTab1.backgroundColor = .clear
        vTab2.backgroundColor = UIColor(named: "App_Blue")!
        
//        if picker != nil{
//            picker = nil
//        }
//        if reffTapTF != nil{
//            reffTapTF = nil
//        }
//
   //     dict_SelectedGeneralPeriod = [:]
   //     dict_SelectedRegionPeriod = [:]
        
        selectedTab = 2
        self.changeTabData()
    }
}

extension Rankings_NewVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrRows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let strType:String = arrRows[indexPath.row]
        
        if strType == "CellRankingNew_1TF"{
            return 50
        }
        else if strType == "CellRankingNew_2TF"{
           /* if arrRows.contains("CellRankingNew_Msg"){
                return 50
            }
            else {
                // normal case
                return 90
            }*/
            return 90
        }
        else if strType == "CellRankingNew_Ranks"{
            return 175
        }
        else if strType == "CellRankingNew_Msg"{
            return 90
        }
        else if strType == "CellRankingNew_Listing"{
            return CGFloat(50 + (arr_CollectionView.count * 36))
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let strType:String = arrRows[indexPath.row]
        
        if strType == "CellRankingNew_1TF"{
            let cell:CellRankingNew_1TF = tableView.dequeueReusableCell(withIdentifier: "CellRankingNew_1TF", for: indexPath) as! CellRankingNew_1TF
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            if let str:String = dict_general_leaderboard["level_name"] as? String{
                cell.lblTitle.text = str
            }
            cell.tf_1.tag = 100
            cell.tf_1.text = ""
            
            cell.tf_1.delegate = self
            cell.inCellAddPaddingTo(TextField: cell.tf_1, imageName: "down")
            cell.tf_1.setPlaceHolderColorWith(strPH: "Octubre 2021")
            cell.tf_1.layer.cornerRadius = 5.0
            cell.tf_1.layer.borderColor = UIColor.white.cgColor
            cell.tf_1.layer.borderWidth = 1.0
            cell.tf_1.layer.masksToBounds = true
            if let strV:String = dict_SelectedGeneralPeriod["month_name"] as? String{
                cell.tf_1.text = strV
            }

            return cell
        }
        else if strType == "CellRankingNew_2TF"{
            let cell:CellRankingNew_2TF = tableView.dequeueReusableCell(withIdentifier: "CellRankingNew_2TF", for: indexPath) as! CellRankingNew_2TF
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            if let str:String = dict_regional_leaderboard["level_name"] as? String{
                cell.lblTitle.text = str
            }
            cell.tf_1.tag = 100
            cell.tf_1.text = ""
            
            cell.tf_2.tag = 101
            cell.tf_2.text = ""
            
            cell.tf_2.isHidden = false
            
            if self.arr_regional_periods.count == 0{
                cell.tf_2.isHidden = true
            }

            cell.tf_1.delegate = self
            cell.inCellAddPaddingTo(TextField: cell.tf_1, imageName: "down")
            cell.tf_1.setPlaceHolderColorWith(strPH: "Julio 2021")
            cell.tf_1.layer.cornerRadius = 5.0
            cell.tf_1.layer.borderColor = UIColor.white.cgColor
            cell.tf_1.layer.borderWidth = 1.0
            cell.tf_1.layer.masksToBounds = true
            if let strV:String = dict_SelectedGeneralPeriod["month_name"] as? String{
                cell.tf_1.text = strV
            }
            
            cell.tf_2.delegate = self
            cell.inCellAddPaddingTo(TextField: cell.tf_2, imageName: "down")
            cell.tf_2.setPlaceHolderColorWith(strPH: "Julio 2021")
            cell.tf_2.layer.cornerRadius = 5.0
            cell.tf_2.layer.borderColor = UIColor.white.cgColor
            cell.tf_2.layer.borderWidth = 1.0
            cell.tf_2.layer.masksToBounds = true
            if let str = dict_SelectedRegionPeriod["region_name"] as? String
            {
                cell.tf_2.text = str
            }
            
            return cell
        }
        else if strType == "CellRankingNew_Ranks"{
            let cell:CellRankingNew_Ranks = tableView.dequeueReusableCell(withIdentifier: "CellRankingNew_Ranks", for: indexPath) as! CellRankingNew_Ranks
            cell.selectionStyle = .none
            
            cell.v_Row1.isHidden = false
            cell.v_Row2.isHidden = false
            cell.v_Row3.isHidden = false
            
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.imgCircle_Row1.layer.cornerRadius = 20.0
            cell.imgCircle_Row1.layer.borderWidth = 1.0
            cell.imgCircle_Row1.layer.borderColor = UIColor.white.cgColor
            cell.imgCircle_Row1.layer.masksToBounds = true
            
            cell.imgCircle_Row2.layer.cornerRadius = 20.0
            cell.imgCircle_Row2.layer.borderWidth = 1.0
            cell.imgCircle_Row2.layer.borderColor = UIColor.white.cgColor
            cell.imgCircle_Row2.layer.masksToBounds = true

            cell.imgCircle_Row3.layer.cornerRadius = 20.0
            cell.imgCircle_Row3.layer.borderWidth = 1.0
            cell.imgCircle_Row3.layer.borderColor = UIColor.white.cgColor
            cell.imgCircle_Row3.layer.masksToBounds = true

            cell.lblTitlte_Row1.text = ""
            cell.lblSubTitlte_Row1.text = ""
            cell.lblTitlte_Row2.text = ""
            cell.lblSubTitlte_Row2.text = ""
            cell.lblTitlte_Row3.text = ""
            cell.lblSubTitlte_Row3.text = ""
            
            if arr_Ranks.count > 0{
                let d1:[String:Any] = arr_Ranks[0]
                if let str = d1["workplace_name"] as? String
                {
                    cell.lblTitlte_Row1.text = str
                }
                if let str = d1["accumulated_points_str"] as? String
                {
                    cell.lblSubTitlte_Row1.text = str + " activaciones"
                }
                if let imgStr:String = d1["profile_picture_low_res_url"] as? String
                {
                    cell.imgCircle_Row1.setImageUsingUrl(imgStr)
                }
                
                if arr_Ranks.count > 1{
                    let d2:[String:Any] = arr_Ranks[1]
                    if let str = d2["workplace_name"] as? String
                    {
                        cell.lblTitlte_Row2.text = str
                    }
                    if let str = d2["accumulated_points_str"] as? String
                    {
                        cell.lblSubTitlte_Row2.text = str + " activaciones"
                    }
                    if let imgStr:String = d2["profile_picture_low_res_url"] as? String
                    {
                        cell.imgCircle_Row2.setImageUsingUrl(imgStr)
                    }
                    
                    if arr_Ranks.count > 2{
                        let d3:[String:Any] = arr_Ranks[2]
                        if let str = d3["workplace_name"] as? String
                        {
                            cell.lblTitlte_Row3.text = str
                        }
                        if let str = d3["accumulated_points_str"] as? String
                        {
                            cell.lblSubTitlte_Row3.text = str + " activaciones"
                        }
                        if let imgStr:String = d3["profile_picture_low_res_url"] as? String
                        {
                            cell.imgCircle_Row3.setImageUsingUrl(imgStr)
                        }

                    }
                }
            }
                        
            return cell
        }
        else if strType == "CellRankingNew_Msg"{
            let cell:CellRankingNew_Msg = tableView.dequeueReusableCell(withIdentifier: "CellRankingNew_Msg", for: indexPath) as! CellRankingNew_Msg
            cell.selectionStyle = .none

            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.lblTitle.text = ""
            cell.lblTitle.textColor = .white
            
            if selectedTab == 1{
                cell.lblTitle.text = general_leaderboard_message
            }else{
                cell.lblTitle.text = regional_leaderboard_message
            }
            
            return cell

        }
        else if strType == "CellRankingNew_Listing"{
            let cell:CellRankingNew_Listing = tableView.dequeueReusableCell(withIdentifier: "CellRankingNew_Listing", for: indexPath) as! CellRankingNew_Listing
            cell.selectionStyle = .none

            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.arrData = self.arr_CollectionView
            
            return cell

        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnCellClick(btn:UIButton){}
    
    @objc func btn_Checkbox(btn:UIButton)
    {}
}

extension Rankings_NewVC
{
    func callGetRankings()
    {
        arrRows.removeAll()
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
        
        let urlStr:String = ServiceName.GET_RankingWrapper.rawValue + uuid
        
        WebService.requestService(url: urlStr, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                            
                            if let dict:[String:Any] = dictResp["leaderboards"] as? [String:Any]
                            {
                                if let str:String = dict["general_leaderboard_message"] as? String
                                {
                                    self.general_leaderboard_message = str
                                    
                                    if str == ""
                                    {
                                        self.general_leaderboard_message = "No hay información para la región y perido seleccionados."
                                    }
                                }
                                if let str:String = dict["regional_leaderboard_message"] as? String
                                {
                                    self.regional_leaderboard_message = str
                                    if str == ""
                                    {
                                        self.regional_leaderboard_message = "Para el periodo seleccionado no tienes regiones asignadas."
                                    }
                                }
                                
                                if let ar:[[String:Any]] = dict["general_periods"] as? [[String:Any]]
                                {
                                    self.arr_general_periods = ar
                                    
                                    if ar.count > 0{
                                        self.dict_SelectedGeneralPeriod = ar.first!
                                    }
                                }
                                
                                if let ar:[[String:Any]] = dict["regional_periods"] as? [[String:Any]]
                                {
                                    self.arr_regional_periods_FULL = ar
                                    if ar.count > 0{
                                        
                                        if let period_id:String = self.dict_SelectedGeneralPeriod["month_id"] as? String
                                        {
                                            let aSelected:[[String:Any]] = self.arr_regional_periods_FULL.filter{(d:[String:Any]) -> Bool in
                                                if let strPeriodID:String = d["period_id"] as? String{
                                                    if strPeriodID == period_id{
                                                        return true
                                                    }
                                                }
                                                return false
                                            }
                                            
                                            if aSelected.count > 0{
                                                let dij:[String:Any] = aSelected.first!
                                                if let arrrrr:[[String:Any]] = dij["regions"] as? [[String:Any]]{
                                                    self.arr_regional_periods = arrrrr
                                                    if arrrrr.count > 0{
                                                        self.dict_SelectedRegionPeriod = arrrrr.first!
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                                                
                                if let di:[String:Any] = dict["general_leaderboard"] as? [String:Any]
                                {
                                    self.dict_general_leaderboard = di
                                }
                                                                
                                if let di:[String:Any] = dict["regional_leaderboard"] as? [String:Any]
                                {
                                    self.dict_regional_leaderboard = di
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
        self.arrRows.removeAll()
        
        if self.selectedTab == 1{
            
            if let ar:[[String:Any]] = self.dict_general_leaderboard ["podium"] as? [[String:Any]]
            {
                self.arr_Ranks = ar
            }
            if let ar:[[String:Any]] = self.dict_general_leaderboard ["all_users"] as? [[String:Any]]
            {
                self.arr_CollectionView = ar
            }
            
            if self.arr_Ranks.count == 0 && self.arr_CollectionView.count == 0{
                self.arrRows = ["CellRankingNew_1TF", "CellRankingNew_Msg"]
            }else{
                if self.arr_CollectionView.count == 0{
                    self.arrRows = ["CellRankingNew_1TF", "CellRankingNew_Ranks"]
                }else{
                    // show all
                    self.arrRows = ["CellRankingNew_1TF", "CellRankingNew_Ranks", "CellRankingNew_Listing"]
                }
            }
            
        }else{
            
            if let ar:[[String:Any]] = self.dict_regional_leaderboard["podium"] as? [[String:Any]]
            {
                self.arr_Ranks = ar
            }
            if let ar:[[String:Any]] = self.dict_regional_leaderboard["all_users"] as? [[String:Any]]
            {
                self.arr_CollectionView = ar
            }
            
            if self.arr_Ranks.count == 0 && self.arr_CollectionView.count == 0{
                self.arrRows = ["CellRankingNew_2TF", "CellRankingNew_Msg"]
            }else{
                if self.arr_CollectionView.count == 0{
                    self.arrRows = ["CellRankingNew_2TF", "CellRankingNew_Ranks"]
                }
                else{
                    // show all
                    self.arrRows = ["CellRankingNew_2TF", "CellRankingNew_Ranks", "CellRankingNew_Listing"]
                }
            }
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
