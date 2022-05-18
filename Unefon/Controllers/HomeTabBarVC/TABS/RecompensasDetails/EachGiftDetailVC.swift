//
//  EachGiftDetailVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/6/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class EachGiftDetailVC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!
    
    var password = ""
    var picker : UIPickerView!
    var reffTapTF:UITextField!
    var dict_SelectedPeriod:[String:Any] = [:]
    var arrPicker:[[String:Any]] = []
    var tfPickerTag = 100001
    var display_source_value_description = false // only for Picker in additional_fields

    var dictMain:[String:Any] = [:]
    var additional_fields: [[String:Any]] = []
    
    // reference_number, reference_id and reference_name
    var dict_TextValues_additional_fields:[String:Any] = ["reference_number":"", "reference_id":"", "reference_name":""]

    // these 4 will always be there, on basis of "additional_fields" we will insert additional component before "Finalizar"
    var arrData:[String] = ["Header", "Resumen del pedido", "Por favor, ingresa la siguiente información", "Finalizar"]
    
    var denomination = ""
    var quantity = ""
    var gift_id = ""

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let val:Int = dictMain["denomination"] as? Int{
            denomination = "\(val)"
        }
        if let val:Int = dictMain["quantity"] as? Int{
            quantity = "\(val)"
        }

        
        if let arr:[[String:Any]] = dictMain["additional_fields"] as? [[String:Any]]{
            additional_fields = arr
            var count = 0
            for di in arr
            {
                if let field_type:Int = di["field_type"] as? Int{
                    count += 1
                    if field_type == 2
                    {
                        // Picker
                        
                        if let check:Bool = di["display_source_value_description"] as? Bool{
                            display_source_value_description = check
                        }
                        
                        if let arrP:[[String:Any]] = di["source_values"] as? [[String:Any]]{
                            arrPicker = arrP
                            if arrP.count > 0{
                                dict_SelectedPeriod = arrP.first!
                                if let strType:String = di["target_property_name"] as? String{
                                    if let strV:String = dict_SelectedPeriod["id"] as? String
                                    {
                                        dict_TextValues_additional_fields[strType] = strV
                                    }
                                }
                            }
                        }
                        dict_TextValues_additional_fields["TFvalue_\(count)"] = ""
                        arrData.insert("additional_fields", at: (arrData.count - 1))
                    }
                    else{
                        // normal tf
                        dict_TextValues_additional_fields["TFvalue_\(count)"] = ""
                        arrData.insert("additional_fields", at: (arrData.count - 1))
                    }
                }
            }
        }
      //  print(arrData)
       // print(dict_TextValues_additional_fields)
        
        setUpTopBar()
        lblHeader.text = "Certificado de Regalo"
        hideKeyboardWhenTappedAround()
        
        tblView.delegate = self
        tblView.dataSource = self
    }
    
    func setUpTopBar()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
            c_Header_Ht.constant = 90
            setHeadGradient(height: 90)
        }
        else if strModel == "iPhone Max"
        {
            c_Header_Ht.constant = 90
            setHeadGradient(height: 90)
        }
        else if strModel == "iPhone 5"
        {
            
        }
        else{
            c_Header_Ht.constant = 110
            setHeadGradient(height: 110)
        }
    }
    
    func setHeadGradient(height:Int){
        let fistColor = UIColor(named: "App_DarkBlack")!
        let lastColor = UIColor(named: "App_LightBlack")!
        
        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.colors = [fistColor.cgColor, lastColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: height)
        vHeader.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func btnBack(btn:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

extension EachGiftDetailVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let strType:String = arrData[indexPath.row]
        
        if strType == "Header"{
            return 65
        }
        else if strType == "Resumen del pedido"{
            return 315
        }
        else if strType == "Por favor, ingresa la siguiente información"{
            return 162
        }
        else if strType == "Finalizar"{
            return 50
        }
        else {
            // for all the dynamic widget same height    "additional_fields"
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let strType:String = arrData[indexPath.row]
        
        if strType == "Header"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.imgView.image = nil
            cell.imgView.layer.cornerRadius = 25.0
            cell.imgView.layer.borderWidth = 1.5
            cell.imgView.layer.borderColor = UIColor.white.cgColor
            cell.imgView.layer.masksToBounds = true
            
            cell.lblTitle.text = ""
            cell.lblSubtitle.text = ""
            
            if let imgStr:String = dictMain["front_cover_url"] as? String
            {
                cell.imgView.setImageUsingUrl(imgStr)
            }
            if let str:String = dictMain["gift_name"] as? String
            {
                cell.lblTitle.text = str
            }
            if let str:String = dictMain["brand"] as? String
            {
                cell.lblSubtitle.text = str
            }
            
            return cell
        }
        else if strType == "Resumen del pedido"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Resumen del pedido", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.lbl1.text = ""
            cell.lbl2.text = ""
            cell.lbl3.text = ""
            cell.lbl4.text = ""
            cell.lbl5.text = ""
            
            if let str:String = dictMain["gift_name"] as? String
            {
                cell.lbl1.text = str
            }
            if let str:String = dictMain["denomination_str"] as? String
            {
                cell.lbl2.text = str
            }
            if let str:String = dictMain["quantity_str"] as? String
            {
                cell.lbl3.text = str
            }
            if let str:String = dictMain["cost_str"] as? String
            {
                cell.lbl4.text = str
            }
            if let str:String = dictMain["current_balance_str"] as? String
            {
                cell.lbl5.text = str
            }

            return cell
        }
        else if strType == "Por favor, ingresa la siguiente información"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Por favor, ingresa la siguiente información", for: indexPath) as! CellCanjearListMain
            
            // PASSWORD
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.tf.delegate = self
            cell.tf.isSecureTextEntry = true
            cell.tf.tag = 101
            cell.tf.placeholder = "Introducir la contraseña"
            cell.tf.text = password
            cell.inCellAddPaddingTo(TextField: cell.tf, imageName: "")
            cell.tf.layer.cornerRadius = 5.0
            cell.tf.layer.borderColor = UIColor.white.cgColor
            cell.tf.layer.borderWidth = 1.0
            cell.tf.layer.masksToBounds = true

            return cell
        }
        else if strType == "Finalizar"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Finalizar", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            
            cell.btn.layer.cornerRadius = 18.0
            cell.btn.layer.borderWidth = 1.0
            cell.btn.layer.masksToBounds = true
            cell.btn.setTitleColor(UIColor(named: "App_Blue")!, for: .normal)
            cell.btn.layer.borderColor = UIColor(named: "App_Blue")!.cgColor

            cell.btn.addTarget(self, action: #selector(self.btnContinueClick(btn:)), for: .touchUpInside)
            
            return cell
        }
        else {
            // for all the dynamic widget same height    "additional_fields"
            // to use data inside cellForRow for  additional_fields we will minus 3 to get exact index
            let index = (indexPath.row) - 3
            let di:[String:Any] = additional_fields[index]
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "additional_fields", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            cell.lblSubtitle.text = ""
            
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.tf.delegate = self
            cell.tf.isSecureTextEntry = false
            cell.tf.tag = index
            cell.tf.text = ""
            cell.inCellAddPaddingTo(TextField: cell.tf, imageName: "")
            cell.tf.layer.cornerRadius = 5.0
            cell.tf.layer.borderColor = UIColor.white.cgColor
            cell.tf.layer.borderWidth = 1.0
            cell.tf.layer.masksToBounds = true
            cell.tf.keyboardType = .default
            
            cell.c_Warning_Ht.constant = 0
            cell.lblWarning.text = ""
            
            if let check:Bool = di["is_numeric"] as? Bool
            {
                if check == true{
                    cell.tf.keyboardType = .phonePad
                }
            }
            
            if let str:String = di["field_name"] as? String
            {
                cell.lblTitle.text = str
                cell.tf.placeholder = str
            }
            if let str:String = di["field_description"] as? String
            {
                cell.lblSubtitle.text = str
            }
            
            if let field_type:Int = di["field_type"] as? Int{
                if field_type == 2
                {
                    // Picker
                    cell.tf.tag = tfPickerTag
                    
                    cell.inCellAddPaddingTo(TextField: cell.tf, imageName: "down")
                    if let strV:String = dict_SelectedPeriod["value"] as? String
                    {
                        cell.tf.text = strV
                    }
                    
                    if display_source_value_description == true{
                        
                        if let strV:String = dict_SelectedPeriod["description"] as? String
                        {
                            cell.lblWarning.text = strV
                            cell.c_Warning_Ht.constant = 35
                        }
                    }
                    
                }
                else{
                    if let str:String = di["pre_filled_value"] as? String
                    {
                        if let strType:String = di["target_property_name"] as? String{
                            dict_TextValues_additional_fields[strType] = str
                        }
                        
                        dict_TextValues_additional_fields["TFvalue_\(index)"] = str
                        
                        cell.tf.text = str
                    }

                    if let str:String = dict_TextValues_additional_fields["TFvalue_\(index)"] as? String
                    {
                        cell.tf.text = str
                    }
                }
            }
                        
            return cell
        }
    }
    
    @objc func btnContinueClick(btn:UIButton)
    {
        if password == ""{
            self.showAlertWithTitle(title: "Alert", message: "Por favor, ingrese contraseña", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        
        print("CALL API....")
        
        // dict_TextValues_additional_fields = ["reference_number":"", "reference_id":"", "reference_name":""]
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }

        var param: [String:Any] = ["uuid":uuid, "gift_id":gift_id, "denomination":denomination, "password":password.md5Value, "quantity":quantity]
        
        if let str:String = dict_TextValues_additional_fields["reference_number"] as? String{
            param["reference_number"] = str
        }
        if let str:String = dict_TextValues_additional_fields["reference_id"] as? String{
            param["reference_id"] = str
        }
        if let str:String = dict_TextValues_additional_fields["reference_name"] as? String{
            param["reference_name"] = str
        }
        print(param)
        
        callGetRedemption(param: param)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension EachGiftDetailVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == tfPickerTag{
            // Picker
            reffTapTF = textField
            showPickerView()
        }
        else if textField.tag == 101{
            // PASSWORD
            
        }
        else{
            //   "additional_fields"
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        if textField.tag == 101{
            // password
            password = textField.text!
        }
        else{
            //   "additional_fields"
            if textField.tag == tfPickerTag{
                // Picker
                if let strV:String = dict_SelectedPeriod["id"] as? String
                {
                    for di in additional_fields{
                        if let field_type:Int = di["field_type"] as? Int{
                            if field_type == 2{
                                // Picker
                                if let strType:String = di["target_property_name"] as? String{
                                    dict_TextValues_additional_fields[strType] = strV
                                }
                            }
                        }
                    }
                }
            }
            else{
                dict_TextValues_additional_fields["TFvalue_\(textField.tag)"] = textField.text!
                
                for di in additional_fields{
                    if let field_type:Int = di["field_type"] as? Int{
                        if field_type == 1{
                            if let strType:String = di["target_property_name"] as? String{
                                dict_TextValues_additional_fields[strType] = textField.text!
                            }
                        }
                    }
                }
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

extension EachGiftDetailVC: UIPickerViewDelegate, UIPickerViewDataSource
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
        
        if let str = dict_SelectedPeriod["value"] as? String
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
        return arrPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var strTitle:String = ""
        let dict:[String:Any] = arrPicker[row]
        if let str = dict["value"] as? String
        {
            strTitle = str
        }
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dict_SelectedPeriod = arrPicker[row]
        
        if let str = dict_SelectedPeriod["value"] as? String
        {
            reffTapTF.text = str
        }
    }
}

extension EachGiftDetailVC
{
    func callGetRedemption(param: [String:Any])
    {
        self.showSpinnerWith(title: "Cargando...")
        
        WebService.requestService(url: ServiceName.POST_SubmitBuyGiftPost.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
           // print(jsonString)
            
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
                            if let codeID:String = dict["code_request_id"] as? String
                            {
                                if let msg:String = json["message"] as? String
                                {
                                    self.showAlertWithTitle(title: "Vende y Gana", message: msg + " " + codeID, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.back))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func back(){
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
