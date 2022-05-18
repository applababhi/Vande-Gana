//
//  ProfileVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 6/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!

    @IBOutlet weak var tblView:UITableView!
    var focusManagerTF : FocusManager?
    var reffTapTF:UnderlineTextField!
    var statePicker : UIPickerView!
//    @IBOutlet weak var lblTitle:UILabel!
 //   @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrRows: [[String:Any]] = [["type": "tf", "title":"NOMBRE(S)", "ph":"Nombre(s) : Ej.juan", "height":80],
                                   ["type": "tf", "title":"APELLIDO PATERNO", "ph":"Apellido Paterno : Ej López", "height":80],
                                   ["type": "tf", "title":"APELLIDO MATERNO", "ph":"Apellido Materno : Ej Pérez", "height":80],
                                   ["type": "tf", "title":"LUGAR DE TRABAJO", "ph":"", "height":80],
                                   ["type": "radio", "title":"GÉNERO", "ph":"", "height":80],
                                   ["type": "tf Enable Picker", "title":"ESTADO DE RESIDENCIA", "ph":"", "height":80],
                                   ["type": "btnnext", "title":"Actualizar", "ph":"", "height":60]
    ]
    var strFirstName: String = ""
    var strLastName: String = ""
    var strMotherName: String = ""
    var strWorkplace: String = ""
    var strGender: String = ""
    var strState: String = ""
    var PickerArr: [[String:Any]] = []
    var statePickerArr: [[String:Any]] = []
    let workplacePickerArr: [[String:Any]] = [["title":"x", "id":1], ["title":"y", "id":2], ["title":"z", "id":3]]
    let k_workplaceTF = 1002
    let k_statePickerTF = 1003
    var dictStateSelected: [String:Any] = [:]
    var dictWorkplaceSelected: [String:Any] = [:]
    var workplaceId = ""
    var stateId = 0
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vBk.layer.cornerRadius = 5.0
        vBk.layer.masksToBounds = true
        setUpTopBar()
        lblHeader.text = "Cambiar Información Personal"

        setUpTopBar()

        callGetMyProfileApi()
      //  lblTitle.text = "Mi perfil"
        self.focusManagerTF = FocusManager()
        hideKeyboardWhenTappedAround()
    }
    
    @objc func back()
    {
      //  NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
//    
//    func setUpTopBar()
//    {
//        let strModel = getDeviceModel()
//        if strModel == "iPhone XS"
//        {
//            c_TopBar_Ht.constant = 90
//        }
//        else if strModel == "iPhone Max"
//        {
//            c_TopBar_Ht.constant = 90
//        }
//        else if strModel == "iPhone 5"
//        {
//            
//        }
//        else{
//            c_TopBar_Ht.constant = 110
//        }
//    }
    
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

extension ProfileVC
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

extension ProfileVC: UITableViewDataSource, UITableViewDelegate
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
        
        
        if strType.localizedStandardContains("radio") == true
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
            
            cell.btnNext.layer.cornerRadius = 5.0
            cell.btnNext.layer.masksToBounds = true
            cell.btnNext.addTarget(self, action: #selector(self.btnNextClick(btn:)), for: .touchUpInside)
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
            cell.tf.isSecureTextEntry = false
            
            cell.inCellAddRightPaddingTo(TextField: cell.tf, imageName: "down")
            
            if let title: String = d["title"] as? String
            {
                cell.lbl.text = title
            }
            
            if cell.lbl.text?.localizedStandardContains("ESTADO DE RESIDENCIA") == true
            {
                cell.tf.tag = k_statePickerTF
                if strState != ""
                {
                    cell.tf.text = strState
                }
            }
            else
            {
                // Workplace
                cell.tf.tag = k_workplaceTF
                if strWorkplace != ""
                {
                    cell.tf.text = ""
                }
            }
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
            else if cell.lbl.text?.localizedStandardContains("TRABAJO") == true
            {
                cell.tf.isUserInteractionEnabled = false
                cell.tf.textColor = UIColor.lightGray
                cell.tf.text = strWorkplace
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            focusManagerTF!.focusTouch(item: textField)
        }
        
        if textField.tag == k_statePickerTF
        {
            PickerArr = statePickerArr
            reffTapTF = textField as! UnderlineTextField
            showPickerView()
        }
        else if textField.tag == k_workplaceTF
        {
            PickerArr = workplacePickerArr
            reffTapTF = textField as! UnderlineTextField
            showPickerView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            let control = textField as! UnderlineTextField
            control.updateFocus(isFocus: false)
        }
        
        if textField.tag == 0
        {
            strFirstName = textField.text!
        }
        else if textField.tag == 1
        {
            strLastName = textField.text!
        }
        else if textField.tag == 2
        {
            strMotherName = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tblView.reloadData()
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileVC
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
        print("Update Click")

        if strFirstName.isEmpty == true || strLastName.isEmpty == true || strMotherName.isEmpty == true || strGender.isEmpty == true || workplaceId.isEmpty == true
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
            
            let param:[String:Any] = [
                "uuid": uuid,
                "first_name": strFirstName,
                "last_name_1": strLastName,
                "last_name_2": strMotherName,
                "gender_id": (self.strGender == "Masculino") ? 1 : 2,
                "workplace_id": workplaceId,
                "residence_state_id": stateId,
            ]
            
            // call API
            self.callUpdateProfile(dict: param)
        }

    }
}

extension ProfileVC: UIPickerViewDelegate, UIPickerViewDataSource
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
        return PickerArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var strTitle:String = ""
        let dict:[String:Any] = PickerArr[row]
        if let str = dict["value"] as? String
        {
            strTitle = str
        }
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dict:[String:Any] = PickerArr[row]
        
        if reffTapTF.tag == k_statePickerTF
        {
            if let str = dict["value"] as? String
            {
                reffTapTF.text = str
                strState = str
                dictStateSelected = dict
                if let stId:Int = self.dictStateSelected["id"] as? Int
                {
                    stateId = stId
                }
            }
        }
        else
        {
            // workplace
            if let str = dict["title"] as? String
            {
                reffTapTF.text = str
                strWorkplace = str
                dictWorkplaceSelected = dict
            }
        }
        
    }
}

//MARK: API CALLS
extension ProfileVC
{
    func callGetMyProfileApi()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_MyProfile.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let wId: String = dict["workplace_id"] as? String
                            {
                                self.workplaceId = wId
                            }
                            if let sId: String = dict["residence_state_id"] as? String
                            {
                                self.stateId = Int(sId)!
                            }
                            if let nam: String = dict["first_name"] as? String
                            {
                                self.strFirstName = nam
                            }
                            if let nam: String = dict["last_name_1"] as? String
                            {
                                self.strLastName = nam
                            }
                            if let nam: String = dict["last_name_2"] as? String
                            {
                                self.strMotherName = nam
                            }
                            
                            if let gender: Int = dict["gender_id"] as? Int
                            {
                                if gender == 1
                                {
                                    self.strGender = "Masculino"
                                }
                                else
                                {
                                    // else 2
                                    self.strGender = "Femenino"
                                }
                            }
                            else
                            {
                                self.strGender = "Masculino"
                            }

                            DispatchQueue.main.async {
                                self.perform(#selector(self.callWorkplacesListApi), with: nil, afterDelay: 0.1)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func callWorkplacesListApi()
    {
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
        let param: [String:Any] = ["plan_id":plan_id]
        WebService.requestService(url: ServiceName.GET_WorkplacesList.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
          //      print(jsonString)
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
                            for d in arrresp
                            {
                                if let strWID:String = d["workplace_id"] as? String
                                {
                                    if strWID == self.workplaceId
                                    {
//                                      print(d)
                                        
                                        if let wName:String = d["workplace_id"] as? String
                                        {
                                            self.strWorkplace = wName
                                        }
                                        break
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.perform(#selector(self.callStatesListApi), with: nil, afterDelay: 0.1)
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
                     //   print(jsonString)
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
                            if let valArr:[[String:Any]] = dict["values"] as? [[String:Any]]
                            {
                                self.statePickerArr = valArr
                                for d in valArr
                                {
                                    if let idSate:Int = d["id"] as? Int
                                    {
                                        if idSate == self.stateId
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
    
    func callUpdateProfile(dict:[String:Any])
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = dict
        WebService.requestService(url: ServiceName.POST_UpdateMyProfile.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.back))
                        }
                    }
                }
            }
        }
    }
}
