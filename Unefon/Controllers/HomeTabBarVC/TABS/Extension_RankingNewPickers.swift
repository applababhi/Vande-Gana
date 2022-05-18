//
//  Extension_RankingNewPickers.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/3/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import Foundation
import UIKit

extension Rankings_NewVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reffTapTF = textField
        showPickerView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 100{
            // GENERAL
            if let month_id = dict_SelectedGeneralPeriod["month_id"] as? String
            {
                print("Call API 1 using. .. . .  ", month_id)
                
                
                if arr_regional_periods_FULL.count > 0{
                    
                    let aSelected:[[String:Any]] = self.arr_regional_periods_FULL.filter{(d:[String:Any]) -> Bool in
                        if let strPeriodID:String = d["period_id"] as? String{
                            if strPeriodID == month_id{
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

                
                
                callGetRankingGeneral(period_id: month_id)
            }
        }
        else{
            // REGIONAL
            if let region_id:Int = dict_SelectedRegionPeriod["region_id"] as? Int
            {
                print("Call API 2 using. .. . .  ", region_id)
                callGetRankingRegional(region_id: "\(region_id)")
            }
        }
        
        tblView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tblView.reloadData()
        textField.resignFirstResponder()
        return true
    }
}

extension Rankings_NewVC: UIPickerViewDelegate, UIPickerViewDataSource
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
        
        if reffTapTF.tag == 100{
            // GENERAL
            if let str = dict_SelectedGeneralPeriod["month_name"] as? String
            {
                reffTapTF.text = str
            }
        }
        else{
            // REGIONAL
            if let str = dict_SelectedRegionPeriod["region_name"] as? String
            {
                reffTapTF.text = str
            }
        }
        picker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
        picker = nil
        reffTapTF = nil
        tblView.reloadData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if reffTapTF.tag == 100{
            // GENERAL
            return arr_general_periods.count
        }
        else{
            // REGIONAL
            return arr_regional_periods.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var strTitle:String = ""
        
        if reffTapTF.tag == 100{
            // GENERAL
            let dict:[String:Any] = arr_general_periods[row]
            if let str = dict["month_name"] as? String
            {
                strTitle = str
            }
        }
        else{
            // REGIONAL
            let dict:[String:Any] = arr_regional_periods[row]
            if let str = dict["region_name"] as? String
            {
                strTitle = str
            }
        }
        
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if reffTapTF.tag == 100{
            // GENERAL
            dict_SelectedGeneralPeriod = arr_general_periods[row]
            
            if let str = dict_SelectedGeneralPeriod["month_name"] as? String
            {
                reffTapTF.text = str
            }
        }
        else{
            // REGIONAL
            dict_SelectedRegionPeriod = arr_regional_periods[row]
            
            if let str = dict_SelectedRegionPeriod["region_name"] as? String
            {
                reffTapTF.text = str
            }
        }
    }
}

extension Rankings_NewVC{
    func callGetRankingGeneral(period_id:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
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
        let param: [String:Any] = ["uuid":uuid, "plan_id":plan_id, "period_id":period_id]
        WebService.requestService(url: ServiceName.GET_Ranking_General.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let dictM:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            self.dict_general_leaderboard = dictM
                            DispatchQueue.main.async
                            {
                                if self.selectedTab == 1{
                                    self.changeTabData()
                                }
                                else{
                                    // REGIONAL
                                    if let region_id:Int = self.dict_SelectedRegionPeriod["region_id"] as? Int
                                    {
                                        print("Call API 2 using. .. . .  ", region_id)
                                        self.callGetRankingRegional(region_id: "\(region_id)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callGetRankingRegional(region_id:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan_id.rawValue) as? String
        {
            plan_id = id
        }
        if plan_id == ""
        {
            return
        }
        
        var period_id = ""
        if let _id = dict_SelectedGeneralPeriod["month_id"] as? String
        {
            period_id = _id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "plan_id":plan_id, "region_id":region_id, "period_id": period_id]
        WebService.requestService(url: ServiceName.GET_Ranking_Regional.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
    //        print(jsonString)
            
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
                        
                        if let dictM:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            self.dict_regional_leaderboard = dictM
                            DispatchQueue.main.async {
                                self.changeTabData()
                            }
                        }
                    }
                }
            }
        }
    }
}
