//
//  EachGiftSelectedVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/5/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class EachGiftSelectedVC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!
    
    var picker : UIPickerView!
    var reffTapTF:UITextField!
    var dict_SelectedPeriod:[String:Any] = [:]
    var arrPicker:[[String:Any]] = []

    var dictMain:[String:Any] = [:]
    var denomination = 0
    var quantity = 1
    var cost = 0
    var isContinueEnable = false
    
    let arrData:[String] = ["Header", "Detalles del certificado", "¿De qué denominación deseas adquirir certificados?", "¿Cuántos certificados deseas adquirir?", "Resumen de la Operación a Realizar", "Continue"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblHeader.text = "Certificado de Regalo"
        hideKeyboardWhenTappedAround()
        
        if let arr:[[String:Any]] = dictMain["denominations"] as? [[String:Any]]{
            arrPicker = arr
            if arr.count > 0{
                dict_SelectedPeriod = arr.first!
                if let strV:Int = dict_SelectedPeriod["denomination"] as? Int{
                    denomination = strV
                    
                    if denomination > 0{
                        cost = quantity * denomination
                        print("COST..... ....  ... ", cost)
                    }
                }
            }
        }
        
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

extension EachGiftSelectedVC: UITableViewDataSource, UITableViewDelegate
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
        else if strType == "Detalles del certificado"{
            return UITableView.automaticDimension
        }
        else if strType == "¿De qué denominación deseas adquirir certificados?"{
            return 140
        }
        else if strType == "¿Cuántos certificados deseas adquirir?"{
            return 127
        }
        else if strType == "Resumen de la Operación a Realizar"{
            return 217
        }
        else if strType == "Continue"{
            return 50
        }
        
        return 0
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
        else if strType == "Detalles del certificado"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Detalles del certificado", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.lblTitle.text = ""
            
            if let str:String = dictMain["description"] as? String
            {
                cell.lblTitle.text = str
            }
            return cell
        }
        else if strType == "¿De qué denominación deseas adquirir certificados?"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "¿De qué denominación deseas adquirir certificados?", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            //picker
            cell.tf.text = ""
            cell.tf.tag = 1000
            cell.tf.delegate = self
            cell.inCellAddPaddingTo(TextField: cell.tf, imageName: "down")
            cell.tf.setPlaceHolderColorWith(strPH: "10 puntos")
            
            if let strV:String = dict_SelectedPeriod["denomination_str"] as? String{
                cell.tf.text = strV
            }
            
            cell.tf.layer.cornerRadius = 5.0
            cell.tf.layer.borderColor = UIColor.white.cgColor
            cell.tf.layer.borderWidth = 1.0
            cell.tf.layer.masksToBounds = true
            
            return cell
        }
        else if strType == "¿Cuántos certificados deseas adquirir?"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "¿Cuántos certificados deseas adquirir?", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.tf.delegate = self
            //number
            
            if quantity == 0 {
                cell.tf.text = ""
                cell.tf.placeholder = "0"
            }else{
                cell.tf.text = "\(quantity)"
            }
                        
            cell.inCellAddPaddingTo(TextField: cell.tf, imageName: "")
            cell.tf.layer.cornerRadius = 5.0
            cell.tf.layer.borderColor = UIColor.white.cgColor
            cell.tf.layer.borderWidth = 1.0
            cell.tf.layer.masksToBounds = true

            return cell
        }
        else if strType == "Resumen de la Operación a Realizar"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Resumen de la Operación a Realizar", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.lblTitle.text = ""
            cell.lblSubtitle.text = ""
            cell.lblStatus.text = ""
            
            if let str:String = dictMain["points_balance_str"] as? String
            {
                cell.lblTitle.text = str
            }
            
            cell.lblSubtitle.text = "\(cost)" + " puntos"
            
            if let balance:Int = dictMain["points_balance"] as? Int
            {
                if cost <= balance{
                    cell.lblStatus.text = "Puedes Realizar el Pedido"
                    cell.lblStatus.textColor = UIColor.colorWithHexString("#84EE51")
                    isContinueEnable = true
                  //  tblView.reloadData()
                }
                else{
                    cell.lblStatus.text = "Tu Saldo es Menor al Costo del Pedido"
                    cell.lblStatus.textColor = UIColor.colorWithHexString("#EC2243")
                    isContinueEnable = false
                  //  tblView.reloadData()
                }
            }

            return cell
        }
        else if strType == "Continue"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Continue", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            
            cell.btn.layer.cornerRadius = 18.0
            cell.btn.layer.borderWidth = 1.0
            cell.btn.layer.masksToBounds = true

            cell.btn.addTarget(self, action: #selector(self.btnContinueClick(btn:)), for: .touchUpInside)
            
            if isContinueEnable == true{
                cell.btn.isEnabled = true
                cell.btn.setTitleColor(UIColor(named: "App_Blue")!, for: .normal)
                cell.btn.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
            }
            else{
                cell.btn.isEnabled = false
                cell.btn.setTitleColor(.lightGray, for: .normal)
                cell.btn.layer.borderColor = UIColor.lightGray.cgColor
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func btnContinueClick(btn:UIButton){
        callPOSTEachGift()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension EachGiftSelectedVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1000{
            // Picker
            reffTapTF = textField
            showPickerView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 1000{
            if let strV:Int = dict_SelectedPeriod["denomination"] as? Int{
                denomination = strV
            }
        }
        else{
            quantity = Int(textField.text!) ?? 0
            if denomination > 0{
                cost = quantity * denomination
                print("COST..... ....  ... ", cost)
            }
        }
        print("- - - - - - -  DO CALCULATION  .... .... ")
        
        tblView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tblView.reloadData()
        textField.resignFirstResponder()
        return true
    }    
}

extension EachGiftSelectedVC: UIPickerViewDelegate, UIPickerViewDataSource
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
        
        if let str = dict_SelectedPeriod["denomination_str"] as? String
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
        if let str = dict["denomination_str"] as? String
        {
            strTitle = str
        }
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dict_SelectedPeriod = arrPicker[row]
        
        if let str = dict_SelectedPeriod["denomination_str"] as? String
        {
            reffTapTF.text = str
        }
    }
}

extension EachGiftSelectedVC
{
    func callPOSTEachGift()
    {
        if quantity == 0{
            self.showAlertWithTitle(title: "Error", message: "Debes seleccionar al menos un certificado.", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        var gift_id = ""
        if let id:String = dictMain["gift_id"] as? String
        {
            gift_id = id
        }

        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "gift_id":gift_id, "denomination":denomination, "quantity":quantity]
        WebService.requestService(url: ServiceName.POST_previewBuyGiftPost.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let dictM:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                let vc: EachGiftDetailVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "EachGiftDetailVC_ID") as! EachGiftDetailVC
                                vc.dictMain = dictM
                                vc.gift_id = gift_id
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
