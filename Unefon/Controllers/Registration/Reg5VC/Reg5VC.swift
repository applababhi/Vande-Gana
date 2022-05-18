//
//  Reg5VC.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class Reg5VC: UIViewController {
    
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    @IBOutlet weak var lbl3:UILabel!
    @IBOutlet weak var lbl4:UILabel!
    @IBOutlet weak var lbl5:UILabel!
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!
    
    var focusManagerTF : FocusManager?
    @IBOutlet weak var tfPhone: UnderlineTextField!
    @IBOutlet weak var btnNext:UIButton!
    
    let k_lblRadiusHeader:CGFloat = 20.0
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vBk.layer.cornerRadius = 5.0
        vBk.layer.masksToBounds = true
        setUpTopBar()
        lblHeader.text = "Teléfono de Contacto"
        
        setupTFFocus()
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
        lbl4.layer.borderWidth = 2.0
        lbl4.layer.masksToBounds = true
        
        lbl5.layer.cornerRadius = k_lblRadiusHeader
        lbl5.layer.borderColor = k_baseColor.cgColor
        lbl5.layer.borderWidth = 2.0
        lbl5.layer.masksToBounds = true
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
            focusManager.addItem(item: self.tfPhone)
            // focusManager.focus(index: 0)
        }
        
        tfPhone.keyboardType = .numberPad
        tfPhone.delegate = self
        tfPhone.setPlaceHolderColorWith(strPH: "Número celular de 10 dígitos (Incluyendo)")
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func nextClicked(btn:UIButton)
    {
        if tfPhone.text?.isEmpty == false
        {
            if tfPhone.text!.count < 10
            {
                self.showAlertWithTitle(title: "Validación", message: "El número de teléfono debe ser de 10 dígitos.", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            }
            else
            {
                let sel:Selector = #selector(callRegisterApi)
                self.showAlertWithTitle(title: "Confirmar", message: "Usted ingresó el número de teléfono es \(tfPhone.text!)", okButton: "Ok", cancelButton: "", okSelectorName: sel)
            }
        }
        else
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
    }
}

extension Reg5VC
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

extension Reg5VC: UITextFieldDelegate
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        let Range = range.length + range.location > (tfPhone.text?.count)!
        
        if Range == false && alphabet == false {
            return false
        }
        
        let NewLength = (tfPhone.text?.count)! + string.count - range.length
        return NewLength <= 10
    }
}

extension Reg5VC
{
    @objc func callRegisterApi()
    {
        let param: [String:Any] = [
            "uuid": k_helper.tempRegisterDict["uuid"] as! String,
            "plan_id": k_helper.tempRegisterDict["plan_id"] as! String,
            "campaign_id": k_helper.tempRegisterDict["campaign_id"] as! String,
            "company_id": k_helper.tempRegisterDict["company_id"] as! String,
            "workplace_id": k_helper.tempRegisterDict["workplace_id"] as! String,
            "profile_picture_temporal_media_id": k_helper.tempRegisterDict["profile_picture_temporal_media_id"] as! String,
            "profile_picture_auto_acceptance_status": k_helper.tempRegisterDict["profile_picture_auto_acceptance_status"] as! Int,
            "profile_picture_auto_acceptance_score": k_helper.tempRegisterDict["profile_picture_auto_acceptance_score"] as! Int,
            "first_name": k_helper.tempRegisterDict["first_name"] as! String,
            "last_name_1": k_helper.tempRegisterDict["last_name_1"] as! String,
            "last_name_2": k_helper.tempRegisterDict["last_name_2"] as! String,
            "gender_id": k_helper.tempRegisterDict["gender_id"] as! String,
            "residence_state": k_helper.tempRegisterDict["state_id"] as! Int,
            "password": k_helper.tempRegisterDict["password"] as! String,
            "personal_mail_address": k_helper.tempRegisterDict["personal_mail_address"] as! String,
            "phone_number": tfPhone.text!
        ]
        
        self.showSpinnerWith(title: "Cargando...")
        
        WebService.requestService(url: ServiceName.POST_RegisterNewUser.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        DispatchQueue.main.async {
                            
                            if let wID:String = k_helper.tempRegisterDict["workplace_id"] as? String
                            {
                                k_userDef.setValue(wID, forKey: userDefaultKeys.user_Loginid.rawValue)
                            }
                            if let uuid:String = k_helper.tempRegisterDict["uuid"] as? String
                            {
                                k_userDef.setValue(uuid, forKey: userDefaultKeys.uuid.rawValue)
                            }
                            if let plan:String = k_helper.tempRegisterDict["plan_id"] as? String
                            {
                                k_userDef.setValue(plan, forKey: userDefaultKeys.plan_id.rawValue)
                            }
                            k_userDef.synchronize()
                            
                            k_helper.tempRegisterDict.removeAll()
                            
                            let vc: DashobaordVC = AppStoryBoards.Dashboard.instance.instantiateViewController(withIdentifier: "DashobaordVC_ID") as! DashobaordVC
                            k_window.rootViewController = vc
                        }
                    }
                }
            }
        }
    }
}
