//
//  PointsTransactionRedemptionVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 26/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit


class PointsTransactionRedemptionVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    @IBOutlet weak var lbl3:UILabel!
    @IBOutlet weak var lbl4:UILabel!
    @IBOutlet weak var lbl5:UILabel!
    @IBOutlet weak var lbl6:UILabel!
    @IBOutlet weak var lbl7:UILabel!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var strTitle = ""
    var strRedemptionID = ""


    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblTitle.text = strTitle
        lbl1.text = ""
        lbl2.text = "Producto:"
        lbl3.text = "Marca:"
        lbl4.text = "Precio:"
        lbl5.text = "Status:"
        lbl6.text = "Fecha de Solicitud:"
        lbl7.text = "Fecha de Entrega:"
        callGetRedemption()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
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

extension PointsTransactionRedemptionVC
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

extension PointsTransactionRedemptionVC
{
    func callGetRedemption()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["redemption_id":strRedemptionID]
        WebService.requestService(url: ServiceName.GET_TransactionRedemptions.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let d:[String:Any] = dict["redemption"] as? [String:Any]
                            {
                                DispatchQueue.main.async {

                                    if let str:String = d["description"] as? String
                                    {
                                        self.lbl1.text = str
                                    }
                                }
                            }
                            
                            if let d1:[String:Any] = dict["code"] as? [String:Any]
                            {
                                DispatchQueue.main.async {
                                    if let str:String = d1["gift_name"] as? String
                                    {
                                        self.lbl2.text = "Producto:" + " \(str)"
                                    }
                                    if let str:String = d1["brand"] as? String
                                    {
                                        self.lbl3.text = "Marca:" + " \(str)"
                                    }
                                    if let str:String = d1["denomination_str"] as? String
                                    {
                                        self.lbl4.text = "Precio:" + " \(str)"
                                    }
                                    if let str:String = d1["status_str"] as? String
                                    {
                                        self.lbl5.text = "Status:" + " \(str)"
                                    }
                                    if let str:String = d1["request_date_str"] as? String
                                    {
                                        self.lbl6.text = "Fecha de Solicitud:" + " \(str)"
                                    }
                                    if let str:String = d1["delivery_date_str"] as? String
                                    {
                                        self.lbl7.text = "Fecha de Entrega:" + " \(str)"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
