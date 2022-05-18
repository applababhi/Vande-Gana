//
//  UserProfileVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/12/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!
    
    var showLabelInEmptyCell = false
    var dMainProfile:[String:Any] = [:]
    var arrData:[[String:Any]] = [["type":"Header"], ["type":"Regular", "title":"Cambiar mi Imagen de Perfil", "image":"New_my_profile_picture"], ["type":"Regular", "title":"Cambiar mi Información Personal", "image":"New_my_profile_information"], ["type":"Regular", "title":"Cambiar mi Correo de Contacto", "image":"New_my_profile_address"], ["type":"Regular", "title":"Cambiar mi Teléfono de Contacto", "image":"New_my_profile_phone"], ["type":"Regular", "title":"Cambiar mi Contraseña", "image":"New_my_profile_password"], ["type":"Regular", "title":"Cerrar Sesión", "image":"New_my_profile_log_out"], ["type":"Empty"]]
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblHeader.text = "Mi Perfil"
        
        callUserProfile()
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

extension UserProfileVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var strType = ""
        let dict:[String:Any] = arrData[indexPath.row]
        if let type:String = dict["type"] as? String
        {
            strType = type
        }

        if strType == "Header"
        {
            return 65
        }
        else if strType == "Regular"
        {
            return 70
        }
        else if strType == "Empty"
        {
            return 80
        }
        else if strType == "Contact"
        {
            return 70
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var strType = ""
        let dict:[String:Any] = arrData[indexPath.row]
        if let type:String = dict["type"] as? String
        {
            strType = type
        }

        if strType == "Header"
        {
            let cell:CellUserProfile = tableView.dequeueReusableCell(withIdentifier: strType, for: indexPath) as! CellUserProfile
            cell.selectionStyle = .none
            cell.imgView.layer.cornerRadius = 25.0
            cell.imgView.layer.borderWidth = 1.5
            cell.imgView.layer.borderColor = UIColor.white.cgColor
            cell.imgView.layer.masksToBounds = true

            cell.lbl_1.text = ""
            cell.lbl_2.text = ""
            
            if let imgStr:String = self.dMainProfile["profile_picture_url"] as? String
            {
                cell.imgView.setImageUsingUrl(imgStr)
            }
            if let str:String = self.dMainProfile["full_name"] as? String
            {
                cell.lbl_1.text = str
            }
            if let str:String = self.dMainProfile["workplace_name"] as? String
            {
                cell.lbl_2.text = str
            }
            
            
            return cell
        }
        else if strType == "Regular"
        {
            let cell:CellUserProfile = tableView.dequeueReusableCell(withIdentifier: strType, for: indexPath) as! CellUserProfile
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true

            cell.lblTitle.text = ""
            cell.imgView.image = nil
                        
            if let str:String = dict["title"] as? String{
                cell.lblTitle.text = str
            }
            if let str:String = dict["image"] as? String{
                cell.imgView.image = UIImage(named: str)
            }
            
            cell.btn.tag = indexPath.row
            cell.btn.addTarget(self, action: #selector(self.btnTapped(btn:)), for: .touchUpInside)
            
            return cell
        }
        else if strType == "Empty"
        {
            let cell:CellUserProfile = tableView.dequeueReusableCell(withIdentifier: strType, for: indexPath) as! CellUserProfile
            cell.selectionStyle = .none
            cell.lblTitle.isHidden = true
            
            if self.showLabelInEmptyCell == true
            {
                cell.lblTitle.isHidden = false
            }
            return cell
        }
        else if strType == "Contact"
        {
            let cell:CellUserProfile = tableView.dequeueReusableCell(withIdentifier: strType, for: indexPath) as! CellUserProfile
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true

            cell.lbl_1.text = ""
            cell.lbl_2.text = ""
            
            if let str:String = dict["title"] as? String
            {
                cell.lbl_1.text = str
            }
            if let str:String = dict["subtitle"] as? String
            {
                cell.lbl_2.text = str
            }

            cell.btn.tag = indexPath.row
            cell.btn.addTarget(self, action: #selector(self.btnTapped(btn:)), for: .touchUpInside)
            return cell
        }
       
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnTapped(btn:UIButton)
    {
        let dict:[String:Any] = arrData[btn.tag]
        
        if let strTitle:String = dict["title"] as? String
        {
            print(strTitle)
            if strTitle == "Cambiar mi Imagen de Perfil"
            {
                let vc: ChangePhotoVC = AppStoryBoards.Profile.instance.instantiateViewController(withIdentifier: "ChangePhotoVC_ID") as! ChangePhotoVC
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.presentModal(vc: vc)

            }
            else if strTitle == "Cambiar mi Información Personal"
            {
                let vc: ProfileVC = AppStoryBoards.Profile.instance.instantiateViewController(withIdentifier: "ProfileVC_ID") as! ProfileVC
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.presentModal(vc: vc)
            }
            else if strTitle == "Cambiar mi Correo de Contacto"
            {                
                let vc: ChangeEmailVC = ChangeEmailVC(nibName: "ChangeEmailVC", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.presentModal(vc: vc)
            }
            else if strTitle == "Cambiar mi Teléfono de Contacto"
            {
                let vc: ChangePhoneNumberVC = ChangePhoneNumberVC(nibName: "ChangePhoneNumberVC", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.presentModal(vc: vc)
            }
            else if strTitle == "Cambiar mi Contraseña"
            {
                let vc: ChangePasswordVC = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.presentModal(vc: vc)
            }
            else if strTitle == "Cerrar Sesión"
            {
                let alertController = UIAlertController(title: "Cerrar sesión", message: "Estás seguro de que quieres desconectarte?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "sí", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Yes Logout Pressed")
                    self.callLogoutApi()
                }
                let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Logout Pressed")
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension UserProfileVC
{
    func callUserProfile(){
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_UserProfile.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let dMain:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async
                            {
                                if let dProfile:[String:Any] = dMain["profile"] as? [String:Any]{
                                    self.dMainProfile = dProfile
                                    
                                    if let str:String = dProfile["platform_contact_mail_address"] as? String
                                    {
                                        if !str.isEmpty{
                                            self.showLabelInEmptyCell = true
                                            self.arrData.append(["type":"Contact", "title":"Escríbenos", "subtitle":str])
                                        }
                                    }
                                    if let str:String = dProfile["platform_contact_phone_number"] as? String
                                    {
                                        if !str.isEmpty{
                                            self.showLabelInEmptyCell = true
                                            self.arrData.append(["type":"Contact", "title":"Llámanos", "subtitle":str])
                                        }
                                    }
                                }
                              
                                self.tblView.delegate = self
                                self.tblView.dataSource = self
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callLogoutApi()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["ios_notification_token":deviceToken_FCM]
        WebService.requestService(url: ServiceName.DELETE_Logout.rawValue, method: .delete, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                print("USER LOGOUT - - - - - - - ")
                DispatchQueue.main.async {
                    k_userDef.setValue("", forKey: userDefaultKeys.uuid.rawValue)
                    k_userDef.setValue("", forKey: userDefaultKeys.plan_id.rawValue)
                    //                k_userDef.setValue("", forKey: userDefaultKeys.user_Loginid.rawValue) don't empty show in Login
                    k_userDef.synchronize()
                    
                    let vc: LoginVC = AppStoryBoards.Main.instance.instantiateViewController(withIdentifier: "LoginVC_ID") as! LoginVC
                    k_window.rootViewController = vc
                }
            }
        }
    }
}
