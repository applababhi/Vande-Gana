//
//  HistoricalVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 25/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class HistoricalVC: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!
    
    var arrData: [String] = []   // ["Chart1", "Dropdown", "Result", "Chart2"]
    var strPicker:String = ""
    var monthIdSelected :String = ""
    var arr_ToPassToChart1:[[[String:Any]]] = []
    var arr_ToPassToChart2:[[[String:Any]]] = []
    var arr_MonthPicker:[[String:Any]] = []
    var picker : UIPickerView!
    var reffTapTF:UITextField!
    
    var sales_str = "NA"
    var kpi_str = "NA"
    var progress_str = "NA"
    var att_average_str = "NA"
    var obtained_points_str = "NA"
    var redeemed_points_str = "NA"

    var arrRegions: [[String:Any]] = []
    var strRegion_Title = ""
    var strRegion_SubTitle = ""

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "Desempeño Histórico"
       setUpTopBar()
    }

    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetHistoryData()
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
    
    @objc func btnViewInfoClick(btn:UIButton)
    {
        if monthIdSelected == ""
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            print("Call View Info Api")
            callGetViewInfoData()
        }
    }
    
    @objc func btnViewTransactionClick(btn:UIButton)
    {
        if let arr: [[String:Any]] = k_helper.tempViewTransactionDictFromHistoryVC["transactions"] as? [[String:Any]]
        {
            let vc: PointdetailTransactionsVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "PointdetailTransactionsVC_ID") as! PointdetailTransactionsVC
            vc.arrData = arr
            vc.balance = k_helper.tempViewTransactionBalanceFromHistoryVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
    }
}

extension HistoricalVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let str:String = arrData[indexPath.row]

        if str == "Chart1"
        {
            return 230
        }
        else if str == "Dropdown"
        {
            return 140
        }
        else if str == "Result"
        {
            return 610
        }
        else if str == "Region"
        {
            return CGFloat(100 + (self.arrRegions.count * 160))
        }
        else if str == "Chart2"
        {
            return 230
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let str:String = arrData[indexPath.row]
        
        if str == "Chart1"
        {
            let cell:CellHistory_Chart = tableView.dequeueReusableCell(withIdentifier: "CellHistory_Chart", for: indexPath) as! CellHistory_Chart
            cell.selectionStyle = .none

            cell.lblTitle.text = "Activaciones por Mes"
            cell.lblCircle1.text = "Cuota"
            cell.lblCircle2.text = "Activaciones"
            
            cell.lblTitle.textColor = k_baseColor
            
            cell.v_Circle1.backgroundColor = .black
            cell.v_Circle1.layer.cornerRadius = 7.0
            cell.v_Circle1.layer.masksToBounds = true

            cell.v_Circle2.backgroundColor = k_baseColor
            cell.v_Circle2.layer.cornerRadius = 7.0
            cell.v_Circle2.layer.masksToBounds = true

            
            if self.arr_ToPassToChart1.count > 0
            {
                cell.v_Bk.layer.borderWidth = 0.6
                cell.v_Bk.layer.cornerRadius = 5.0
                cell.v_Bk.layer.masksToBounds = true
                
                let controller: HistoryChartVC = AppStoryBoards.Dashboard.instance.instantiateViewController(withIdentifier: "HistoryChartVC_ID") as! HistoryChartVC
                
                if self.arr_ToPassToChart1.count > 0
                {
                    controller.arr_BarsCollV = self.arr_ToPassToChart1.first!
                }
                
                controller.view.frame = cell.v_Bk.bounds;
                controller.willMove(toParent: self)
                cell.v_Bk.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
            }
            
            return cell
        }
        else if str == "Region"
        {
                let cell:CellMain_Regions = tableView.dequeueReusableCell(withIdentifier: "CellMain_Regions", for: indexPath) as! CellMain_Regions
                cell.selectionStyle = .none
                cell.vBk.layer.cornerRadius = 5.0
                cell.vBk.layer.masksToBounds = true
                
                cell.lblTitle.text = strRegion_Title
                cell.lblSubTitle.text = strRegion_SubTitle
                cell.arrData = self.arrRegions
                
                return cell
        }
        else if str == "Dropdown"
        {
            let cell:CellHistory_Dropdown = tableView.dequeueReusableCell(withIdentifier: "CellHistory_Dropdown", for: indexPath) as! CellHistory_Dropdown
            cell.selectionStyle = .none

            cell.lblTitle.text = "Desempeño por Mes"
            cell.tfDropdown.text = strPicker
            cell.tfDropdown.delegate = self
            cell.inCellAddPaddingTo(TextField: cell.tfDropdown, imageName: "down")
            cell.tfDropdown.setPlaceHolderColorWith(strPH: "Octubre 2019")
            
            cell.tfDropdown.layer.cornerRadius = 5.0
            cell.tfDropdown.layer.borderColor = UIColor.gray.cgColor
            cell.tfDropdown.layer.borderWidth = 0.7
            cell.tfDropdown.layer.masksToBounds = true
            
            cell.btnViewInfo.layer.cornerRadius = 5.0
            cell.btnViewInfo.layer.masksToBounds = true
            
            cell.btnViewInfo.addTarget(self, action: #selector(self.btnViewInfoClick(btn:)), for: .touchUpInside)
            
            return cell
        }
        else if str == "Result"
        {
            let cell:CellHistory_Result = tableView.dequeueReusableCell(withIdentifier: "CellHistory_Result", for: indexPath) as! CellHistory_Result
            cell.selectionStyle = .none

            cell.v_1.layer.cornerRadius = 5.0
            cell.v_1.layer.masksToBounds = true
            cell.v_2.layer.cornerRadius = 5.0
            cell.v_2.layer.masksToBounds = true
            cell.v_3.layer.cornerRadius = 5.0
            cell.v_3.layer.masksToBounds = true
            cell.v_4.layer.cornerRadius = 5.0
            cell.v_4.layer.masksToBounds = true
            cell.v_5.layer.cornerRadius = 5.0
            cell.v_5.layer.masksToBounds = true
            cell.v_6.layer.cornerRadius = 5.0
            cell.v_6.layer.masksToBounds = true
            
            cell.btnViewTransactions.layer.cornerRadius = 5.0
            cell.btnViewTransactions.layer.masksToBounds = true
            
            cell.lbl1_Title.text = ""
            cell.lbl2_Title.text = ""
            cell.lbl3_Title.text = ""
            cell.lbl4_Title.text = ""
            cell.lbl5_Title.text = ""
            cell.lbl6_Title.text = ""
            
            cell.lbl1_Title.text = sales_str
            cell.lbl2_Title.text = kpi_str
            cell.lbl3_Title.text = progress_str
            cell.lbl4_Title.text = att_average_str
            cell.lbl5_Title.text = obtained_points_str
            cell.lbl6_Title.text = redeemed_points_str

            cell.btnViewTransactions.addTarget(self, action: #selector(self.btnViewTransactionClick(btn:)), for: .touchUpInside)
            
            return cell
        }
        else if str == "Chart2"
        {
            let cell:CellHistory_Chart = tableView.dequeueReusableCell(withIdentifier: "CellHistory_Chart", for: indexPath) as! CellHistory_Chart
            cell.selectionStyle = .none

            cell.lblTitle.text = "Ventas Semanales"
            cell.lblCircle1.text = "Cuota"
            cell.lblCircle2.text = "Activaciones"
            
            cell.lblTitle.textColor = .darkGray
            
            cell.v_Circle1.backgroundColor = .black
            cell.v_Circle1.layer.cornerRadius = 7.0
            cell.v_Circle1.layer.masksToBounds = true

            cell.v_Circle2.backgroundColor = k_baseColor
            cell.v_Circle2.layer.cornerRadius = 7.0
            cell.v_Circle2.layer.masksToBounds = true

            cell.lblCircle1.isHidden = true
            cell.lblCircle2.isHidden = true
            cell.v_Circle1.isHidden = true
            cell.v_Circle2.isHidden = true
            
            if self.arr_ToPassToChart2.count > 0
            {
                cell.v_Bk.layer.borderWidth = 0.6
                cell.v_Bk.layer.cornerRadius = 5.0
                cell.v_Bk.layer.masksToBounds = true

                let controller: HistoryChartVC = AppStoryBoards.Dashboard.instance.instantiateViewController(withIdentifier: "HistoryChartVC_ID") as! HistoryChartVC
                
                if self.arr_ToPassToChart2.count > 0
                {
                    controller.arr_BarsCollV = self.arr_ToPassToChart2.first!
                }

                controller.view.frame = cell.v_Bk.bounds;
                controller.willMove(toParent: self)
                cell.v_Bk.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}

extension HistoricalVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reffTapTF = textField
        showPickerView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        strPicker = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tblView.reloadData()
        textField.resignFirstResponder()
        return true
    }
}

extension HistoricalVC: UIPickerViewDelegate, UIPickerViewDataSource
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
        
        if monthIdSelected == ""
        {
            // means just click done button but didn't scrolled the picker
            let dict:[String:Any] = arr_MonthPicker.first!
            
            if let str = dict["month_name"] as? String
            {
                reffTapTF.text = str
                strPicker = str

                if let stId:String = dict["month_id"] as? String
                {
                    monthIdSelected = stId
                }
            }
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
        return arr_MonthPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var strTitle:String = ""
        let dict:[String:Any] = arr_MonthPicker[row]
        if let str = dict["month_name"] as? String
        {
            strTitle = str
        }
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dict:[String:Any] = arr_MonthPicker[row]
        
        if let str = dict["month_name"] as? String
        {
            reffTapTF.text = str
            strPicker = str

            if let stId:String = dict["month_id"] as? String
            {
                monthIdSelected = stId
            }
        }        
    }
}

extension HistoricalVC
{
    func callGetHistoryData()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        let urlStr:String = ServiceName.GET_History.rawValue + uuid
        
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
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            self.arr_ToPassToChart1.removeAll()
                            
                            if let ar:[[String:Any]] = dict["months_summaries"] as? [[String:Any]]
                            {
                                self.arr_ToPassToChart1.append(ar)
                                
                                self.arrData.append("Chart1")
                            }
                            
                            
                            if let ar:[[String:Any]] = dict["available_months"] as? [[String:Any]]
                            {
                                self.arr_MonthPicker = ar
                                self.arrData.append("Dropdown")
                            }
                            
                            // self.arrData = ["Chart1", "Dropdown", "Result", "Chart2"]
                            
                            DispatchQueue.main.async {
                                
                                if self.tblView.delegate == nil
                                {
                                    self.tblView.delegate = self
                                    self.tblView.dataSource = self
                                }
                                self.tblView.reloadData()

                            }
                        }
                    }
                }
            }
        }
    }
    
    func callGetViewInfoData()
    {
        self.arrData.removeAll()
        self.arrData.append("Chart1")
        self.arrData.append("Dropdown")
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        var urlStr:String = ServiceName.GET_History_ViewInfo.rawValue
        urlStr = urlStr.replacingOccurrences(of: "+AA+", with: uuid)
        
        urlStr = urlStr + monthIdSelected
       // print(urlStr)
        
        WebService.requestService(url: urlStr, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            print(jsonString)
            
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
                            self.arr_ToPassToChart2.removeAll()
                                                        
                            self.arrData.append("Result")
                            
                            if let dRegion: [String:Any] = dict["regions_widget"] as? [String:Any]
                            {
                                if let check:Bool = dRegion["display_regions_widget"] as? Bool
                                {
                                    if check == true
                                    {
                                        // add a new widget in MainArray, if false then don't add
                                                                                
                                        self.arrData.append("Region")
                                        
                                        if let arrRe: [[String:Any]] = dRegion["regions"] as? [[String:Any]]
                                        {
                                            self.arrRegions = arrRe
                                        }
                                        if let str: String = dRegion["description_1"] as? String
                                        {
                                            self.strRegion_Title = str
                                        }
                                        if let str: String = dRegion["description_2"] as? String
                                        {
                                            self.strRegion_SubTitle = str
                                        }
                                    }
                                }
                            }

                            if let ar:[[String:Any]] = dict["weeks_summaries"] as? [[String:Any]]
                            {
                                self.arr_ToPassToChart2.append(ar)
                                
                                self.arrData.append("Chart2")
                            }
                            
                            if let str:String = dict["sales_str"] as? String
                            {
                                self.sales_str = str
                            }
                            if let str:String = dict["kpi_str"] as? String
                            {
                                self.kpi_str = str
                            }
                            if let str:String = dict["progress_str"] as? String
                            {
                                self.progress_str = str
                            }
                            if let str:String = dict["att_average_str"] as? String
                            {
                                self.att_average_str = str
                            }
                            if let str:String = dict["obtained_points_str"] as? String
                            {
                                self.obtained_points_str = str
                            }
                            if let str:String = dict["redeemed_points_str"] as? String
                            {
                                self.redeemed_points_str = str
                            }
                            
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}
