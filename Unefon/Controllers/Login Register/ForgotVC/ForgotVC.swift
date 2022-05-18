//
//  ForgotVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 29/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ForgotVC: UIViewController {
    
    @IBOutlet weak var vBK: UIView!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var btnBk:UIButton!
//    var focusManagerTF : FocusManager?
    
    var strUsername = ""
    var strSecurity = ""
    var strPassword = ""
    var strConfirm = ""
    var strUUID = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vBK.layer.cornerRadius = 10.0
        btnBk.imageView?.setImageColor(color: UIColor.white)
//        self.focusManagerTF = FocusManager()
        tblView.dataSource = self
        tblView.delegate = self
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ForgotVC
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

extension ForgotVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 85
        }
        else if indexPath.row == 1
        {
            return 85
        }
        else if indexPath.row == 2
        {
            return 85
        }
        else if indexPath.row == 3
        {
            return 85
        }
        else
        {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell:Cell_Forgot_TF = tableView.dequeueReusableCell(withIdentifier: "Cell_Forgot_TF", for: indexPath) as! Cell_Forgot_TF
            cell.selectionStyle = .none
            cell.lbl.text = "NOMBRE DE USUARIO"
            cell.tf.text = ""
//            if let focusManager = self.focusManagerTF {
//                focusManager.addItem(item: cell.tf)
//            }
            
            cell.tf.delegate = self
            cell.tf.setPlaceHolderColorWith(strPH: "Ej: distribuidor+1106293")
            cell.tf.tag = indexPath.row
            
            if strUsername != ""
            {
                cell.tf.text = strUsername
            }
            
            cell.btn.layer.cornerRadius = 5.0
            cell.btn.layer.masksToBounds = true
            cell.btn.addTarget(self, action: #selector(self.btnClick(btn:)), for: .touchUpInside)
            
            return cell
        }
        else if indexPath.row == 1
        {
            let cell:CellExchange_TF = tableView.dequeueReusableCell(withIdentifier: "CellExchange_TF", for: indexPath) as! CellExchange_TF
            cell.selectionStyle = .none
            cell.lblTitle.text = "CÓDIGO DE SEGURIDAD"
            cell.tf.text = ""
//            if let focusManager = self.focusManagerTF {
//                focusManager.addItem(item: cell.tf)
//            }
            cell.tf.tag = indexPath.row
            cell.tf.delegate = self
            cell.tf.setPlaceHolderColorWith(strPH: "Código recibido de 6 dígitos (sólo números)")
            if strSecurity != ""
            {
                cell.tf.text = strSecurity
            }
            return cell
        }
        else if indexPath.row == 2
        {
            let cell:CellExchange_TF = tableView.dequeueReusableCell(withIdentifier: "CellExchange_TF", for: indexPath) as! CellExchange_TF
            cell.selectionStyle = .none
            cell.lblTitle.text = "NUEVA CONTRASEÑA"
            cell.tf.text = ""
//            if let focusManager = self.focusManagerTF {
//                focusManager.addItem(item: cell.tf)
//            }
            cell.tf.isSecureTextEntry = true
            cell.tf.tag = indexPath.row
            cell.tf.delegate = self
            cell.tf.setPlaceHolderColorWith(strPH: "Introducir la contraseña")
            if strPassword != ""
            {
                cell.tf.text = strPassword
            }
            return cell
        }
        else if indexPath.row == 3
        {
            let cell:CellExchange_TF = tableView.dequeueReusableCell(withIdentifier: "CellExchange_TF", for: indexPath) as! CellExchange_TF
            cell.selectionStyle = .none
            cell.lblTitle.text = "CONFIRMAR NUEVA CONTRASEÑA"
            cell.tf.text = ""
//            if let focusManager = self.focusManagerTF {
//                focusManager.addItem(item: cell.tf)
//            }
            cell.tf.isSecureTextEntry = true
            cell.tf.tag = indexPath.row
            cell.tf.delegate = self
            cell.tf.setPlaceHolderColorWith(strPH: "Introducir la contraseña")
            if strConfirm != ""
            {
                cell.tf.text = strConfirm
            }
            return cell
        }
        else
        {
            let cell:Cell_Forgot_Btn = tableView.dequeueReusableCell(withIdentifier: "Cell_Forgot_Btn", for: indexPath) as! Cell_Forgot_Btn
            cell.selectionStyle = .none

            cell.btn1.layer.cornerRadius = 5.0
            cell.btn1.layer.masksToBounds = true
            cell.btn1.addTarget(self, action: #selector(self.btnREGÍSTRATEClick(btn:)), for: .touchUpInside)
            
            cell.btn2.layer.borderWidth = 2.0
            cell.btn2.layer.cornerRadius = 5.0
            cell.btn2.layer.borderColor = UIColor.lightGray.cgColor
            cell.btn2.layer.masksToBounds = true
            cell.btn2.addTarget(self, action: #selector(self.btnSIGUIENTEClick(btn:)), for: .touchUpInside)

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    @objc func btnREGÍSTRATEClick(btn:UIButton)
    {
        let vc: RegisterVC = AppStoryBoards.Main.instance.instantiateViewController(withIdentifier: "RegisterVC_ID") as! RegisterVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func btnSIGUIENTEClick(btn:UIButton)
    {
        // Continue Click
        if strUsername.isEmpty == false || strSecurity.isEmpty == false || strPassword.isEmpty == false || strConfirm.isEmpty == false
        {
            if strPassword != strConfirm
            {
                self.showAlertWithTitle(title: "Validación", message: "Contraseña y confirmar contraseña no coinciden", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            }
            else
            {
                // CALL Submit Api
                callSubmitPassword()
            }
        }
        else
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
    }
    
    @objc func btnClick(btn:UIButton)
    {
        self.view.endEditing(true)
        // SEND CODE
        if strUsername.isEmpty == false
        {
            callSendCode()
        }
        else
        {
            self.showAlertWithTitle(title: "Validación", message: "Introduzca su nombre de usuario", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
    }
}

extension ForgotVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 0
        {
            strUsername = textField.text!
        }
        else if textField.tag == 1
        {
            strSecurity = textField.text!
        }
        else if textField.tag == 2
        {
            strPassword = textField.text!
        }
        else if textField.tag == 3
        {
            strConfirm = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension ForgotVC
{
    func callSendCode()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["user_name":strUsername]
        WebService.requestService(url: ServiceName.GET_ForgotPasswordCode.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                                                
                        if let uuid:String = json["response_object"] as? String
                        {
                            self.strUUID = uuid
                        }
                        
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                }
            }
        }
    }
    
    func callSubmitPassword()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":strUUID, "security_code": strSecurity, "new_password": strConfirm]
        WebService.requestService(url: ServiceName.POST_UpdatePassword.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
        self.dismiss(animated: true, completion: nil)
    }
}
