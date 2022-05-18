//
//  Recompensas_NewVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 2/13/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

class CollCell_Header_Recompensas: UICollectionViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var viewLine:UIView!
    @IBOutlet weak var btn:UIButton!
}

extension Recompensas_NewVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCollView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrCollView[indexPath.item]
        
        let cell:CollCell_Header_Recompensas = collViewHeader.dequeueReusableCell(withReuseIdentifier: "CollCell_Header_Recompensas", for: indexPath) as! CollCell_Header_Recompensas
        cell.lblTitle.text = ""
        cell.viewLine.backgroundColor = .clear
        cell.lblTitle.textColor = .white
        cell.btn.tag = indexPath.item
        
        if let title:String = dict["title"] as? String
        {
            cell.lblTitle.text = title
        }
        
        if let check:Bool = dict["selected"] as? Bool
        {
            if check == true{
                cell.lblTitle.textColor = UIColor(named: "App_Blue")!
                cell.viewLine.backgroundColor = UIColor(named: "App_Blue")!
            }
        }
        
        cell.btn.addTarget(self, action: #selector(self.headerTabClick(btn:)), for: .touchUpInside)
        return cell
    }
    
    @objc func headerTabClick(btn:UIButton){
        selectedIndex = btn.tag
        
        for index in 0..<arrCollView.count{
            var dict:[String:Any] = arrCollView[index]
            dict["selected"] = false
            if index == selectedIndex{
                dict["selected"] = true
            }
            arrCollView[index] = dict
            collViewHeader.reloadData()
        }
        
        setUpData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    // To Change Cell Size Dynamically
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // let dict:[String:Any] = arrData[indexPath.item]
        let WidthOfContent = collectionView.frame.size.width / 3.0
        
        if indexPath.item == 0{
            // CANJEAR
            let size = CGSize(width: 100, height: 40)
            return size
        }
        
        let size = CGSize(width: WidthOfContent, height: 40)
        return size
    }
}


import UIKit

class Recompensas_NewVC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var btnUser:UIButton!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var collViewHeader:UICollectionView!
    
    var selectedIndex = 0
    var arrTable:[[String:Any]] = []
    
    var arrCollView:[[String:Any]] = []{
        didSet{
            if collViewHeader.dataSource == nil{
                collViewHeader.dataSource = self
                collViewHeader.delegate = self
            }
            collViewHeader.reloadData()
        }
    }
    
    var arrDropdown:[[String:Any]] = []
    var picker : UIPickerView!
    var reffTapTF:UITextField!
    var dict_SelectedPickerValue:[String:Any] = [:]
    
    var dict_user_information:[String:Any] = [:]
    var dict_rewards:[String:Any] = [:]
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnUser.setImage(nil, for: .normal)
        
        btnUser.layer.cornerRadius = 15.0
        btnUser.layer.borderWidth = 1.2
        btnUser.layer.borderColor = UIColor.white.cgColor
        btnUser.layer.masksToBounds = true
        
        setHeaderGradient(viewBack: vHeader)
        callGetRewards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func btnUserClicked(btn:UIButton)
    {
        let vc: UserProfileVC = AppStoryBoards.HomeTabBarVC.instance.instantiateViewController(withIdentifier: "UserProfileVC_ID") as! UserProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Recompensas_NewVC
{
    func callGetRewards()
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
        
        let urlStr:String = ServiceName.GET_RewardsWrapper.rawValue + uuid
        
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
                            
                            if let dict:[String:Any] = dictResp["rewards"] as? [String:Any]
                            {
                                self.dict_rewards = dict
                                self.arrCollView = [["title":"Canjear", "selected":true]]
                                
                                if let check:Bool = self.dict_rewards["display_points"] as? Bool
                                {
                                    if check == true{
                                        self.arrCollView.append(["title":"Mis Certificados", "selected":false])
                                    }
                                }
                                if let check:Bool = self.dict_rewards["display_tokens"] as? Bool
                                {
                                    if check == true{
                                        self.arrCollView.append(["title":"Mis Pedidos", "selected":false])
                                    }
                                }
                                
                                if let dropdown:[[String:Any]] = dict["general_periods"] as? [[String:Any]]
                                {
                                    self.arrDropdown = dropdown
                                    if dropdown.count > 0{
                                        self.dict_SelectedPickerValue = dropdown.first!
                                    }
                                }
                                
                                self.setUpData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setUpData(){
        
        self.arrTable.removeAll()
        
        if selectedIndex == 0
        {
            if let check:Bool = self.dict_rewards["display_points"] as? Bool
            {
                if check == true{
                    
                    if let di:[String:Any] = self.dict_rewards["balance"] as? [String:Any]
                    {
                        var title = ""
                        var balance = ""
                        var description = ""
                        if let str:String = di["points_title"] as? String
                        {
                            title = str
                        }
                        if let str:String = di["points_balance_str"] as? String
                        {
                            balance = str
                        }
                        if let str:String = di["points_description"] as? String
                        {
                            description = str
                        }
                        
                        self.arrTable.append(["type":"ShowPoints", "title":title, "balance":balance, "description":description])
                    }
                }
            }
            if let check:Bool = self.dict_rewards["display_tokens"] as? Bool
            {
                if check == true{
                    if let di:[String:Any] = self.dict_rewards["balance"] as? [String:Any]
                    {
                        var title = ""
                        var balance = ""
                        var description = ""
                        if let str:String = di["tokens_title"] as? String
                        {
                            title = str
                        }
                        if let str:String = di["tokens_balance_str"] as? String
                        {
                            balance = str
                        }
                        if let str:String = di["tokens_description"] as? String
                        {
                            description = str
                        }
                        
                        self.arrTable.append(["type":"ShowToken", "title":title, "balance":balance, "description":description])
                    }
                }
            }
        }
        else if selectedIndex == 1
        {
            let d:[String:Any] = arrCollView[selectedIndex]
            if let title:String = d["title"] as? String
            {
                if title == "Mis Certificados"{
                    if let arr:[[String:Any]] = self.dict_rewards["grouped_code_requests"] as? [[String:Any]]
                    {
                        self.arrTable = arr
                    }
                }
                if title == "Mis Pedidos"{
                    if let arr:[[String:Any]] = self.dict_rewards["grouped_product_requests"] as? [[String:Any]]
                    {
                        self.arrTable = arr
                    }
                }
            }
        }
        else if selectedIndex == 2
        {
            let d:[String:Any] = arrCollView[selectedIndex]
            if let title:String = d["title"] as? String
            {
                if title == "Mis Certificados"{
                    if let arr:[[String:Any]] = self.dict_rewards["grouped_code_requests"] as? [[String:Any]]
                    {
                        self.arrTable = arr
                    }
                }
                if title == "Mis Pedidos"{
                    if let arr:[[String:Any]] = self.dict_rewards["grouped_product_requests"] as? [[String:Any]]
                    {
                        self.arrTable = arr
                    }
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

extension Recompensas_NewVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerCell: CellRecompensas_New_DropdownHeader = tableView.dequeueReusableCell(withIdentifier: "CellRecompensas_New_DropdownHeader") as! CellRecompensas_New_DropdownHeader
        headerCell.selectionStyle = .none
        headerCell.tf.text = ""
        
        headerCell.tf.delegate = self
        headerCell.inCellAddPaddingTo(TextField: headerCell.tf, imageName: "down")
        headerCell.tf.setPlaceHolderColorWith(strPH: "Octubre 2021")
        headerCell.tf.layer.cornerRadius = 5.0
        headerCell.tf.layer.borderColor = UIColor.white.cgColor
        headerCell.tf.layer.borderWidth = 1.0
        headerCell.tf.layer.masksToBounds = true
        if let strV:String = dict_SelectedPickerValue["month_name"] as? String{
            headerCell.tf.text = strV
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (selectedIndex == 0) ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrTable.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if selectedIndex == 0{
            return 190
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if selectedIndex == 0{
            let dict:[String:Any] = arrTable[indexPath.row]
            
            let cell:CellRecompensas_New_Canjear = tableView.dequeueReusableCell(withIdentifier: "CellRecompensas_New_Canjear", for: indexPath) as! CellRecompensas_New_Canjear
            cell.selectionStyle = .none
            
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.lblTitle.text = ""
            cell.lblBalance.text = ""
            cell.lblDescription.text = ""
            cell.btnOperation.tag = indexPath.row
            cell.btnCanjear.tag = indexPath.row
            
            cell.btnOperation.layer.cornerRadius = 18.0
            cell.btnOperation.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
            cell.btnOperation.layer.borderWidth = 1.0
            cell.btnOperation.layer.masksToBounds = true
            
            cell.btnCanjear.layer.cornerRadius = 18.0
            cell.btnCanjear.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
            cell.btnCanjear.layer.borderWidth = 1.0
            cell.btnCanjear.layer.masksToBounds = true
            
            if indexPath.row == 0{
                cell.btnCanjear.addTarget(self, action: #selector(self.btnCanjearClick1(btn:)), for: .touchUpInside)
                cell.btnOperation.addTarget(self, action: #selector(self.btnOperationClick1(btn:)), for: .touchUpInside)
            }
            else{
                cell.btnCanjear.addTarget(self, action: #selector(self.btnCanjearClick2(btn:)), for: .touchUpInside)
                cell.btnOperation.addTarget(self, action: #selector(self.btnOperationClick2(btn:)), for: .touchUpInside)

            }
            
            if let str:String = dict["title"] as? String
            {
                cell.lblTitle.text = str
            }
            if let str:String = dict["balance"] as? String
            {
                cell.lblBalance.text = str
            }
            if let str:String = dict["description"] as? String
            {
                cell.lblDescription.text = str
            }
            return cell
        }
        else
        {
            var collVTitle = ""
            let d:[String:Any] = arrCollView[selectedIndex]
            if let title:String = d["title"] as? String
            {
                collVTitle = title
            }
            
            let dict:[String:Any] = arrTable[indexPath.row]
            
            let cell:CellRecompensas_New_Mis = tableView.dequeueReusableCell(withIdentifier: "CellRecompensas_New_Mis", for: indexPath) as! CellRecompensas_New_Mis
            cell.selectionStyle = .none
            
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.lblDate.text = ""
            cell.lblName.text = ""
            cell.lblDescription.text = ""
            cell.btn.tag = indexPath.row
            
            cell.btn.layer.cornerRadius = 16.0
            cell.btn.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
            cell.btn.layer.borderWidth = 1.0
            cell.btn.layer.masksToBounds = true
            cell.btn.addTarget(self, action: #selector(self.btnVarClick(btn:)), for: .touchUpInside)
            
            if let str:String = dict["request_date_str"] as? String
            {
                cell.lblDate.text = str
            }
            if let str:String = dict["status_description"] as? String
            {
                cell.lblDescription.text = str
            }
            
            if collVTitle == "Mis Certificados"{
                if let str:String = dict["gift_name"] as? String
                {
                    cell.lblName.text = str
                }
            }
            else{
                if let str:String = dict["product_name"] as? String
                {
                    cell.lblName.text = str
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnCanjearClick1(btn:UIButton){
        callApiForCanjear()
    }
    
    @objc func btnOperationClick1(btn:UIButton){
        callApiForOperations()
    }
    
    @objc func btnCanjearClick2(btn:UIButton){
        callApiForCanjear_2()
    }
    
    @objc func btnOperationClick2(btn:UIButton){
        callApiForOperations_2()
    }
    
    @objc func btnVarClick(btn:UIButton)
    {
        let dict:[String:Any] = self.arrTable[btn.tag]
       // print(dict)
        let d:[String:Any] = arrCollView[selectedIndex]
        if let title:String = d["title"] as? String
        {
            if title == "Mis Certificados"{

                let strUrl:String = ServiceName.GET_CodeRequest_1.rawValue
                var uuid = ""
                if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
                {
                    uuid = id
                }
                
                var strTitleNextScreen = ""
                if let str:String = dict["request_group_id"] as? String
                {
                    let param: [String:Any] = ["uuid":uuid, "request_group_id":str]
                    
                    if let date:String = dict["request_date_str"] as? String
                    {
                        if let name:String = dict["gift_name"] as? String
                        {
                            strTitleNextScreen = name + "/" + date
                        }
                    }
                    
                    callGetGroupedCodeRequest(param: param, urlString: strUrl, title:strTitleNextScreen, isMisPedidos: false)
                }
            }
            else if title == "Mis Pedidos"{
                // 
                let strUrl:String = ServiceName.GET_CodeRequest_2.rawValue
                var uuid = ""
                if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
                {
                    uuid = id
                }
                
                var strTitleNextScreen = ""
                if let str:String = dict["request_group_id"] as? String
                {
                    let param: [String:Any] = ["uuid":uuid, "request_group_id":str]
                                        
                    if let date:String = dict["request_date_str"] as? String
                    {
                        if let name:String = dict["product_name"] as? String
                        {
                            strTitleNextScreen = name + "/" + date
                        }
                    }
                    
                    callGetGroupedCodeRequest(param: param, urlString: strUrl, title:strTitleNextScreen, isMisPedidos: true)
                }
            }
        }
    }
}

extension Recompensas_NewVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reffTapTF = textField
        showPickerView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let d:[String:Any] = arrCollView[selectedIndex]
        if let title:String = d["title"] as? String
        {
            if title == "Mis Certificados"{
                self.callApiForDropDownChange1()
            }
            else{
                self.callApiForDropDownChange2()
            }
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tblView.reloadData()
        textField.resignFirstResponder()
        return true
    }
    
    func callApiForDropDownChange1(){
        
        var period_id = ""
        if let str = dict_SelectedPickerValue["month_id"] as? String
        {
            period_id = str
        }
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "period_id":period_id]
        WebService.requestService(url: ServiceName.GET_RecompansesDropdown1.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.dict_rewards["grouped_code_requests"] = arr
                            self.dict_rewards["grouped_product_requests"] = []
                            
                            DispatchQueue.main.async {
                                self.setUpData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callApiForDropDownChange2(){
        
        var period_id = ""
        if let str = dict_SelectedPickerValue["month_id"] as? String
        {
            period_id = str
        }
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "period_id":period_id]
        WebService.requestService(url: ServiceName.GET_RecompansesDropdown2.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.dict_rewards["grouped_code_requests"] = []
                            self.dict_rewards["grouped_product_requests"] = arr
                            
                            DispatchQueue.main.async {
                                self.setUpData()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Recompensas_NewVC: UIPickerViewDelegate, UIPickerViewDataSource
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
        
        if let str = dict_SelectedPickerValue["month_name"] as? String
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
        return arrDropdown.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var strTitle:String = ""
        let dict:[String:Any] = arrDropdown[row]
        if let str = dict["month_name"] as? String
        {
            strTitle = str
        }
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dict_SelectedPickerValue = arrDropdown[row]
        
        if let str = dict_SelectedPickerValue["month_name"] as? String
        {
            reffTapTF.text = str
        }
    }
}

extension Recompensas_NewVC
{
    func callApiForOperations()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        let urlStr:String = ServiceName.GET_Operations.rawValue + uuid
        
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
                            DispatchQueue.main.async {
                                
                                let vc: OperationsVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "OperationsVC_ID") as! OperationsVC
                                
                                if let str:String = dictResp["points_balance_str"] as? String{
                                    vc.strBalance = str
                                }
                                if let arr:[[String:Any]] = dictResp["transactions"] as? [[String:Any]]{
                                    vc.arrData = arr
                                }
                                
                                vc.strTitle = "Mis Certificados"
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callApiForOperations_2()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        let urlStr:String = ServiceName.GET_Operations_2.rawValue + uuid
        
        WebService.requestService(url: urlStr, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let dictResp:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                let vc: OperationsVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "OperationsVC_ID") as! OperationsVC
                                
                                if let str:String = dictResp["tokens_balance_str"] as? String{
                                    vc.strBalance = str
                                }
                                if let arr:[[String:Any]] = dictResp["transactions"] as? [[String:Any]]{
                                    vc.arrData = arr
                                }
                                vc.isTokenCall = true
                                vc.strTitle = "Mis Certificados"
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callApiForCanjear()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        let urlStr:String = ServiceName.GET_CanjearList.rawValue + uuid
        
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
                            DispatchQueue.main.async {
                                
                                let vc: CanjearListVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "CanjearListVC_ID") as! CanjearListVC
                                
                                if let str:String = dictResp["points_balance_str"] as? String{
                                    vc.strBalance = str
                                }
                                if let arr:[[String:Any]] = dictResp["available_gifts"] as? [[String:Any]]{
                                    vc.arrData = arr
                                }
                                
                                vc.strTitle = "Canejar mis Puntos"
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callApiForCanjear_2()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        let urlStr:String = ServiceName.GET_CanjearList_2.rawValue + uuid
        
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
                            DispatchQueue.main.async {
                                
                                let vc: CanjearList_2VC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "CanjearList_2VC_ID") as! CanjearList_2VC
                                
                                if let str:String = dictResp["tokens_balance_str"] as? String{
                                    vc.strBalance = str
                                }
                                if let arr:[[String:Any]] = dictResp["available_products"] as? [[String:Any]]{
                                    vc.arrData = arr
                                }
                                
                                vc.strTitle = "Canejar mis Tokens"
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Recompensas_NewVC
{
    func callGetGroupedCodeRequest(param: [String:Any], urlString: String, title:String, isMisPedidos:Bool)
    {
        self.showSpinnerWith(title: "Cargando...")
        
        WebService.requestService(url: urlString, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                let vc: VarClickedVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "VarClickedVC_ID") as! VarClickedVC
                                                                                            
                                if isMisPedidos == true{
                                   
                                    if let arr:[[String:Any]] = dict["product_requests"] as? [[String:Any]]{
                                        vc.arrCollV = arr
                                    }
                                    vc.arrData = ["Resumen de Solicitudes", "Solicitudes"]
                                }
                                else{
                                   
                                    if let arr:[[String:Any]] = dict["code_requests"] as? [[String:Any]]{
                                        vc.arrCollV = arr
                                    }
                                    vc.arrData = ["Resumen de Solicitudes", "Descarga las Solicitudes", "Solicitudes"]
                                }
                                
                                vc.isMisPedidos = isMisPedidos
                                vc.strTitle = title
                                vc.dictMain = dict
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
