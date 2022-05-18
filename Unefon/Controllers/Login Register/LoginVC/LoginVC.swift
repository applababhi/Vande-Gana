//
//  LoginVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

   // var focusManagerTF : FocusManager?
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var btnLogin:UIButton!
    
    /*
    @IBOutlet weak var c_Register_Tp:NSLayoutConstraint!
    @IBOutlet weak var c_Register_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_Login_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_Register_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_Login_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_Privacy_Bt:NSLayoutConstraint!
    
    @IBOutlet weak var c_RegBt_Ld_iPad:NSLayoutConstraint!
    @IBOutlet weak var c_LogBt_Tr_iPad:NSLayoutConstraint!
    */
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let username:String = k_userDef.value(forKey: userDefaultKeys.user_Loginid.rawValue) as? String
        {
            if username != ""
            {
                tfUsername.text = username
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTFFocus()
        setUpTopBar()
        
        if isPad == true
        {
            
        }
        
        //  tfUsername.text = "distribuidor+101010"
     //   tfUsername.text = "distribuidor+106262"
      //  tfPassword.text = "cleverflow"
        
      //  tfUsername.text = "distribuidor+106665"
       // tfPassword.text = "Hdm30411403=?"

    }
    
    private func setupTFFocus()
    {
        /*
        self.focusManagerTF = FocusManager()
        if let focusManager = self.focusManagerTF {
            focusManager.addItem(item: self.tfUsername)
            focusManager.addItem(item: self.tfPassword)
           // focusManager.focus(index: 0)
        }
        */
        addLeftPaddingTo(TextField: tfUsername)
        addLeftPaddingTo(TextField: tfPassword)
        tfUsername.layer.borderColor = UIColor.white.cgColor
        tfUsername.layer.borderWidth = 1.0
        tfUsername.layer.cornerRadius = 3.0
        tfUsername.layer.masksToBounds = true
        tfPassword.layer.borderColor = UIColor.white.cgColor
        tfPassword.layer.borderWidth = 1.0
        tfPassword.layer.cornerRadius = 3.0
        tfPassword.layer.masksToBounds = true
        tfUsername.delegate = self
        tfPassword.delegate = self
        tfPassword.isSecureTextEntry = true
       // tfUsername.setPlaceHolderColorWith(strPH: "Ej: distribuidor+1106293")
      //  tfPassword.setPlaceHolderColorWith(strPH: "Introducir la contraseña")
        hideKeyboardWhenTappedAround()
        
        btnLogin.layer.borderColor = UIColor.white.cgColor
        btnLogin.layer.borderWidth = 1.0
        btnLogin.layer.cornerRadius = 20.0
        btnLogin.layer.masksToBounds = true
        
        btnRegister.layer.cornerRadius = 20.0
        btnRegister.layer.masksToBounds = true
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
//            c_Register_Tp.constant = 30
//            c_Register_Wd.constant = 120
//            c_Login_Wd.constant = 125
//            c_Register_Ht.constant = 40
//            c_Login_Ht.constant = 40
//            c_Privacy_Bt.constant = 20
        }
    }
    
    @IBAction func forgotClicked(btn:UIButton)
    {
        let vc: ForgotVC = AppStoryBoards.Main.instance.instantiateViewController(withIdentifier: "ForgotVC_ID") as! ForgotVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func registerClicked(btn:UIButton)
    {
        let vc: RegisterVC = AppStoryBoards.Main.instance.instantiateViewController(withIdentifier: "RegisterVC_ID") as! RegisterVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(btn:UIButton)
    {
        self.view.endEditing(true)
        if validateTF() == true
        {
            callLoginApi()
        }
    }
    
    @IBAction func privacyClicked(btn:UIButton)
    {
        //  (string: "https://www.unefon.com.mx/legales/aviso-de-privacidad.php")
        if let url = URL(string: "https://www.unefon.com.mx/") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func contactClicked(btn:UIButton)
    {
        let vc: ContactVC = AppStoryBoards.Contact.instance.instantiateViewController(withIdentifier: "ContactVC_ID") as! ContactVC
        vc.isInnerTableShow = false
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true, completion: nil)
    }
}

extension LoginVC
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

extension LoginVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
                
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
    func validateTF() -> Bool
    {
        if tfUsername.text!.isEmpty == true || tfPassword.text!.isEmpty == true
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

//MARK: API CALLS
extension LoginVC
{
    func callLoginApi()
    {
        var version:String = ""
        if appVersion != nil{
            version = appVersion!
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["username":tfUsername.text!, "password": tfPassword.text!.md5Value, "ios_app_version": version, "android_app_version": "", "android_notification_token": "", "ios_notification_token": deviceToken_FCM]
    //    print(param)
        WebService.requestService(url: ServiceName.POST_Login.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let dictResp:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            k_userDef.setValue(self.tfUsername.text!, forKey: userDefaultKeys.user_Loginid.rawValue)
                            if let dict:[String:Any] = dictResp["general"] as? [String:Any]
                            {
                                if let dictUI:[String:Any] = dict["user_information"] as? [String:Any]
                                {
                                    if let uuid:String = dictUI["uuid"] as? String
                                    {
                                        k_userDef.setValue(uuid, forKey: userDefaultKeys.uuid.rawValue)
                                    }
                                    if let plan:String = dictUI["plan_id"] as? String
                                    {
                                        k_userDef.setValue(plan, forKey: userDefaultKeys.plan_id.rawValue)
                                    }
                                }
                                
                                if let dictAI:[String:Any] = dict["app_information"] as? [String:Any]
                                {
                                    if let checkUpdate:Int = dictAI["require_software_update"] as? Int
                                    {
                                        if checkUpdate == 1
                                        {
                                            // Show Alert to update
                                            self.showAlertWithTitle(title: "Alerta", message: "Hay una nueva versión de la app disponible.", okButton: "Instalar", cancelButton: "Ahora No", okSelectorName: #selector(self.takeToStore))
                                        }
                                    }
                                }
                            }
                            
                        }
                        k_userDef.synchronize()
                        
                        DispatchQueue.main.async {
                            /*let vc: DashobaordVC = AppStoryBoards.Dashboard.instance.instantiateViewController(withIdentifier: "DashobaordVC_ID") as! DashobaordVC
                            k_window.rootViewController = vc*/
                            let tab: HomeTabBarVC = AppStoryBoards.HomeTabBarVC.instance.instantiateViewController(withIdentifier: "HomeTabBarVC_ID") as! HomeTabBarVC
                            k_window.rootViewController = tab
                        }
                    }
                }
            }
        }
    }
    
    @objc func takeToStore()
    {
        let urlStr = "itms-apps://itunes.apple.com/app/radio-fm/id1004413147?mt=12"
        UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)

        
        // var appID: String = infoDictionary["CFBundleIdentifier"]
        // var url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(appID)")
        // https://apps.apple.com/in/app/whatsapp-desktop/id1147396723?mt=12
        // Homechow : "itunes.apple.com/us/app/homechow/id1435002621?ls=1&mt=8"
    }
}
