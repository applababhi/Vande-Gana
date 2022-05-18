//
//  BuyGiftVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 29/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class BuyGiftVC: UIViewController {
    
    
    @IBOutlet weak var lblProduct:UILabel!
    @IBOutlet weak var lblMarca:UILabel!
    @IBOutlet weak var lblDenominación:UILabel!
    @IBOutlet weak var lblPuntos:UILabel!
    @IBOutlet weak var lblActual:UILabel!
    @IBOutlet weak var lblRedimir:UILabel!
    @IBOutlet weak var tfPassword:UITextField!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var strQuantity = ""
    var strGiftId = ""
    var dictMain:[String:Any] = [:]
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTopBar()
        tfPassword.delegate = self
        btnNext.layer.cornerRadius = 5.0
        
        if let str:String = dictMain["gift_name"] as? String
        {
            lblProduct.text = "Producto: " + str
        }
        if let str:String = dictMain["brand"] as? String
        {
            lblMarca.text = "Marca: " + str
        }
        if let str:String = dictMain["denomination_str"] as? String
        {
            lblDenominación.text = "Denominación: " + str
        }
        if let str:String = dictMain["cost_str"] as? String
        {
            lblPuntos.text = "Costo en puntos: " + str
        }
        if let str:String = dictMain["current_balance_str"] as? String
        {
            lblActual.text = "Saldo actual: " + str
        }
        if let str:String = dictMain["next_balance_str"] as? String
        {
            lblRedimir.text = "Saldo Después de Redimir: " + str
        }
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextClicked(btn:UIButton)
    {
        if tfPassword.text!.isEmpty == true
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            callGetRedemption()
        }
    }
    
    func setUpTopBar()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
            c_TopBar_Ht.constant = 90
        }
        else if strModel == "iPhone Max"
        {
            c_TopBar_Ht.constant = 90
        }
        else if strModel == "iPhone 5"
        {
            
        }
        else{
            c_TopBar_Ht.constant = 110
        }
    }
}

extension BuyGiftVC
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

extension BuyGiftVC
{
    func callGetRedemption()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        var denomination = 0
        if let denomin:Int = dictMain["denomination"] as? Int
        {
            denomination = denomin
        }
        
        self.showSpinnerWith(title: "Cargando...")
        
        let param: [String:Any] = ["uuid":uuid, "gift_id":strGiftId, "denomination":denomination, "password":tfPassword.text!.md5Value, "quantity":strQuantity]

        WebService.requestService(url: ServiceName.POST_SubmitBuyGiftPost.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let codeID:String = dict["code_request_id"] as? String
                            {
                                if let msg:String = json["message"] as? String
                                {
                                    self.showAlertWithTitle(title: "AT&T", message: msg + " " + codeID, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.takeToExchangeDetailVC))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func takeToExchangeDetailVC()
    {
        print("- - UPDATE  ExchangeDetailVC  Wallet - -")
        let objToBeSent = "Test Message from Submit BuyGiftVC"
        NotificationCenter.default.post(name: Notification.Name("SubmitGiftBuy"), object: objToBeSent)
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension BuyGiftVC: UITextFieldDelegate
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
}
