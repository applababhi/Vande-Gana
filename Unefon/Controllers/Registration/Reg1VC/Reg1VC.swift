//
//  Reg1VC.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class Reg1VC: UIViewController {

    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!
    
    var focusManagerTF : FocusManager?
    var reffTapTF:UnderlineTextField!
    var statePicker : UIPickerView!
    
    var arrRows: [[String:Any]] = [["type": "header", "title":"", "ph":"", "height":0],
                                   ["type": "tf Disable Picker", "title":"PLAN DE INCENTIVOS", "ph":"", "height":80],
                                    ["type": "tf", "title":"NOMBRE(S)", "ph":"Nombre(s) : Ej.juan", "height":80],
                                    ["type": "tf", "title":"APELLIDO PATERNO", "ph":"Apellido Paterno : Ej López", "height":80],
                                    ["type": "tf", "title":"APELLIDO MATERNO", "ph":"Apellido Materno : Ej Pérez", "height":80],
                                    ["type": "tf Disable Picker", "title":"DISTRIBUIDOR", "ph":"", "height":80],
                                    ["type": "tf Numeric", "title":"NÚMERO DEUDOR", "ph":"Ej 234112", "height":80],
                                    ["type": "tf Secure", "title":"PASSWORD", "ph":"", "height":80],
                                    ["type": "tf Secure", "title":"CONFIRMAR PASSWORD", "ph":"", "height":80],
                                    ["type": "radio", "title":"GÉNERO", "ph":"", "height":80],
                                    ["type": "tf Enable Picker", "title":"ESTADO DE RESIDENCIA", "ph":"", "height":80],
                                    ["type": "btnnext", "title":"SIGUIENTE", "ph":"", "height":60]
    ]
    var dictPlans: [String:Any] = [:]
    var dictDistribuidor: [String:Any] = [:]
    var strFirstName: String = ""
    var strLastName: String = ""
    var strMotherName: String = ""
    var strNumber: String = ""
    var strPassword: String = ""
    var strConfirmPassword: String = ""
    var strGender: String = ""
    var strState: String = ""
    var statePickerArr: [[String:Any]] = []
    let k_lblRadiusHeader:CGFloat = 20.0
    let k_disablePlansTF = 1001
    let k_disableDistribudorTF = 1002
    let k_statePickerTF = 1003
    var dictStateSelected: [String:Any] = [:]

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        vBk.layer.cornerRadius = 5.0
        vBk.layer.masksToBounds = true
        setUpTopBar()
        lblHeader.text = "Información personal"

        setUpData()
        self.focusManagerTF = FocusManager()
        tblView.delegate = self
        tblView.dataSource = self
        hideKeyboardWhenTappedAround()
    }
    
    func setUpData()
    {
        if let compID:String = k_helper.tempRegisterDict["companyID"] as? String
        {
            strNumber = compID
        }
        if let dict:[String:Any] = k_helper.tempRegisterDict["activePlan"] as? [String:Any]
        {
            dictPlans = dict
        }
        callWorkplacesListApi()
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
        self.dismiss(animated: true, completion: nil)
    }
}

extension Reg1VC
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

extension Reg1VC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrRows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let d:[String:Any] = arrRows[indexPath.row] as! [String:Any]
        
        if let height: Int = d["height"] as? Int
        {
            return CGFloat(height)
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let d:[String:Any] = arrRows[indexPath.row] as! [String:Any]
        var strType:String = ""
        if let typ: String = d["type"] as? String
        {
            strType = typ
        }
        
        if strType.localizedStandardContains("header") == true
        {
            // Header
            let cell:Cell_Reg1_Header = tblView.dequeueReusableCell(withIdentifier: "Cell_Reg1_Header", for: indexPath) as! Cell_Reg1_Header
            cell.selectionStyle = .none
            
            cell.lbl1.layer.cornerRadius = k_lblRadiusHeader
            cell.lbl1.layer.borderColor = k_baseColor.cgColor
            cell.lbl1.layer.borderWidth = 2.0
            cell.lbl1.layer.masksToBounds = true
            
            cell.lbl2.layer.cornerRadius = k_lblRadiusHeader
            cell.lbl2.layer.borderWidth = 2.0
            cell.lbl2.layer.masksToBounds = true
            
            cell.lbl3.layer.cornerRadius = k_lblRadiusHeader
            cell.lbl3.layer.borderWidth = 2.0
            cell.lbl3.layer.masksToBounds = true

            cell.lbl4.layer.cornerRadius = k_lblRadiusHeader
            cell.lbl4.layer.borderWidth = 2.0
            cell.lbl4.layer.masksToBounds = true

            cell.lbl5.layer.cornerRadius = k_lblRadiusHeader
            cell.lbl5.layer.borderWidth = 2.0
            cell.lbl5.layer.masksToBounds = true
            return cell
        }
        else if strType.localizedStandardContains("radio") == true
        {
            // Gender
            let cell:Cell_Reg1_Radio = tblView.dequeueReusableCell(withIdentifier: "Cell_Reg1_Radio", for: indexPath) as! Cell_Reg1_Radio
            cell.selectionStyle = .none
            cell.imgMale.image = UIImage(named: "radioUnsel")
            cell.imgFemale.image = UIImage(named: "radioUnsel")
            
            if strGender == "Masculino"
            {
                cell.imgMale.image = UIImage(named: "radioSel")
            }
            else if strGender == "Femenino"
            {
                cell.imgFemale.image = UIImage(named: "radioSel")
            }
            
            cell.btnMale.addTarget(self, action: #selector(self.btnMaleClick(btn:)), for: .touchUpInside)
            cell.btnFemale.addTarget(self, action: #selector(self.btnFemaleClick(btn:)), for: .touchUpInside)
            return cell
        }
        else if strType.localizedStandardContains("btnnext") == true
        {
            // Next Button
            let cell:Cell_Reg1_BtnNext = tblView.dequeueReusableCell(withIdentifier: "Cell_Reg1_BtnNext", for: indexPath) as! Cell_Reg1_BtnNext
            cell.selectionStyle = .none
            cell.btnNext.backgroundColor = .clear
            cell.btnNext.setTitleColor(UIColor(named: "App_Blue")!, for: .normal)
            
            cell.btnNext.layer.cornerRadius = 25.0
            cell.btnNext.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
            cell.btnNext.layer.borderWidth = 1.0
            cell.btnNext.layer.masksToBounds = true
            cell.btnNext.addTarget(self, action: #selector(self.btnNextClick(btn:)), for: .touchUpInside)
            return cell
        }
        else if strType.localizedStandardContains("Disable") == true
        {
            // Disable Picker
            let cell:Cell_Reg1_TF = tblView.dequeueReusableCell(withIdentifier: "Cell_Reg1_TF", for: indexPath) as! Cell_Reg1_TF
            cell.selectionStyle = .none
            
            if let focusManager = self.focusManagerTF {
                focusManager.addItem(item: cell.tf)
            }
            
            cell.tf.delegate = self
            cell.tf.isUserInteractionEnabled = false
            cell.tf.textColor = UIColor.lightGray
            cell.tf.isSecureTextEntry = false
            
            cell.tf.dullBorder()
            
            cell.inCellAddRightPaddingTo(TextField: cell.tf, imageName: "down")
            
            if let title: String = d["title"] as? String
            {
                cell.lbl.text = title
            }
            
            if cell.lbl.text?.localizedStandardContains("PLAN") == true
            {
                cell.tf.tag = k_disablePlansTF

                if let val: String = dictPlans["plan_name"] as? String
                {
                    cell.tf.text = val
                }
            }
            else
            {
                cell.tf.tag = k_disableDistribudorTF

                if let val: String = dictDistribuidor["workplace_name"] as? String
                {
                    cell.tf.text = val
                }
            }
            
            return cell
        }
        else if strType.localizedStandardContains("Enable") == true
        {
            // state Picker
            let cell:Cell_Reg1_TF = tblView.dequeueReusableCell(withIdentifier: "Cell_Reg1_TF", for: indexPath) as! Cell_Reg1_TF
            cell.selectionStyle = .none
            
            if let focusManager = self.focusManagerTF {
                focusManager.addItem(item: cell.tf)
            }
            cell.tf.delegate = self
            cell.tf.isUserInteractionEnabled = true
            cell.tf.textColor = UIColor.white
            cell.tf.tag = k_statePickerTF
            cell.tf.isSecureTextEntry = false
            
            cell.tf.createBorder()
            
            cell.inCellAddRightPaddingTo(TextField: cell.tf, imageName: "down")
            
            if let title: String = d["title"] as? String
            {
                cell.lbl.text = title
            }
            cell.tf.text = strState

            return cell
        }
        else
        {
            // Normal Textfields
            let cell:Cell_Reg1_TF = tblView.dequeueReusableCell(withIdentifier: "Cell_Reg1_TF", for: indexPath) as! Cell_Reg1_TF
            cell.selectionStyle = .none
            
            if let focusManager = self.focusManagerTF {
                focusManager.addItem(item: cell.tf)
            }

            cell.tf.tag = indexPath.row
            cell.tf.keyboardType = .default
            cell.tf.delegate = self
            cell.tf.isUserInteractionEnabled = true
            cell.tf.textColor = UIColor.white
            cell.tf.isSecureTextEntry = false
            cell.inCellAddRightPaddingTo(TextField: cell.tf, imageName: "")
            
            cell.tf.createBorder()
            
            if let title: String = d["title"] as? String
            {
                cell.lbl.text = title
            }
            if let ph: String = d["ph"] as? String
            {
                cell.tf.setPlaceHolderColorWith(strPH: ph)
            }
            
            if cell.lbl.text?.localizedStandardContains("NOMBRE") == true
            {
                cell.tf.text = strFirstName 
            }
            else if cell.lbl.text?.localizedStandardContains("PATERNO") == true
            {
                cell.tf.text = strLastName
            }
            else if cell.lbl.text?.localizedStandardContains("MATERNO") == true
            {
                cell.tf.text = strMotherName
            }
            else if cell.lbl.text?.localizedStandardContains("DEUDOR") == true
            {
                cell.tf.textColor = UIColor.lightGray
                cell.tf.keyboardType = .numberPad
                cell.tf.text = strNumber
                cell.tf.isUserInteractionEnabled = false
            }
            else if cell.lbl.text?.localizedStandardContains("CONFIRMAR") == true
            {
                cell.tf.isSecureTextEntry = true
                cell.tf.textContentType = UITextContentType.oneTimeCode // to hide Strong Password by OS

                cell.tf.text = strConfirmPassword
            }
            else if cell.lbl.text?.localizedStandardContains("PASSWORD") == true
            {
                cell.tf.isSecureTextEntry = true
                cell.tf.textContentType = UITextContentType.oneTimeCode // to hide Strong Password by OS
                cell.tf.text = strPassword
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension Reg1VC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.inputView = nil
        textField.inputAccessoryView = nil
        
        if textField is UnderlineTextField {
            focusManagerTF!.focusTouch(item: textField)
        }
        
        if textField.tag == k_statePickerTF
        {
            reffTapTF = textField as! UnderlineTextField
            showPickerView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            let control = textField as! UnderlineTextField
            control.updateFocus(isFocus: false)
        }
        
        if textField.tag == 2
        {
            strFirstName = textField.text!
        }
        else if textField.tag == 3
        {
            strLastName = textField.text!
        }
        else if textField.tag == 4
        {
            strMotherName = textField.text!
        }
        else if textField.tag == 6
        {
            strNumber = textField.text!
        }
        else if textField.tag == 8
        {
            strConfirmPassword = textField.text!
        }
        else if textField.tag == 7
        {
            strPassword = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tblView.reloadData()
        textField.resignFirstResponder()
        return true
    }
}

extension Reg1VC
{
    // MARK: Actions
    
    @objc func btnMaleClick(btn:UIButton)
    {
        strGender = "Masculino"
        tblView.reloadData()
    }
    
    @objc func btnFemaleClick(btn:UIButton)
    {
        strGender = "Femenino"
        tblView.reloadData()
    }
    
    @objc func btnNextClick(btn:UIButton)
    {
        if validateTF() == true
        {
            if let idStep2:Int = k_helper.tempRegisterDict["showStep2"] as? Int
            {
                if idStep2 == 1
                {
                    // take to Step 2 profile Image upload
                    let vc: Reg2VC = AppStoryBoards.Register.instance.instantiateViewController(withIdentifier: "Reg2VC_ID") as! Reg2VC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                else
                {
                    if let idStep3:Int = k_helper.tempRegisterDict["showStep3"] as? Int
                    {
                        if idStep3 == 1
                        {
                            // take to Step 3 Badge Image upload
                            let vc: Reg3VC = AppStoryBoards.Register.instance.instantiateViewController(withIdentifier: "Reg3VC_ID") as! Reg3VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        else
                        {
                            // Take to Step 4 Directly
                            let vc: Reg4VC = AppStoryBoards.Register.instance.instantiateViewController(withIdentifier: "Reg4VC_ID") as! Reg4VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func validateTF() -> Bool
    {
        if strFirstName.isEmpty == true || strLastName.isEmpty == true || strMotherName.isEmpty == true || strConfirmPassword.isEmpty == true || strGender.isEmpty == true
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return false
        }
        else if strPassword != strConfirmPassword
        {
            self.showAlertWithTitle(title: "Validación", message: "Contraseña y confirmar contraseña no coinciden", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return false
        }
        else
        {
            k_helper.tempRegisterDict["first_name"] = strFirstName
            k_helper.tempRegisterDict["last_name_1"] = strLastName
            k_helper.tempRegisterDict["last_name_2"] = strMotherName
            
            if strGender == "Masculino"
            {
                k_helper.tempRegisterDict["gender_id"] = "1"
            }
            else
            {
                k_helper.tempRegisterDict["gender_id"] = "2"
            }
            
            k_helper.tempRegisterDict["password"] = strConfirmPassword.md5Value
            return true
        }
        
    }
}

extension Reg1VC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
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
        tblView.reloadData()
    }
    @objc func cancelPickerClick() {
        statePicker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statePickerArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var strTitle:String = ""
        let dict:[String:Any] = statePickerArr[row]
        if let str = dict["value"] as? String
        {
            strTitle = str
        }
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dict:[String:Any] = statePickerArr[row]
        if let str = dict["value"] as? String
        {
            reffTapTF.text = str
            strState = str
            dictStateSelected = dict
            if let stId:Int = self.dictStateSelected["id"] as? Int
            {
                k_helper.tempRegisterDict["state_id"] = stId
            }
        }
    }
}

//MARK: API CALLS
extension Reg1VC
{
    func callWorkplacesListApi()
    {
        var plan_id = ""
        if let id:String = k_helper.tempRegisterDict["plan_id"] as? String
        {
            plan_id = id
        }
        if plan_id == ""
        {
            return
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        WebService.requestService(url: ServiceName.GET_WorkplacesList.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
        //    print(jsonString)
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
                        
                        if let arrresp:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            var workID = ""
                            if let id:String = k_helper.tempRegisterDict["workplace_id"] as? String
                            {
                                workID = id
                            }
                            
                            
                            for d in arrresp
                            {
                                if let strWID:String = d["workplace_id"] as? String
                                {
                                    if strWID == workID
                                    {
                                        self.dictDistribuidor = d
                                        break
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.perform(#selector(self.callStatesListApi), with: nil, afterDelay: 0.1)
                            self.tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc func callStatesListApi()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["catalogue_id":"1"]
        WebService.requestService(url: ServiceName.GET_StatesList.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
    //            print(jsonString)
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
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            var stateID = 0
                            if let id:Int = k_helper.tempRegisterDict["state_id"] as? Int
                            {
                                stateID = id
                            }
                            
                            if let valArr:[[String:Any]] = dict["values"] as? [[String:Any]]
                            {
                                self.statePickerArr = valArr
                                for d in valArr
                                {
                                    if let idSate:Int = d["id"] as? Int
                                    {
                                        if idSate == stateID
                                        {
                                            if let name:String = d["value"] as? String
                                            {
                                                self.strState = name
                                            }
                                            self.dictStateSelected = d
                                        }
                                    }
                                }
                            }
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
