//
//  RegisterVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
//    var focusManagerTF : FocusManager?
    @IBOutlet weak var vBK: UIView!
    @IBOutlet weak var tfPlans: UITextField!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var btnReturn:UIButton!
    @IBOutlet weak var btnNext:UIButton!
    var planPicker : UIPickerView!
    var reffTapTF:UITextField!

    /*
    @IBOutlet weak var c_Register_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_Login_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_Register_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_Login_Ht:NSLayoutConstraint!

    @IBOutlet weak var c_RegBt_Ld_iPad:NSLayoutConstraint!
    @IBOutlet weak var c_LogBt_Tr_iPad:NSLayoutConstraint!
    */

    let kPlanPickerTag = 1001
    var plansArr:[[String:Any]] = []
    var dictPlanSelected: [String:Any] = [:]

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vBK.layer.cornerRadius = 10.0
        setupTFFocus()
        setUpTopBar()
        
        if isPad == true
        {
           // c_RegBt_Ld_iPad.constant = 190
           // c_LogBt_Tr_iPad.constant = 190
        }
        
        k_helper.tempRegisterDict.removeAll()
        callApiGetPlans()
    }
    
    private func setupTFFocus()
    {
        addLeftPaddingTo(TextField: tfPlans)
        addLeftPaddingTo(TextField: tfNumber)
       
        tfPlans.layer.borderColor = UIColor(named: "App_LightGrey")?.cgColor
        tfPlans.layer.borderWidth = 1.0
        tfPlans.layer.cornerRadius = 3.0
        tfPlans.layer.masksToBounds = true
      
        tfNumber.layer.borderColor = UIColor(named: "App_LightGrey")?.cgColor
        tfNumber.layer.borderWidth = 1.0
        tfNumber.layer.cornerRadius = 3.0
        tfNumber.layer.masksToBounds = true
        
        tfNumber.keyboardType = .phonePad

        tfPlans.delegate = self
        tfNumber.delegate = self
        tfPlans.tag = kPlanPickerTag
        tfPlans.setPlaceHolderColorWith(strPH: "")
        tfNumber.setPlaceHolderColorWith(strPH: "Indica el ID con el que te identificas")
        addRightPaddingTo(TextField: tfPlans, imageName: "down")
        hideKeyboardWhenTappedAround()
        
        btnNext.layer.borderColor = UIColor(named: "App_Blue")?.cgColor 
        btnNext.layer.borderWidth = 1.0
        btnNext.layer.cornerRadius = 20.0
        btnNext.layer.masksToBounds = true
        
        btnReturn.layer.cornerRadius = 20.0
        btnReturn.layer.masksToBounds = true
    }
    
    func setUpTopBar()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
        }
        else if strModel == "iPhone Max"
        {
        }
        else if strModel == "iPhone 5"
        {
//            c_Register_Wd.constant = 120
//            c_Login_Wd.constant = 125
//            c_Register_Ht.constant = 40
//            c_Login_Ht.constant = 40
        }
    }
    
    @IBAction func returnClicked(btn:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextClicked(btn:UIButton)
    {
        self.view.endEditing(true)
        if validateTF() == true
        {
            callApiValidatePreRegister()
        }
    }
}

extension RegisterVC
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

extension RegisterVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        reffTapTF = textField
        
        if textField is UnderlineTextField {
            
        }
        
        if reffTapTF.tag == kPlanPickerTag
        {
            showPickerView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
                
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func validateTF() -> Bool
    {
        if tfPlans.text!.isEmpty == true || tfNumber.text!.isEmpty == true
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return false
        }
        else
        {
            return true
        }
    }
}

extension RegisterVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        self.planPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.planPicker.delegate = self
        self.planPicker.dataSource = self
        self.planPicker.backgroundColor = UIColor.white
        reffTapTF.inputView = self.planPicker
        
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
        planPicker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
    }
    @objc func cancelPickerClick() {
        planPicker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return plansArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var strTitle:String = ""
        let dict:[String:Any] = plansArr[row]
        if let str = dict["plan_name"] as? String
        {
            strTitle = str
        }
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dict:[String:Any] = plansArr[row]
        if let str = dict["plan_name"] as? String
        {
            reffTapTF.text = str
            dictPlanSelected = dict
        }
    }
}

//MARK: API CALLS
extension RegisterVC
{
    func callApiGetPlans()
    {
        self.showSpinnerWith(title: "Cargando...")
        WebService.requestService(url: ServiceName.GET_ActivePlans.rawValue, method: .get, parameters: [:], headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let arrPick:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.plansArr = arrPick
                            
                            if self.plansArr.count > 0
                            {
                                let dict:[String:Any] = self.plansArr.first!
                                if let str = dict["plan_name"] as? String
                                {
                                    self.tfPlans.text = str
                                    self.dictPlanSelected = dict
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callApiValidatePreRegister()
    {
        var plan_id = ""
        if let id:String = self.dictPlanSelected["plan_id"] as? String
        {
            plan_id = id
        }
        if plan_id == ""
        {
            return
        }
        
        k_helper.tempRegisterDict["activePlan"] = self.dictPlanSelected
        k_helper.tempRegisterDict["companyID"] = tfNumber.text!
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id, "company_id": tfNumber.text!]
        WebService.requestService(url: ServiceName.GET_UserPreRegistration.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
         //          print(jsonString)
            
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
                            if let isPreReg:Bool = dictResp["is_pre_registered"] as? Bool
                            {
                                if isPreReg == true
                                {
                                    if let isReg:Bool = dictResp["is_registered"] as? Bool
                                    {
                                        if isReg == true
                                        {
                                            // Skip
                                            self.showAlertWithTitle(title: "Error", message: "El usuario ya está registrado", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                            return
                                        }
                                    }
                                    
                                    if let planId:String = dictResp["plan_id"] as? String
                                    {
                                        k_helper.tempRegisterDict["plan_id"] = planId
                                    }
                                    if let uuid:String = dictResp["uuid"] as? String
                                    {
                                        k_helper.tempRegisterDict["uuid"] = uuid
                                    }
                                    if let campId:String = dictResp["campaign_id"] as? String
                                    {
                                        k_helper.tempRegisterDict["campaign_id"] = campId
                                    }
                                    if let campId:String = dictResp["company_id"] as? String
                                    {
                                        k_helper.tempRegisterDict["company_id"] = campId
                                    }
                                    if let wpId:String = dictResp["workplace_id"] as? String
                                    {
                                        k_helper.tempRegisterDict["workplace_id"] = wpId
                                    }
                                    if let stId:Int = dictResp["state_id"] as? Int
                                    {
                                        k_helper.tempRegisterDict["state_id"] = stId
                                    }
                                    if let showStep2:Int = dictResp["require_profile_picture"] as? Int
                                    {
                                        k_helper.tempRegisterDict["showStep2"] = showStep2
                                    }
                                    if let showStep3:Int = dictResp["require_badge_picture"] as? Int
                                    {
                                        k_helper.tempRegisterDict["showStep3"] = showStep3
                                    }
                                    
                                    // Proceed to Step 1
                                    DispatchQueue.main.async {
                                        let vc: Reg1VC = AppStoryBoards.Register.instance.instantiateViewController(withIdentifier: "Reg1VC_ID") as! Reg1VC
                                        vc.modalTransitionStyle = .crossDissolve
                                        vc.modalPresentationStyle = .overFullScreen
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                                else
                                {
                                    self.showAlertWithTitle(title: "AT&T", message: "Este número de distribuidor no se encuentra registrado. No es posible registrarte en este momento.", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                    return
                                }
                            }
                            //
                            //
                        }
                    }
                }
            }
        }
    }
}
