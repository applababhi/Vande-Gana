//
//  CanjearListVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/5/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CanjearListVC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!

    var arrData:[[String:Any]] = []
    var strTitle = ""
    var strBalance = "0"
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblHeader.text = strTitle
        
        tblView.delegate = self
        tblView.dataSource = self
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

extension CanjearListVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerCell: CellRecompensas_New_Canjear = tableView.dequeueReusableCell(withIdentifier: "CellRecompensas_New_Canjear") as! CellRecompensas_New_Canjear
        headerCell.selectionStyle = .none
       // let strTitle = strBalance + "   Puntos Disonibles"
        
        headerCell.vBk.layer.cornerRadius = 5.0
        headerCell.vBk.layer.masksToBounds = true
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: CustomFont.semiBold, size: 29), NSAttributedString.Key.foregroundColor : UIColor(named: "App_Blue")!]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: CustomFont.regular, size: 17), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        let attributedString1 = NSMutableAttributedString(string:strBalance + " ", attributes:attrs1 as [NSAttributedString.Key : Any])
        let attributedString2 = NSMutableAttributedString(string:"   Puntos Disponibles", attributes:attrs2 as [NSAttributedString.Key : Any])
        attributedString1.append(attributedString2)
        headerCell.lblTitle.attributedText = attributedString1
                
        headerCell.btnOperation.addTarget(self, action: #selector(self.btnOperation), for: .touchUpInside)
        return headerCell
    }
    
    @objc func btnOperation(){
        self.callApiForOperations()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]
       
        let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "CellCanjearListMain", for: indexPath) as! CellCanjearListMain
        cell.selectionStyle = .none
        
        cell.vBk.layer.cornerRadius = 5.0
        cell.vBk.layer.masksToBounds = true
        
        cell.vBk_Color.backgroundColor = .clear
        cell.lblTitle.text = ""
        cell.lblSubtitle.text = ""
        cell.imgView.image = nil
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(self.eachGiftClick(btn:)), for: .touchUpInside)
        
        cell.imgView_Slice.setImageColor(color: UIColor(named: "App_LightBlack")!)
        
        if let str:String = dict["background_color"] as? String
        {
            cell.vBk_Color.backgroundColor = UIColor.colorWithHexString(str)
        }
        if let title:String = dict["gift_name"] as? String
        {
            cell.lblTitle.text = title
        }
        if let str:String = dict["gift_type_str"] as? String
        {
            cell.lblSubtitle.text = str
        }
        if let imgStr:String = dict["front_cover_url"] as? String
        {
            cell.imgView.setImageUsingUrl(imgStr)
        }

        return cell
    }
    
    @objc func eachGiftClick(btn:UIButton){
        let dict:[String:Any] = arrData[btn.tag]
        if let str:String = dict["gift_id"] as? String{
            callGetEachGift(gift_id: str)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension CanjearListVC
{
    func callGetEachGift(gift_id:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }

        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "gift_id":gift_id]
        WebService.requestService(url: ServiceName.GET_EachGiftSelectt.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let dictM:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                let vc: EachGiftSelectedVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "EachGiftSelectedVC_ID") as! EachGiftSelectedVC
                                vc.dictMain = dictM
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callApiForOperations()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        let urlStr:String = ServiceName.GET_Operations.rawValue + uuid
        
        WebService.requestService(url: urlStr, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
       //     print(jsonString)
            
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
                        
                        if let dictResp:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                let vc: OperationsVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "OperationsVC_ID") as! OperationsVC
                                
                                if let str:String = dictResp["points_balance_str"] as? String{
                                    vc.strBalance = str
                                }
                                if let arr:[[String:Any]] = dictResp["transactions"] as? [[String:Any]]{
                                    vc.arrData = arr
                                }
                                
                                vc.strTitle = "Mis Certificados"
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
