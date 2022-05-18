//
//  Activaciones_NewVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 2/13/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class Activaciones_NewVC: UIViewController {

    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var btnUser:UIButton!
    @IBOutlet weak var btnTab1:UIButton!
    @IBOutlet weak var btnTab2:UIButton!
    @IBOutlet weak var vTab1:UIView!
    @IBOutlet weak var vTab2:UIView!
    @IBOutlet weak var tblView:UITableView!
    
    var dict_user_information:[String:Any] = [:]
    var dict_AvanceActual:[String:Any] = [:]
    var dict_History:[String:Any] = [:]
    
    var arrMainData:[[String:Any]] = []  // will show main rows and it's heights
    //    ["Dropdown" ,"ChartHeader", "PointToken", "ProgressBars_Current", "ProgressBars_History", "Chart", "ThinProgressBars"]
    var arr_dropdown:[[String:Any]] = []
    var dict_ChartHeader:[String:Any] = [:]
    var dict_PointToken:[String:Any] = [:]
    var arr_ProgressBar:[[String:Any]] = []
    var arr_Charts:[[String:Any]] = []
    var arr_ThinProgressBar:[[String:Any]] = []
    
    var arrPeriodPicker:[[String:Any]] = []
    var arrThinProgress:[[String:Any]] = []
    
    var check_IsHistoryTabClick = false
    
    var picker : UIPickerView!
    var reffTapTF:UITextField!
    var dict_SelectedPeriod:[String:Any] = [:]

    var setUserImage:UIImage = UIImage(named: "ph")! {
        didSet{
            self.btnUser.setImage(setUserImage, for: .normal)
        }
    }
    
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
        
        btnTab_1_Clicked(btn: btnTab1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        callPerformanceWrapper()
    }
    
    @IBAction func btnUserClicked(btn:UIButton)
    {
        let vc: UserProfileVC = AppStoryBoards.HomeTabBarVC.instance.instantiateViewController(withIdentifier: "UserProfileVC_ID") as! UserProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTab_1_Clicked(btn:UIButton)
    {
        // add below line to remove childVC because on switch it was not removing the previously added collV chart child
        if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
        
        // Avance Actual
        vTab1.backgroundColor = UIColor(named: "App_Blue")!
        vTab2.backgroundColor = .clear
        check_IsHistoryTabClick = false
        // create arrMainData for AvanceActual (current_performance)
        self.setUpDataFor_CurrentPerformance()
    }
    
    @IBAction func btnTab_2_Clicked(btn:UIButton)
    {
        // add below line to remove childVC because on switch it was not removing the previously added collV chart child
        if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
        
        // Histórico
        vTab1.backgroundColor = .clear
        vTab2.backgroundColor = UIColor(named: "App_Blue")!
        check_IsHistoryTabClick = true
        
        // create arrMainData for  historical_performance
        setUpDataFor_History()
    }
}

extension Activaciones_NewVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMainData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        // ["Dropdown" ,"ChartHeader", "PointToken", "ProgressBars", "Chart", "ThinProgressBars"]
        let dict:[String:Any] = arrMainData[indexPath.row]
        var strType = ""
        if let str:String = dict["title"] as? String{
            strType = str
        }
        
        if strType == "ChartHeader"
        {
            if let height:Int = dict["height"] as? Int{
                return CGFloat(height)
            }
        }
        else if strType == "PointToken"
        {
            if let height:Int = dict["height"] as? Int{
                return CGFloat(height)
            }
        }
        else if strType == "ProgressBars_Current"
        {
            if let height:Int = dict["height"] as? Int{
                return CGFloat(height)
            }
        }
        else if strType == "Dropdown"
        {
            if let height:Int = dict["height"] as? Int{
                return CGFloat(height)
            }
        }
        else if strType == "ProgressBars_History"
        {
            if let height:Int = dict["height"] as? Int{
                return CGFloat(height)
            }
        }
        else if strType == "Chart"
        {
            if let height:Int = dict["height"] as? Int{
                return CGFloat(height)
            }
        }
        else if strType == "ThinProgressBars"
        {
            if let height:Int = dict["height"] as? Int{
                return CGFloat(height)
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //  ["Dropdown" ,"ChartHeader", "PointToken", "ProgressBars_Current", "ProgressBars_History", "Chart", "ThinProgressBars"]

        let dict:[String:Any] = arrMainData[indexPath.row]
        
        var strType = ""
        if let str:String = dict["title"] as? String{
            strType = str
        }
        
        if strType == "ChartHeader"
        {
            // dict_ChartHeader

            let cell:CellActivaciones_ChartHeader = tableView.dequeueReusableCell(withIdentifier: "CellActivaciones_ChartHeader", for: indexPath) as! CellActivaciones_ChartHeader
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            cell.lblKpi.text = ""
            cell.lblKpiValue.text = ""
            cell.lblSales.text = ""
            cell.lblSalesValue.text = ""
            cell.lblProgress.text = ""
            cell.lblMessage.text = ""
            cell.imgView.image = nil
            
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            if let str:String = dict_ChartHeader["title"] as? String
            {
                cell.lblTitle.text = str
            }
            if let str:String = dict_ChartHeader["kpi_label"] as? String
            {
                cell.lblKpi.text = str
            }
            if let str:String = dict_ChartHeader["kpi_str"] as? String
            {
                cell.lblKpiValue.text = str
            }
            if let str:String = dict_ChartHeader["sales_label"] as? String
            {
                cell.lblSales.text = str
            }
            if let str:String = dict_ChartHeader["sales_str"] as? String
            {
                cell.lblSalesValue.text = str
            }
            if let str:String = dict_ChartHeader["progress_str"] as? String
            {
                cell.lblProgress.text = str
            }
            if let str:String = dict_ChartHeader["message"] as? String
            {
                cell.lblMessage.text = str
            }
            if let str:String = dict_ChartHeader["progress_chart_image"] as? String
            {
                cell.imgView.image = UIImage(named: str)
            }

            return cell
        }
        else if strType == "PointToken"
        {
            // dict_PointToken

            let cell:CellActivaciones_PointToken = tableView.dequeueReusableCell(withIdentifier: "CellActivaciones_PointToken", for: indexPath) as! CellActivaciones_PointToken
            cell.selectionStyle = .none
            cell.lblTitle.text = "-"
            cell.lblPointValue.text = "-"
            cell.lblTokenValue.text = "-"
            cell.lblComments.text = "-"
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true

            cell.lblPointValue.isHidden = false
            cell.lblPoints.isHidden = false
            cell.lblTokens.isHidden = false
            cell.lblTokenValue.isHidden = false
            
         //   print(dict_PointToken)
                      
            if let str:String = dict_PointToken["title"] as? String
            {
                cell.lblTitle.text = str
            }
            if let str:String = dict_PointToken["points_str"] as? String
            {
                if str == ""{
                   // cell.lblPointValue.isHidden = true
                  //  cell.lblPoints.isHidden = true
                }
                cell.lblPointValue.text = str
            }else{
                // null
              //  cell.lblPointValue.isHidden = true
              //  cell.lblPoints.isHidden = true
            }
            /*
            if let str:String = dict_PointToken["title"] as? String
            {
              //  cell.lblPoints.text = str
            }
            if let str:String = dict_PointToken["title"] as? String
            {
              //  cell.lblTokens.text = str
            }
            */
            if let str:String = dict_PointToken["tokens_str"] as? String
            {
                if str == ""{
                  //  cell.lblTokenValue.isHidden = true
                  //  cell.lblTokens.isHidden = true
                }
                cell.lblTokenValue.text = str
            }else{
                // null
              //  cell.lblTokenValue.isHidden = true
              //  cell.lblTokens.isHidden = true
            }
            
            if let str:String = dict_PointToken["comments"] as? String
            {
                cell.lblComments.text = str
            }
            return cell
        }
        else if strType == "ProgressBars_Current"
        {
            // arr_ProgressBar
            // dict_AvanceActual : for 2 descriptions titles

            let cell:CellActivaciones_ProgressBars = tableView.dequeueReusableCell(withIdentifier: "CellActivaciones_ProgressBars", for: indexPath) as! CellActivaciones_ProgressBars
            cell.selectionStyle = .none
            cell.lblTitle_1.text = ""
            cell.lblTitle_2.text = ""
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.arrData = self.arr_ProgressBar
            
            if let dict_:[String:Any] = self.dict_AvanceActual["regional_progress_widget"] as? [String:Any]
            {
                if let str:String = dict_["description_1"] as? String
                {
                    cell.lblTitle_1.text = str
                }
                if let str:String = dict_["description_2"] as? String
                {
                    cell.lblTitle_2.text = str
                }
            }
            
            return cell
        }
        else if strType == "ProgressBars_History"
        {
            // arr_ProgressBar
            // dict_AvanceActual : for 2 descriptions titles

            let cell:CellActivaciones_ProgressBars = tableView.dequeueReusableCell(withIdentifier: "CellActivaciones_ProgressBars", for: indexPath) as! CellActivaciones_ProgressBars
            cell.selectionStyle = .none
            cell.lblTitle_1.text = ""
            cell.lblTitle_2.text = ""
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.arrData = self.arr_ProgressBar
            
            if let dict_:[String:Any] = self.dict_History["regional_progress_widget"] as? [String:Any]
            {
                if let str:String = dict_["description_1"] as? String
                {
                    cell.lblTitle_1.text = str
                }
                if let str:String = dict_["description_2"] as? String
                {
                    cell.lblTitle_2.text = str
                }
            }
            
            return cell
        }
        else if strType == "Chart"
        {
            let cell:CellActivaciones_Chart = tableView.dequeueReusableCell(withIdentifier: "CellActivaciones_Chart", for: indexPath) as! CellActivaciones_Chart
            cell.selectionStyle = .none
            cell.lblTitle.text = "Ventas por Semana"            
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            ////
            let controller: HistoryChartVC = AppStoryBoards.Dashboard.instance.instantiateViewController(withIdentifier: "HistoryChartVC_ID") as! HistoryChartVC
            
            
            controller.removeFromParent()
            
            controller.arr_BarsCollV = self.arr_Charts
            
            controller.view.frame = CGRect(x: 0, y: cell.vChartContainer.frame.origin.y - 24, width: cell.vChartContainer.frame.size.width, height: cell.vChartContainer.frame.size.height)
            controller.willMove(toParent: self)
            cell.vChartContainer.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
            ///
            return cell
        }
        else if strType == "ThinProgressBars"
        {
            // arr_ProgressBar
            // dict_AvanceActual : for 2 descriptions titles

            let cell:CellActivaciones_ThinProgressBars = tableView.dequeueReusableCell(withIdentifier: "CellActivaciones_ThinProgressBars", for: indexPath) as! CellActivaciones_ThinProgressBars
            cell.selectionStyle = .none

            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.arrData = self.arrThinProgress
            
            return cell
        }
        else if strType == "Dropdown"
        {
            let cell:CellHistory_Dropdown = tableView.dequeueReusableCell(withIdentifier: "CellHistory_Dropdown", for: indexPath) as! CellHistory_Dropdown
            cell.selectionStyle = .none

            cell.tfDropdown.delegate = self
            cell.inCellAddPaddingTo(TextField: cell.tfDropdown, imageName: "down")
            cell.tfDropdown.setPlaceHolderColorWith(strPH: "Octubre 2021")
            
            if let strV:String = dict_SelectedPeriod["name"] as? String{
                cell.tfDropdown.text = strV
            }
            
            cell.tfDropdown.layer.cornerRadius = 5.0
            cell.tfDropdown.layer.borderColor = UIColor.white.cgColor
            cell.tfDropdown.layer.borderWidth = 1.0
            cell.tfDropdown.layer.masksToBounds = true
            
            cell.btnViewInfo.layer.cornerRadius = 15.0
            cell.btnViewInfo.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
            cell.btnViewInfo.layer.borderWidth = 1.0
            cell.btnViewInfo.layer.masksToBounds = true
            
            cell.btnViewInfo.addTarget(self, action: #selector(self.btnViewInfoClick(btn:)), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension Activaciones_NewVC
{
    func callPerformanceWrapper()
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
        
        let urlStr:String = ServiceName.GET_PerformanceWrapper.rawValue + uuid
       // print(urlStr)
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
                            
                            if let arr:[[String:Any]] = dictResp["available_periods"] as? [[String:Any]]
                            {
                                // For textfield Drop Down
                                self.arrPeriodPicker = arr
                                if arr.count > 0{
                                    self.dict_SelectedPeriod = self.arrPeriodPicker.first!
                                }
                            }
                            
                            if let dict:[String:Any] = dictResp["current_performance"] as? [String:Any]
                            {
                                self.dict_AvanceActual = dict
                            }
                            
                            if let dict:[String:Any] = dictResp["historical_performance"] as? [String:Any]
                            {
                                self.dict_History = dict
                            }
                            
                            DispatchQueue.main.async {
                                
                                if self.check_IsHistoryTabClick == false{
                                    self.setUpDataFor_CurrentPerformance()
                                }
                                else{
                                    self.setUpDataFor_History()
                                }
                            }
                        }
                    }
                }
            }
        }
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
    
    func setUpDataFor_CurrentPerformance(){
        
        // arrMainData :: arr_dropdown, dict_ChartHeader, dict_PointToken, arr_ProgressBar, arr_Charts, arr_ThinProgressBar
        
//      ["ChartHeader", "PointToken", "ProgressBars_Current"]
        
        self.arrMainData.removeAll()
        
        // Check Visibility
        if let dict_Visible:[String:Any] = self.dict_AvanceActual["widgets_visibility"] as? [String:Any]
        {
            if let check:Bool = dict_Visible["display_performance_progress_widget"] as? Bool
            {
                if check == true{
                    self.arrMainData.append(["title":"ChartHeader", "height":305])
                }
            }
            if let check:Bool = dict_Visible["display_rewards_widget"] as? Bool
            {
                if check == true{
                    // we ll set it's height down in few lines
                    self.arrMainData.append(["title":"PointToken", "height":180])
                }
            }
            if let check:Bool = dict_Visible["display_regional_progress_widget"] as? Bool
            {
                if check == true{
                    // 90, of 2 labels excluding collView
                    self.arrMainData.append(["title":"ProgressBars_Current", "height":95])
                }
            }
        }
        // make chartHeader data
        if let dict_:[String:Any] = self.dict_AvanceActual["performance_progress_widget"] as? [String:Any]
        {
            self.dict_ChartHeader = dict_
            if let strEmpty:String = dict_["message"] as? String{
                if strEmpty.isEmpty{
                    
                    let index = self.arrMainData.firstIndex { eachDict in
                        return (eachDict["title"] as? String == "ChartHeader")
                    }
                    
                    if index != nil{
                        // don't show bottom msg label in ui so adjust height
                        self.arrMainData[index!] = ["title":"ChartHeader", "height":270]
                    }
                }
            }
        }
        
        self.dict_PointToken.removeAll()
        // make PointToken data
        if let dict_:[String:Any] = self.dict_AvanceActual["rewards_widget"] as? [String:Any]
        {
            if let str:String = dict_["title"] as? String{
                self.dict_PointToken["title"] = str
            }
            
            if let check:Bool = dict_["display_points"] as? Bool{
                if check{
                    if let str:String = dict_["points_str"] as? String{
                        self.dict_PointToken["points_str"] = str
                    }
                }
            }
            if let check:Bool = dict_["display_tokens"] as? Bool{
         //       print(check)
                if check{
                    if let str:String = dict_["tokens_str"] as? String{
                        self.dict_PointToken["tokens_str"] = str
                    }
                }
            }
            
            if let strEmpty:String = dict_["comments"] as? String{
                if !strEmpty.isEmpty{
                    self.dict_PointToken["comments"] = strEmpty
                }
                else{
                    // hide comments
                    
                    let index = self.arrMainData.firstIndex { eachDict in
                        return (eachDict["title"] as? String == "PointToken")
                    }
                    
                    if index != nil{
                        // don't show bottom msg label in ui so adjust height
                        self.arrMainData[index!] = ["title":"PointToken", "height":135]
                    }
                }
            }

        }
        // set  arr_ProgressBar
        self.arr_ProgressBar = []
        if let dict_:[String:Any] = self.dict_AvanceActual["regional_progress_widget"] as? [String:Any]
        {
            if let arr:[[String:Any]] = dict_["regions"] as? [[String:Any]]
            {
                self.arr_ProgressBar = arr
                
                let index = self.arrMainData.firstIndex { eachDict in
                    return (eachDict["title"] as? String == "ProgressBars_Current")
                }
                
                if index != nil{
                    // don't show bottom msg label in ui so adjust height
                    self.arrMainData[index!] = ["title":"ProgressBars_Current", "height":95 + (arr.count * 129)]
                    // 95, of 2 labels excluding collView
                }
            }
        }
        
        DispatchQueue.main.async {
            if self.tblView.delegate == nil
            {
                self.tblView.delegate = self
                self.tblView.dataSource = self
            }
            self.tblView.reloadData()
        }
    }
    
    func setUpDataFor_History(){
        
        // arrMainData :: arr_dropdown, dict_ChartHeader, dict_PointToken, arr_ProgressBar, arr_Charts, arr_ThinProgressBar,      dict_SelectedPeriod, arrPeriodPicker, arr_Charts, arrThinProgress
        //    ["Dropdown" ,"ChartHeader", "PointToken", "ProgressBars_History", "Chart", "ThinProgressBars"]
        
        self.arrMainData.removeAll()
        
        self.arrMainData.append(["title":"Dropdown", "height":70])
        // self.arrPeriodPicker already set when called api response
        
        // Check Visibility
        if let dict_Visible:[String:Any] = self.dict_History["widgets_visibility"] as? [String:Any]
        {
            if let check:Bool = dict_Visible["display_performance_progress_widget"] as? Bool
            {
                if check == true{
                    self.arrMainData.append(["title":"ChartHeader", "height":305])
                }
            }
            if let check:Bool = dict_Visible["display_rewards_widget"] as? Bool
            {
                if check == true{
                    // we ll set it's height down in few lines
                    self.arrMainData.append(["title":"PointToken", "height":180])
                }
            }
            if let check:Bool = dict_Visible["display_regional_progress_widget"] as? Bool
            {
                if check == true{
                    // 95, of 2 labels excluding collView
                    self.arrMainData.append(["title":"ProgressBars_History", "height":95])
                }
            }
            
            if let check:Bool = dict_Visible["display_week_progress_widget"] as? Bool
            {
                if check == true{
                    self.arrMainData.append(["title":"Chart", "height":250])
                }
            }
            if let check:Bool = dict_Visible["display_day_progress_widget"] as? Bool
            {
                if check == true{
                    // 80, of 2 labels excluding collView
                    self.arrMainData.append(["title":"ThinProgressBars", "height":80])
                }
            }
            
        }
        // make chartHeader data
        if let dict_:[String:Any] = self.dict_History["performance_progress_widget"] as? [String:Any]
        {
            self.dict_ChartHeader = dict_
            if let strEmpty:String = dict_["message"] as? String{
                if strEmpty.isEmpty{
                    // don't show bottom msg label in ui so adjust height
                    
                    let index = self.arrMainData.firstIndex { eachDict in
                        return (eachDict["title"] as? String == "ChartHeader")
                    }
                    
                    if index != nil{
                        // don't show bottom msg label in ui so adjust height
                        self.arrMainData[index!] = ["title":"ChartHeader", "height":270]
                    }
                }
            }
        }
        
        self.dict_PointToken.removeAll()
        // make PointToken data
        if let dict_:[String:Any] = self.dict_History["rewards_widget"] as? [String:Any]
        {
            if let str:String = dict_["title"] as? String{
                self.dict_PointToken["title"] = str
            }
            
            if let check:Bool = dict_["display_points"] as? Bool{
                if check{
                    if let str:String = dict_["points_str"] as? String{
                        self.dict_PointToken["points_str"] = str
                    }
                }
            }
            if let check:Bool = dict_["display_tokens"] as? Bool{
           //     print(check)
                if check{
                    if let str:String = dict_["tokens_str"] as? String{
                        self.dict_PointToken["tokens_str"] = str
                    }
                }
            }
            
            if let strEmpty:String = dict_["comments"] as? String{
                if !strEmpty.isEmpty{
                    self.dict_PointToken["comments"] = strEmpty
                }
                else{
                    // hide comments
                    let index = self.arrMainData.firstIndex { eachDict in
                        return (eachDict["title"] as? String == "PointToken")
                    }
                    
                    if index != nil{
                        // don't show bottom msg label in ui so adjust height
                        self.arrMainData[index!] = ["title":"PointToken", "height":270]
                    }
                }
            }

        }
        // set  arr_ProgressBar
        self.arr_ProgressBar = []
        if let dict_:[String:Any] = self.dict_History["regional_progress_widget"] as? [String:Any]
        {
            if let arr:[[String:Any]] = dict_["regions"] as? [[String:Any]]
            {
                self.arr_ProgressBar = arr
                
                // 95, of 2 labels excluding collView
                
                let index = self.arrMainData.firstIndex { eachDict in
                    return (eachDict["title"] as? String == "ProgressBars_History")
                }
                
                if index != nil{
                    // don't show bottom msg label in ui so adjust height
                    self.arrMainData[index!] = ["title":"ProgressBars_History", "height":95 + (arr.count * 129)]
                }
            }
        }
        
        // set  arr_Charts
        self.arr_Charts = []
        if let arr:[[String:Any]] = self.dict_History["week_progress_widget"] as? [[String:Any]]
        {
            self.arr_Charts = arr
        }
        
        // set  arrThinProgress
        self.arrThinProgress = []
        if let arr:[[String:Any]] = self.dict_History["day_progress_widget"] as? [[String:Any]]
        {
            self.arrThinProgress = arr
            
            // 80, of 2 labels excluding collView
            
            let index = self.arrMainData.firstIndex { eachDict in
                return (eachDict["title"] as? String == "ThinProgressBars")
            }
            
            if index != nil{
                self.arrMainData[index!] = ["title":"ThinProgressBars", "height":85 + (arr.count * 27)]
            }

        }
        
        DispatchQueue.main.async {
            if self.tblView.delegate == nil
            {
                self.tblView.delegate = self
                self.tblView.dataSource = self
            }
            self.tblView.reloadData()
        }
    }
    
    func callGetViewInfoData()
    {
         // removeAll
        
        // add below line to remove childVC because on switch it was not removing the previously added collV chart child
        if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
        
        var monthIdSelected = ""
        
        if let str:String = dict_SelectedPeriod["id"] as? String{
            monthIdSelected = str
        }
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        var urlStr:String = ServiceName.GET_historical_performance.rawValue
        urlStr = urlStr.replacingOccurrences(of: "+AA+", with: uuid)
        
        urlStr = urlStr + monthIdSelected
        // print(urlStr)
        
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
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                self.dict_History = dict
                                self.setUpDataFor_History()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Activaciones_NewVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reffTapTF = textField
        showPickerView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tblView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tblView.reloadData()
        textField.resignFirstResponder()
        return true
    }
    
    @objc func btnViewInfoClick(btn:UIButton)
    {
        if dict_SelectedPeriod.isEmpty
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            print("Call View Info Api")
            callGetViewInfoData()
        }
    }
}

extension Activaciones_NewVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = UIColor.white
        reffTapTF.inputView = self.picker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Hecho", style: .plain, target: self, action: #selector(self.donePickerClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //  let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelPickerClick))
        //  toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        reffTapTF.inputAccessoryView = toolBar
    }
    
    @objc func donePickerClick() {
        
        if let str = dict_SelectedPeriod["name"] as? String
        {
            reffTapTF.text = str
        }
        
        picker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
        tblView.reloadData()
    }
    @objc func cancelPickerClick() {
        picker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPeriodPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var strTitle:String = ""
        let dict:[String:Any] = arrPeriodPicker[row]
        if let str = dict["name"] as? String
        {
            strTitle = str
        }
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dict_SelectedPeriod = arrPeriodPicker[row]
        
        if let str = dict_SelectedPeriod["name"] as? String
        {
            reffTapTF.text = str
        }
    }
}
