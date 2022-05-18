//
//  ChangePhoneNumberVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 8/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ChangePhoneNumberVC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!

    @IBOutlet weak var btnSendCode:UIButton!
    @IBOutlet weak var viewResend:UIView!
    @IBOutlet weak var btnReSendCode:UIButton!
    @IBOutlet weak var tfSecurityCode:UnderlineTextField!
    @IBOutlet weak var tfNumber:UnderlineTextField!
    @IBOutlet weak var btnModify:UIButton!
    @IBOutlet weak var btnValidate:UIButton!
    var focusManagerTF : FocusManager?
//    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!


    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vBk.layer.cornerRadius = 5.0
        vBk.layer.masksToBounds = true
        setUpTopBar()
        lblHeader.text = "Cambiar Teléfono de Contacto"

        viewResend.alpha = 0
        btnSendCode.layer.cornerRadius = 5.0
        btnSendCode.layer.masksToBounds = true
        btnReSendCode.layer.cornerRadius = 5.0
        btnReSendCode.layer.masksToBounds = true
        btnModify.layer.cornerRadius = 5.0
        btnModify.layer.masksToBounds = true
        btnValidate.layer.cornerRadius = 5.0
        btnValidate.layer.masksToBounds = true
        setupTFFocus()
        
        btnModify.isHidden = true
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
    
    private func setupTFFocus()
    {
        self.focusManagerTF = FocusManager()
        if let focusManager = self.focusManagerTF {
            focusManager.addItem(item: self.tfSecurityCode)
            focusManager.addItem(item: self.tfNumber)
            // focusManager.focus(index: 0)
        }
        
        tfSecurityCode.delegate = self
        tfNumber.delegate = self
        tfNumber.keyboardType = .numberPad
        tfSecurityCode.setPlaceHolderColorWith(strPH: "Código recibido de 6 digitos (sólo números)")
        tfNumber.setPlaceHolderColorWith(strPH: "Número Telefónico de 10 dígitos")
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendCodeClicked(btn:UIButton)
    {
        callGetOTP()
    }
    
    @IBAction func resendCodeClicked(btn:UIButton)
    {
        callGetOTP()
    }
    
    @IBAction func modifyClicked(btn:UIButton)
    {
        
    }
    
    @IBAction func validateClicked(btn:UIButton)
    {
        if tfSecurityCode.text?.isEmpty == true || tfNumber.text?.isEmpty == true
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
                "security_code": tfSecurityCode.text!,
                "new_phone_number": tfNumber.text!
            ]
            
            // call API
            self.callUpdatePhone(dict: param)
        }
    }
}

extension ChangePhoneNumberVC
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

extension ChangePhoneNumberVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            focusManagerTF!.focusTouch(item: textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            let control = textField as! UnderlineTextField
            control.updateFocus(isFocus: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension ChangePhoneNumberVC
{
    func callGetOTP()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_OtpCode.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let _:String = json["response_object"] as? String
                        {
                            if let msg:String = json["message"] as? String
                            {
                                self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            }
                            DispatchQueue.main.async {
                                UIView.animate(withDuration: 1.0) {
                                    self.viewResend.alpha = 1.0
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callUpdatePhone(dict:[String:Any])
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = dict
        WebService.requestService(url: ServiceName.POST_UpdatePhone.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
 //           print(jsonString)
            
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
    
    @objc func back()
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
