//
//  ProductPreviewVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 24/9/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ProductPreviewVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    var focusManagerTF : FocusManager?
    
    var arrData: [[String:Any]] = []
    var reffTapTF:UnderlineTextField!
    var statePicker : UIPickerView!
    var pickerArr: [[String:Any]] = []
    var dictPickerSelected: [String:Any] = [:]
    var dictMain: [String:Any] = [:]
    
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!
    
    var product = ""
    var price = ""
    var totalCost = ""
    var currentBalance = ""
      var product_sku = ""
      var password = ""
      var quantity = ""
      var shipping_address_street = ""
      var shipping_address_ext_num = ""
      var shipping_address_int_num = ""
      var shipping_address_place = ""
      var shipping_address_municipality = ""
      var shipping_address_state = ""
      var shipping_address_zip_code = ""
      var shipping_address_receiver_name = ""
    var shipping_address_references = ""
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callPickerListApi()
        setUpTopBar()
        lblTitle.text = "Avance"
        self.focusManagerTF = FocusManager()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews()
    {
        if let s:String = dictMain["product_name"] as? String
        {
            product = s
        }
        if let s:String = dictMain["price_str"] as? String
        {
            price = s
        }
        if let s:String = dictMain["cost_str"] as? String
        {
            totalCost = s
        }
        if let s:String = dictMain["current_balance_str"] as? String
        {
            currentBalance = s
        }
        if let s:Int = dictMain["quantity_str"] as? Int
        {
            quantity = "\(s)"
        }
        if let s:String = dictMain["shipping_address_street"] as? String
        {
            shipping_address_street = s
        }
        if let s:String = dictMain["shipping_address_ext_num"] as? String
        {
            shipping_address_ext_num = s
        }
        if let s:String = dictMain["shipping_address_int_num"] as? String
        {
            shipping_address_int_num = s
        }
        if let s:String = dictMain["shipping_address_place"] as? String
        {
            shipping_address_place = s
        }
        if let s:String = dictMain["shipping_address_municipality"] as? String
        {
            shipping_address_municipality = s
        }
        if let s:Int = dictMain["shipping_address_state"] as? Int
        {
            shipping_address_state = "\(s)"
        }
        if let s:String = dictMain["shipping_address_zip_code"] as? String
        {
            shipping_address_zip_code = s
        }
        if let s:String = dictMain["shipping_address_receiver_name"] as? String
        {
            shipping_address_receiver_name = s
        }
        if let s:String = dictMain["shipping_address_references"] as? String
        {
            shipping_address_references = s
        }
        print(dictMain)
        
        // Create table Data
        arrData.append(["yellow": "DETALLES DE TU PEDIDO"])
        arrData.append(["label": "Producto: " + product])
        arrData.append(["label": "Precio Unitario: " + price])
        arrData.append(["label": "Cantidad: " + quantity])
        arrData.append(["label": "Costo Total: " + totalCost])
        arrData.append(["label": "Saldo Actual: " + currentBalance])
        arrData.append(["yellow": "VALIDA TU IDENTIDAD"])
        arrData.append(["textfield": "Contraseña", "title":"Password", "id":101, "secure":true])
        arrData.append(["yellow": "¿DÓNDE DESEAS RECIBIR TU PEDIDO?"])
        arrData.append(["textfield": "Carretera Picacho Ajusco", "title":"Calle", "id":102])
        arrData.append(["textfield": "52", "title":"Número Exterior", "id":103])
        arrData.append(["textfield": "1704", "title":"Número Interior", "id":104])
        arrData.append(["textfield": "Jardines en la Montaña", "title":"Colonia", "id":105])
        arrData.append(["textfield": "Tlalpan", "title":"Alcaldía / Municipio", "id":106])
        arrData.append(["textfield": "01050", "title":"Código postal", "id":107])
        arrData.append(["picker": "Ciudad de México", "title":"Estado de la República"])
        arrData.append(["textfield": "Entre Calles", "title":"Referencias (Entre Calles)", "id":109])
        arrData.append(["textfield": "Alberto Gutiérrez", "title":"Nombre de la persona que recibe", "id":108])
        arrData.append(["button": "Button next"])
        
        if tblView.delegate == nil
        {
            tblView.delegate = self
            tblView.dataSource = self
        }
        tblView.reloadData()
    }
}

extension ProductPreviewVC
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

extension ProductPreviewVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let dict:[String:Any] = arrData[indexPath.row]
        let keys: [String] = Array(dict.keys)
        
        if keys.contains("label")
        {
            if let title:String = dict["label"] as? String
            {
                let width = (tableView.frame.size.width - 20.0)
                let height = title.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.regular, size: 17.0)!)
                return height + 7
            }
            return 0
        }
            else if keys.contains("yellow")
            {
                return 45
            }
        else if keys.contains("textfield")
            {
                return 65
            }
            else if keys.contains("picker")
            {
                return 65
            }
        else if keys.contains("button")
        {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]
        let keys: [String] = Array(dict.keys)
        
        if keys.contains("label")
        {
            let cell:CellConsiderationLabels = tableView.dequeueReusableCell(withIdentifier: "CellConsiderationLabels", for: indexPath) as! CellConsiderationLabels
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            cell.lblTitle.textColor = .black
            
            if let title:String = dict["label"] as? String
            {
                //cell.lblTitle.text = title
                let strBeforeColon:String = title.components(separatedBy: ":").first!
                let range = NSMakeRange(0, strBeforeColon.count)
                cell.lblTitle.attributedText = attributedString(from: title, nonBoldRange: range)

                
                if title.localizedStandardContains("Costo Total")
                {
                    cell.lblTitle.attributedText = attributedStringWithColor(from: title, nonBoldRange: range, color: UIColor.colorWithHexString("#C75568"))
                    // red
                }
                else if title.localizedStandardContains("Saldo Actual")
                {
                    cell.lblTitle.attributedText = attributedStringWithColor(from: title, nonBoldRange: range, color: UIColor.colorWithHexString("#36817A"))
                    // green
                }
            }
            
            return cell
        }
            else if keys.contains("yellow")
            {
                let cell:CellConsiderationLabels = tableView.dequeueReusableCell(withIdentifier: "CellConsiderationLabels", for: indexPath) as! CellConsiderationLabels
                cell.selectionStyle = .none
                cell.lblTitle.text = ""
                cell.lblTitle.textColor = k_baseColor
                
                if let title:String = dict["yellow"] as? String
                {
                    cell.lblTitle.text = title
                }
                
                return cell
            }
        else if keys.contains("textfield")
            {
                let cell:CellExchange_TF = tableView.dequeueReusableCell(withIdentifier: "CellExchange_TF", for: indexPath) as! CellExchange_TF
                cell.selectionStyle = .none
                cell.lblTitle.text = ""
                cell.tf.text = ""
                cell.tf.isSecureTextEntry = false
                cell.tf.delegate = self
                cell.tf.layer.cornerRadius = 5.0
                cell.tf.layer.borderColor = UIColor.lightGray.cgColor
                cell.tf.layer.borderWidth = 1.0
                cell.tf.layer.masksToBounds = true
                cell.inCellAddLeftPaddingTo(TextField: cell.tf)
                
                if let focusManager = self.focusManagerTF {
                    focusManager.addItem(item: cell.tf)
                }
                
                cell.tf.keyboardType = .default
                
                if let title:String = dict["title"] as? String
                {
                    cell.lblTitle.text = title
                }
                if let tag:Int = dict["id"] as? Int
                {
                    cell.tf.tag = tag
                }
                
                    cell.inCellAddRightPaddingTo(TextField: cell.tf, imageName: "")
                    
                    if let ph:String = dict["textfield"] as? String
                    {
                        cell.tf.setPlaceHolderColorWith(strPH: ph)
                    }
                
                if let indexID:Int = dict["id"] as? Int
                {
                    if indexID == 101
                    {
                        // Password
                        cell.tf.isSecureTextEntry = true
                        cell.tf.textContentType = UITextContentType.oneTimeCode // to hide Strong Password by OS
                        cell.tf.text = password
                    }
                    else if indexID == 102
                    {
                        // Street
                        cell.tf.text = shipping_address_street
                    }
                    else if indexID == 103
                    {
                        // Número Exterior
                        cell.tf.text = shipping_address_ext_num
                    }
                    else if indexID == 104
                    {
                        // Número Interior
                        cell.tf.text = shipping_address_int_num
                    }
                    else if indexID == 105
                    {
                        // Colony
                        cell.tf.text = shipping_address_place
                    }
                    else if indexID == 106
                    {
                        // Municipio
                        cell.tf.text = shipping_address_municipality
                    }
                    else if indexID == 107
                    {
                        // Postal
                        cell.tf.text = shipping_address_zip_code
                    }
                    else if indexID == 108
                    {
                        // Name
                        cell.tf.text = shipping_address_receiver_name
                    }
                    else if indexID == 109
                    {
                        // Referencias (Entre Calles)
                        cell.tf.text = shipping_address_references
                    }
                }
                
                return cell
            }
            else if keys.contains("picker")
            {
                // picker
                let cell:CellExchange_TF = tableView.dequeueReusableCell(withIdentifier: "CellExchange_TF", for: indexPath) as! CellExchange_TF
                cell.selectionStyle = .none
                cell.lblTitle.text = ""
                cell.tf.text = ""
                if let focusManager = self.focusManagerTF {
                    focusManager.addItem(item: cell.tf)
                }
                
                cell.tf.delegate = self
                cell.tf.keyboardType = .default
                cell.tf.isSecureTextEntry = false
                cell.tf.layer.cornerRadius = 5.0
                cell.tf.layer.borderColor = UIColor.lightGray.cgColor
                cell.tf.layer.borderWidth = 1.0
                cell.tf.layer.masksToBounds = true
                cell.inCellAddLeftPaddingTo(TextField: cell.tf)

                if let title:String = dict["title"] as? String
                {
                    cell.lblTitle.text = title
                }
                
                cell.tf.tag = 1002
                cell.inCellAddRightPaddingTo(TextField: cell.tf, imageName: "down")
                
                if let ph:String = dict["picker"] as? String
                {
                    cell.tf.setPlaceHolderColorWith(strPH: ph)
                }
                if let str = dictPickerSelected["value"] as? String
                {
                    cell.tf.text = str
                }

        }
        else if keys.contains("button")
        {
            // Next Button
            let cell:CellExchange_NextBtn = tblView.dequeueReusableCell(withIdentifier: "CellExchange_NextBtn", for: indexPath) as! CellExchange_NextBtn
            cell.selectionStyle = .none
            cell.lblRed.text = ""
            cell.lblRed.isHidden = true
            
            cell.btnNext.layer.cornerRadius = 5.0
            cell.btnNext.layer.masksToBounds = true
            cell.btnNext.addTarget(self, action: #selector(self.btnNextClick(btn:)), for: .touchUpInside)
            return cell

        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    @objc func btnNextClick(btn:UIButton)
    {
        if shipping_address_state == "" || password == "" || shipping_address_street == "" || shipping_address_ext_num == "" || shipping_address_int_num == "" || shipping_address_place == "" || shipping_address_municipality == "" || shipping_address_zip_code == "" || shipping_address_references == ""
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {            
            var uuid = ""
            if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
            {
                uuid = id
            }
            
            let dic:[String:Any] = [
              "product_sku": product_sku,
              "uuid": uuid,
              "password": password.md5Value,
              "quantity": quantity,
              "shipping_address_street": shipping_address_street,
              "shipping_address_ext_num": shipping_address_ext_num,
              "shipping_address_int_num": shipping_address_int_num,
              "shipping_address_place": shipping_address_place,
              "shipping_address_municipality": shipping_address_municipality,
              "shipping_address_state": shipping_address_state,
              "shipping_address_zip_code": shipping_address_zip_code,
              "shipping_address_receiver_name": shipping_address_receiver_name,
              "shipping_address_references":shipping_address_references
            ]
            
            callFinalApi(dict: dic)
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

extension ProductPreviewVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            focusManagerTF!.focusTouch(item: textField)
        }
        
        if textField.tag == 1002
        {
            reffTapTF = textField as? UnderlineTextField
            showPickerView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            let control = textField as! UnderlineTextField
            control.updateFocus(isFocus: false)
        }
        
        if textField.tag == 101
        {
            // Password
            password = textField.text!
        }
        else if textField.tag == 102
        {
            // Street
            shipping_address_street = textField.text!
        }
        else if textField.tag == 103
        {
            // Número Exterior
            shipping_address_ext_num = textField.text!
        }
        else if textField.tag == 104
        {
            // Número Interior
            shipping_address_int_num = textField.text!
        }
        else if textField.tag == 105
        {
            // Colony
            shipping_address_place = textField.text!
        }
        else if textField.tag == 106
        {
            // Municipio
            shipping_address_municipality = textField.text!
        }
        else if textField.tag == 107
        {
            // Postal
            shipping_address_zip_code = textField.text!
        }
        else if textField.tag == 108
        {
            // Name
            shipping_address_receiver_name = textField.text!
        }
        else if textField.tag == 109
        {
            // Referencias (Entre Calles)
            shipping_address_references = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension ProductPreviewVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        
        if pickerArr.count == 0
        {
            self.showAlertWithTitle(title: "AT&T", message: "No hay denominaciones", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            self.view.endEditing(true)
            return
        }
        
        self.statePicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.statePicker.delegate = self
        self.statePicker.dataSource = self
        self.statePicker.backgroundColor = UIColor.white
        reffTapTF.inputView = self.statePicker
        
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
        statePicker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
        self.perform(#selector(self.reloadAfterSometime), with: nil, afterDelay: 0.5)
    }
    
    @objc func reloadAfterSometime()
    {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
    @objc func cancelPickerClick() {
        statePicker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var strTitle:String = ""
        let dict:[String:Any] = pickerArr[row]
        if let str = dict["value"] as? String
        {
            strTitle = str
        }
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dict:[String:Any] = pickerArr[row]
        if let str = dict["value"] as? String
        {
            reffTapTF.text = str
            dictPickerSelected = dict
        }        
    }
}

extension ProductPreviewVC
{
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
                        self.pickerArr.removeAll()

                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let valArr:[[String:Any]] = dict["values"] as? [[String:Any]]
                            {
                                self.pickerArr = valArr
                                
                                if valArr.count > 0
                                {
                                    let d:[String:Any] = valArr.first!
                                    self.dictPickerSelected = d

                                    if let s:Int = self.dictMain["shipping_address_state"] as? Int
                                    {
                                        for du in valArr
                                        {
                                            if let id:Int = du["id"] as? Int
                                            {
                                                if id == s
                                                {
                                                    self.dictPickerSelected = du
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.setupViews()
                        }
                    }
                }
            }
        }
    }
    
    
    func callFinalApi(dict:[String:Any])
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = dict
        WebService.requestService(url: ServiceName.POST_PhysicalProductFinal.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let dif:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                if let msg:String = json["message"] as? String
                                {
                                    self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.finish))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func finish()
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_PhysicalProductList"), object: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
