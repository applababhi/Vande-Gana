//
//  OperationsVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/5/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class OperationsVC: UIViewController {

    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var lblBalance:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!

    var arrData:[[String:Any]] = []
    var strTitle = ""
    var strBalance = "0"
    
    var isTokenCall = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblHeader.text = strTitle
        lblBalance.text = strBalance
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.estimatedRowHeight = 50
        tblView.rowHeight = UITableView.automaticDimension
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

extension OperationsVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]
       
        let cell:CellRecompensas_New_Mis = tableView.dequeueReusableCell(withIdentifier: "CellRecompensas_New_Mis", for: indexPath) as! CellRecompensas_New_Mis
        cell.selectionStyle = .none
        
        cell.vBk.layer.cornerRadius = 5.0
        cell.vBk.layer.masksToBounds = true
        cell.btn.tag = indexPath.row
        
        cell.lblDate.text = ""
        cell.lblName.text = ""
        cell.lblDescription.text = ""

        if let title:String = dict["tokens_str"] as? String
        {
            cell.lblName.text = title
            if let coloor:String = dict["color"] as? String
            {
                cell.lblName.textColor = UIColor.colorWithHexString(coloor)
            }
        }
        
        if let title:String = dict["points_str"] as? String
        {
            cell.lblName.text = title
            if let coloor:String = dict["color"] as? String
            {
                cell.lblName.textColor = UIColor.colorWithHexString(coloor)
            }
        }
        if let str:String = dict["transaction_date_str"] as? String
        {
            cell.lblDate.text = str
        }
        if let str:String = dict["description"] as? String
        {
            cell.lblDescription.text = str
        }

        cell.btn.addTarget(self, action: #selector(self.btnTapped(btn:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnTapped(btn:UIButton)
    {
        let dict:[String:Any] = arrData[btn.tag]
        
        if isTokenCall == true{
            // TOKEN Call
            var token_transaction_id = ""
            if let str:String = dict["token_transaction_id"] as? String{
                token_transaction_id = str
            }
            callApiForTokens(token_transaction_id: token_transaction_id)
        }
        else{
            // POINTS Call
            var transaction_id = ""
            if let str:String = dict["transaction_id"] as? String{
                transaction_id = str
            }
            callApiForPoints(transaction_id: transaction_id)
        }
    }
}

extension OperationsVC
{
    func callApiForPoints(transaction_id:String){
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["transaction_id":transaction_id]
        WebService.requestService(url: ServiceName.GET_Point_Operation.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
              print(jsonString)
            
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
                            DispatchQueue.main.async {
                                let vc: OperationDetailVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "OperationDetailVC_ID") as! OperationDetailVC
                                vc.dictMain = dMain
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func callApiForTokens(token_transaction_id:String){
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["token_transaction_id":token_transaction_id]
        WebService.requestService(url: ServiceName.GET_Token_Operation.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let dMain:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                let vc: OperationDetailVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "OperationDetailVC_ID") as! OperationDetailVC
                                vc.dictMain = dMain
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
