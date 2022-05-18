//
//  EmailFavDetailVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 3/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit
import WebKit

class EmailFavDetailVC: UIViewController {

    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var btnFavourite:UIButton!
    @IBOutlet weak var viewWeb:UIView!
    var webView: WKWebView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var strHeader = ""
    var strMailID = ""

    var htmlString:String = ""
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblHeader.text = strHeader
        lblTitle.text = ""
        lblSubTitle.text = ""
        lblEmail.text = ""
        lblDate.text = ""
        btnFavourite.setImage(UIImage(named: "HeartEmpty"), for: .normal)
        callGetEmailDetail()
    }
    
    @objc func loadWebV()
    {
        
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(userScript)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        ///////     ///////     ///////      //////    The Above lines of code is use to zoom content to fit webview
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: viewWeb.frame.size.width, height: viewWeb.frame.size.height), configuration: wkWebConfig)
        webView.loadHTMLString(htmlString, baseURL: nil)
        viewWeb.addSubview(webView)
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
       // NotificationCenter.default.post(name: Notification.Name("viewWillAppear_EmailFavListVC"), object: nil)
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favClicked(btn:UIButton)
    {
        if btnFavourite.isSelected == true
        {
            callSetUnFavourite()
        }
        else
        {
            callSetFavourite()
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

extension EmailFavDetailVC
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

extension EmailFavDetailVC
{
    func callGetEmailDetail()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["mail_id":strMailID]
        WebService.requestService(url: ServiceName.GET_EmailDetail.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                            if let title:String = dict["subject"] as? String
                            {
                                self.lblTitle.text = title
                            }
                            if let title:String = dict["to_name"] as? String
                            {
                                self.lblSubTitle.text = "Para: \(title)"
                            }
                            if let title:String = dict["from_address"] as? String
                            {
                                self.lblEmail.text = "De: \(title)"
                            }
                            if let title:String = dict["absolute_date_str"] as? String
                            {
                                self.lblDate.text = title
                            }
                            if let title:String = dict["body_html"] as? String
                            {
                                self.htmlString = title
                            }
                                
                                if let isFav:Int = dict["is_favourite"] as? Int
                                {
                                    if isFav == 1
                                    {
                                        self.btnFavourite.isSelected = true
                                        self.btnFavourite.setImage(UIImage(named: "Heart"), for: .normal)
                                    }
                                    else
                                    {
                                        self.btnFavourite.isSelected = false
                                        self.btnFavourite.setImage(UIImage(named: "HeartEmpty"), for: .normal)
                                    }
                                }
                                
                                self.perform(#selector(self.loadWebV), with: nil, afterDelay: 0.2)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callSetFavourite()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["mail_id":strMailID]
        
        WebService.requestService(url: ServiceName.PUT_SetFavorite.rawValue, method: .put, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //  print(jsonString)
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
                            self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                        }
                        DispatchQueue.main.async {
                            self.btnFavourite.isSelected = true
                            self.btnFavourite.setImage(UIImage(named: "Heart"), for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    func callSetUnFavourite()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["mail_id":strMailID]
        
        WebService.requestService(url: ServiceName.PUT_SetUnFavorite.rawValue, method: .put, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //  print(jsonString)
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
                            self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                        }
                        DispatchQueue.main.async {
                            self.btnFavourite.isSelected = false
                            self.btnFavourite.setImage(UIImage(named: "HeartEmpty"), for: .normal)
                        }
                    }
                }
            }
        }
    }
}
