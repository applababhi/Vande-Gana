//
//  Reg4VC.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class Reg4VC: UIViewController {

    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    @IBOutlet weak var lbl3:UILabel!
    @IBOutlet weak var lbl4:UILabel!
    @IBOutlet weak var lbl5:UILabel!

    var focusManagerTF : FocusManager?
    @IBOutlet weak var tfEmail: UnderlineTextField!
    @IBOutlet weak var tfCode: UnderlineTextField!
    @IBOutlet weak var btnSendCode:UIButton!
    @IBOutlet weak var viewResendCode:UIView!
    @IBOutlet weak var btnResendCode:UIButton!
    @IBOutlet weak var btnNext:UIButton!
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var vBk1:UIView!
    @IBOutlet weak var vBk2:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!


    let k_lblRadiusHeader:CGFloat = 20.0
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vBk1.layer.cornerRadius = 5.0
        vBk1.layer.masksToBounds = true

        vBk2.layer.cornerRadius = 5.0
        vBk2.layer.masksToBounds = true
        setUpTopBar()
        lblHeader.text = "Correo Electrónico de Contacto"

        setupTFFocus()
        viewResendCode.alpha = 0.0
        btnSendCode.layer.cornerRadius = 5.0
        btnSendCode.layer.masksToBounds = true
        btnResendCode.layer.cornerRadius = 5.0
        btnResendCode.layer.masksToBounds = true
        btnNext.layer.cornerRadius = 5.0
        btnNext.layer.masksToBounds = true
        
        lbl1.layer.cornerRadius = k_lblRadiusHeader
        lbl1.layer.borderWidth = 2.0
        lbl1.layer.masksToBounds = true
        
        lbl2.layer.cornerRadius = k_lblRadiusHeader
        lbl2.layer.borderWidth = 2.0
        lbl2.layer.masksToBounds = true
        
        lbl3.layer.cornerRadius = k_lblRadiusHeader
        lbl3.layer.borderWidth = 2.0
        lbl3.layer.masksToBounds = true

        lbl4.layer.cornerRadius = k_lblRadiusHeader
        lbl4.layer.borderColor = k_baseColor.cgColor
        lbl4.layer.borderWidth = 2.0
        lbl4.layer.masksToBounds = true
        
        lbl5.layer.cornerRadius = k_lblRadiusHeader
        lbl5.layer.borderWidth = 2.0
        lbl5.layer.masksToBounds = true

    }
    
    private func setupTFFocus()
    {
        self.focusManagerTF = FocusManager()
        if let focusManager = self.focusManagerTF {
            focusManager.addItem(item: self.tfEmail)
            focusManager.addItem(item: self.tfCode)
            // focusManager.focus(index: 0)
        }
        
        tfEmail.delegate = self
        tfCode.delegate = self
        tfEmail.setPlaceHolderColorWith(strPH: "carlos_espinosa@cleverflow.mx")
        tfCode.setPlaceHolderColorWith(strPH: "Código recibido de 6 dígitos (sólo números)")
        hideKeyboardWhenTappedAround()
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
    
    @IBAction func sendCodeClicked(btn:UIButton)
    {
        if tfEmail.text?.isEmpty == false
        {
            if isValidEmail(testStr: tfEmail.text!) == true
            {
                callSendCodeEmailApi()
            }
            else
            {
                self.showAlertWithTitle(title: "Validación", message: "Correo electrónico no es un formato incorrecto", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            }
        }
        else
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
    }
    
    @IBAction func resendCodeClicked(btn:UIButton)
    {
        if tfEmail.text?.isEmpty == false
        {
            if isValidEmail(testStr: tfEmail.text!) == true
            {
                callSendCodeEmailApi()
            }
            else
            {
                self.showAlertWithTitle(title: "Validación", message: "Correo electrónico no es un formato incorrecto", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            }
        }
        else
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
    }
    
    @IBAction func nextClicked(btn:UIButton)
    {
        if tfCode.text?.isEmpty == false
        {
            callValidateCodeApi()
        }
        else
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
    }
}

extension Reg4VC
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

extension Reg4VC: UITextFieldDelegate
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

extension Reg4VC
{
    func callSendCodeEmailApi()
    {
        self.view.endEditing(true)
        var uuid = ""
        if let uu:String = k_helper.tempRegisterDict["uuid"] as? String
        {
            uuid = uu
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["mail_address":tfEmail.text!, "uuid":uuid]
        WebService.requestService(url: ServiceName.GET_SendCodeEmail.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "Error", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                        }
                        
                        DispatchQueue.main.async {
                            // Animate to show
                            UIView.animate(withDuration: 1.0, animations: {
                                self.viewResendCode.alpha = 1.0
                            })
                        }
                    }
                }
            }
        }
    }
    
    func callValidateCodeApi()
    {
        self.view.endEditing(true)
        var uuid = ""
        if let uu:String = k_helper.tempRegisterDict["uuid"] as? String
        {
            uuid = uu
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["code":tfCode.text!, "uuid":uuid]
        WebService.requestService(url: ServiceName.GET_SendCodeValidate.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let msg:String = json["message"] as? String
                        {
                            k_helper.tempRegisterDict["personal_mail_address"] = self.tfEmail.text!
                        }
                        
                        DispatchQueue.main.async {
                            let vc: Reg5VC = AppStoryBoards.Register.instance.instantiateViewController(withIdentifier: "Reg5VC_ID") as! Reg5VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
