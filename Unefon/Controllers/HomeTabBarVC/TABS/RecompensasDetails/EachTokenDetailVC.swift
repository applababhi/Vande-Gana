//
//  EachTokenDetailVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/10/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class EachTokenDetailVC: UIViewController {
    
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

    var dictMain:[String:Any] = [:]

    // these 4 will always be there, on basis of "additional_fields" we will insert additional component before "Finalizar"
    var arrData:[String] = ["Header", "Resumen del pedido", "Por favor, ingresa la siguiente información", "Address", "Finalizar"]
    
    var quantity = ""
    var product_sku = ""
    var product_description = ""
    var product_characteristics = ""
    var tokens_balance_str = ""

    var shipping_address_street = ""
    var shipping_address_ext_num = ""
    var shipping_address_int_num = ""
    var shipping_address_place = ""
    var shipping_address_municipality = ""
    var shipping_address_state = ""
    var shipping_address_zip_code = ""
    var shipping_address_references = ""
    var shipping_address_receiver_name = ""

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        if let val:Int = dictMain["quantity"] as? Int{
            quantity = "\(val)"
        }

        
      //  print(arrData)
       // print(dict_TextValues_additional_fields)
        
        setUpTopBar()
        lblHeader.text = "Certificado de Regalo"
        hideKeyboardWhenTappedAround()
        
        callPickerListApi()
        
        if let val:String = dictMain["shipping_address_street"] as? String{
            shipping_address_street = val
        }
        if let val:String = dictMain["shipping_address_ext_num"] as? String{
            shipping_address_ext_num = val
        }
        if let val:String = dictMain["shipping_address_int_num"] as? String{
            shipping_address_int_num = val
        }
        if let val:String = dictMain["shipping_address_place"] as? String{
            shipping_address_place = val
        }
        if let val:String = dictMain["shipping_address_municipality"] as? String{
            shipping_address_municipality = val
        }
        if let val:String = dictMain["shipping_address_zip_code"] as? String{
            shipping_address_zip_code = val
        }
        if let val:String = dictMain["shipping_address_references"] as? String{
            shipping_address_references = val
        }
        if let val:String = dictMain["shipping_address_receiver_name"] as? String{
            shipping_address_receiver_name = val
        }
        
        if let val:Int = dictMain["shipping_address_state"] as? Int{
            shipping_address_state = "\(val)"
        }

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

extension EachTokenDetailVC: UITableViewDataSource, UITableViewDelegate
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
        else if strType == "Address"{
            return 620
        }
        else {
//            "Finalizar"
            return 50
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
            
            if let imgStr:String = dictMain["cover_url"] as? String
            {
                cell.imgView.setImageUsingUrl(imgStr)
            }
            if let str:String = dictMain["product_name"] as? String
            {
                cell.lblTitle.text = str
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
                        
            cell.lbl1.text = product_description
            cell.lbl2.text = product_characteristics
            cell.lbl3.text = product_sku
            cell.lbl5.text = tokens_balance_str

            if let price_str:String = dictMain["price_str"] as? String
            {
                cell.lbl4.text = price_str
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
        else if strType == "Address"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Address", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true

            cell.tf_1.tag = 200
            cell.tf_2.tag = 201
            cell.tf_3.tag = 202
            cell.tf_4.tag = 203
            cell.tf_5.tag = 204
            cell.tf_6.tag = tfPickerTag  // PICKER
            cell.tf_7.tag = 206
            cell.tf_8.tag = 207
            cell.tf_9.tag = 208
            
            cell.tf_1.delegate = self
            cell.tf_2.delegate = self
            cell.tf_3.delegate = self
            cell.tf_4.delegate = self
            cell.tf_5.delegate = self
            cell.tf_6.delegate = self  // PICKER
            cell.tf_7.delegate = self
            cell.tf_8.delegate = self
            cell.tf_9.delegate = self

            cell.tf_1.backgroundColor = .clear
            cell.tf_2.backgroundColor = .clear
            cell.tf_3.backgroundColor = .clear
            cell.tf_4.backgroundColor = .clear
            cell.tf_5.backgroundColor = .clear
            cell.tf_6.backgroundColor = .clear  // PICKER
            cell.tf_7.backgroundColor = .clear
            cell.tf_8.backgroundColor = .clear
            cell.tf_9.backgroundColor = .clear

            cell.inCellAddPaddingTo(TextField: cell.tf_6, imageName: "down")
            cell.inCellAddPaddingTo(TextField: cell.tf_1, imageName: "")
            cell.inCellAddPaddingTo(TextField: cell.tf_2, imageName: "")
            cell.inCellAddPaddingTo(TextField: cell.tf_3, imageName: "")
            cell.inCellAddPaddingTo(TextField: cell.tf_4, imageName: "")
            cell.inCellAddPaddingTo(TextField: cell.tf_5, imageName: "")
            cell.inCellAddPaddingTo(TextField: cell.tf_7, imageName: "")
            cell.inCellAddPaddingTo(TextField: cell.tf_8, imageName: "")
            cell.inCellAddPaddingTo(TextField: cell.tf_9, imageName: "")
            
            cell.tf_1.layer.cornerRadius = 5.0
            cell.tf_1.layer.borderColor = UIColor.white.cgColor
            cell.tf_1.layer.borderWidth = 1.0
            cell.tf_1.layer.masksToBounds = true
            
            cell.tf_2.layer.cornerRadius = 5.0
            cell.tf_2.layer.borderColor = UIColor.white.cgColor
            cell.tf_2.layer.borderWidth = 1.0
            cell.tf_2.layer.masksToBounds = true

            cell.tf_3.layer.cornerRadius = 5.0
            cell.tf_3.layer.borderColor = UIColor.white.cgColor
            cell.tf_3.layer.borderWidth = 1.0
            cell.tf_3.layer.masksToBounds = true

            cell.tf_4.layer.cornerRadius = 5.0
            cell.tf_4.layer.borderColor = UIColor.white.cgColor
            cell.tf_4.layer.borderWidth = 1.0
            cell.tf_4.layer.masksToBounds = true

            cell.tf_5.layer.cornerRadius = 5.0
            cell.tf_5.layer.borderColor = UIColor.white.cgColor
            cell.tf_5.layer.borderWidth = 1.0
            cell.tf_5.layer.masksToBounds = true

            cell.tf_6.layer.cornerRadius = 5.0
            cell.tf_6.layer.borderColor = UIColor.white.cgColor
            cell.tf_6.layer.borderWidth = 1.0
            cell.tf_6.layer.masksToBounds = true

            cell.tf_7.layer.cornerRadius = 5.0
            cell.tf_7.layer.borderColor = UIColor.white.cgColor
            cell.tf_7.layer.borderWidth = 1.0
            cell.tf_7.layer.masksToBounds = true

            cell.tf_8.layer.cornerRadius = 5.0
            cell.tf_8.layer.borderColor = UIColor.white.cgColor
            cell.tf_8.layer.borderWidth = 1.0
            cell.tf_8.layer.masksToBounds = true

            cell.tf_9.layer.cornerRadius = 5.0
            cell.tf_9.layer.borderColor = UIColor.white.cgColor
            cell.tf_9.layer.borderWidth = 1.0
            cell.tf_9.layer.masksToBounds = true
            
            cell.tf_1.text = shipping_address_street
            cell.tf_2.text = shipping_address_ext_num
            cell.tf_3.text = shipping_address_int_num
            cell.tf_4.text = shipping_address_place
            cell.tf_5.text = shipping_address_municipality

            cell.tf_7.text = shipping_address_zip_code
            cell.tf_8.text = shipping_address_references
            cell.tf_9.text = shipping_address_receiver_name
            
            
            if let strV:String = dict_SelectedPeriod["value"] as? String
            {
                cell.tf_6.text = strV
            }
            
            return cell
        }
        else {
            // Finalizer
            
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
    }
    
    @objc func btnContinueClick(btn:UIButton)
    {
        if password == ""{
            self.showAlertWithTitle(title: "Alert", message: "Por favor, ingrese contraseña", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        
        print("CALL API....")
                
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        let param: [String:Any] = ["uuid":uuid, "product_sku":product_sku, "password":password.md5Value, "quantity":quantity, "shipping_address_street":shipping_address_street, "shipping_address_ext_num":shipping_address_ext_num, "shipping_address_int_num":shipping_address_int_num, "shipping_address_place":shipping_address_place, "shipping_address_municipality":shipping_address_municipality, "shipping_address_state":shipping_address_state, "shipping_address_zip_code":shipping_address_zip_code, "shipping_address_references":shipping_address_references, "shipping_address_receiver_name":shipping_address_receiver_name]
        callGetRedemption(param: param)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension EachTokenDetailVC: UITextFieldDelegate
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
            if textField.tag == tfPickerTag{
                // Picker
                if let strV:Int = dict_SelectedPeriod["id"] as? Int
                {
                    shipping_address_state = "\(strV)"
                }
            }
            else{
                // for all address tags
                
                if textField.tag == 200{
                    shipping_address_street = textField.text!
                }
                else if textField.tag == 201{
                    shipping_address_ext_num = textField.text!
                }
                else if textField.tag == 202{
                    shipping_address_int_num = textField.text!
                }
                else if textField.tag == 203{
                    shipping_address_place = textField.text!
                }
                else if textField.tag == 204{
                    shipping_address_municipality = textField.text!
                }
                else if textField.tag == 206{
                    shipping_address_zip_code = textField.text!
                }
                else if textField.tag == 207{
                    shipping_address_references = textField.text!
                }
                else if textField.tag == 208{
                    shipping_address_receiver_name = textField.text!
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

extension EachTokenDetailVC: UIPickerViewDelegate, UIPickerViewDataSource
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

extension EachTokenDetailVC
{
    func callGetRedemption(param: [String:Any])
    {
        self.showSpinnerWith(title: "Cargando...")
        
        WebService.requestService(url: ServiceName.POST_PhysicalProductFinal.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                            if let codeID:String = dict["redemption_id"] as? String
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
    
    func callPickerListApi()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["catalogue_id":"1"]
        WebService.requestService(url: ServiceName.GET_StatesList.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
              // print(jsonString)
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
                        self.arrPicker.removeAll()

                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let valArr:[[String:Any]] = dict["values"] as? [[String:Any]]
                            {
                                self.arrPicker = valArr
                                
                                if valArr.count > 0
                                {
                                    for d in valArr{
                                        if let id:Int = d["id"] as? Int
                                        {
                                            if id == Int(self.shipping_address_state){
                                                self.dict_SelectedPeriod = d
                                            }
                                        }
                                    }
                                    
                                    if let id:Int = self.dict_SelectedPeriod["id"] as? Int
                                    {
                                        self.shipping_address_state = "\(id)"
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.tblView.delegate = self
                            self.tblView.dataSource = self
                            self.tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
