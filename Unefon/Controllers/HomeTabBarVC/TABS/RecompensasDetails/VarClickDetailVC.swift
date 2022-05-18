//
//  VarClickDetailVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/11/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class VarClickDetailVC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!
    
    var acceptance_status = false
    var dictMain:[String:Any] = [:]
    var arrData:[String] = [] // Header, (Detalles del certificado_WIDGET || Detalles del certificado), ¿Cómo redimir este certificado?, Detalles del pedido
    
    var arrColV_Widgets:[[String:Any]] = []
    var privacy = ""
    var terms = ""
    var strTitle = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let str:String = dictMain["privacy_advice_url"] as? String
        {
            privacy = str
        }
        if let str:String = dictMain["terms_conditions_url"] as? String
        {
            terms = str
        }
        
        setUpTopBar()
        lblHeader.text = (strTitle.isEmpty) ? "Certificado de Regalo" : strTitle
        
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

extension VarClickDetailVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let strType:String = arrData[indexPath.row]
       
        if strType == "Header"{
            return 65
        }
        else if strType == "Detalles del certificado"{
            return 195
        }
        else if strType == "Detalles del certificado_WIDGET"{
            return CGFloat(40 + (arrColV_Widgets.count * 72)) // collV array
        }
        else if strType == "¿Cómo redimir este certificado?"{
            return UITableView.automaticDimension
        }
        else if strType == "Detalles del pedido"{
            return 315
        }
        else if strType == "Header_2"{
            return 65
        }
        else if strType == "Detalles del certificado_WIDGET_2"{
            return CGFloat(40 + (arrColV_Widgets.count * 72)) // collV array
        }
        else if strType == "Detalles del pedido_2"{
            return UITableView.automaticDimension
        }
        else if strType == "Detalles del producto_2"{
            return UITableView.automaticDimension
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let strType:String = arrData[indexPath.row]
        
        if strType == "Header_2"{
            let cell:CellVarDetail = tableView.dequeueReusableCell(withIdentifier: "Header_2", for: indexPath) as! CellVarDetail
            cell.selectionStyle = .none

            cell.imgView.image = nil
            cell.imgView.layer.cornerRadius = 25.0
            cell.imgView.layer.borderWidth = 1.5
            cell.imgView.layer.borderColor = UIColor.white.cgColor
            cell.imgView.layer.masksToBounds = true
            
            cell.lbl_1.text = ""
            
            if let imgStr:String = dictMain["cover_url"] as? String
            {
                cell.imgView.setImageUsingUrl(imgStr)
            }
            if let str:String = dictMain["product_name"] as? String
            {
                cell.lbl_1.text = str
            }

            return cell
        }
        else if strType == "Detalles del certificado_WIDGET_2"{
            let cell:CellVarDetail = tableView.dequeueReusableCell(withIdentifier: "Detalles del certificado_WIDGET_2", for: indexPath) as! CellVarDetail
            cell.selectionStyle = .none
            
            cell.arrData = arrColV_Widgets
                        
            return cell
        }
        else if strType == "Detalles del producto_2"{
            let cell:CellVarDetail = tableView.dequeueReusableCell(withIdentifier: "Detalles del producto_2", for: indexPath) as! CellVarDetail
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.lbl_1.text = ""
            cell.lbl_2.text = ""
            cell.lbl_3.text = ""
            cell.lbl_4.text = ""
            
            if let str:String = dictMain["product_name"] as? String
            {
                cell.lbl_1.text = str
            }
            if let str:String = dictMain["brand"] as? String
            {
                cell.lbl_2.text = str
            }
            if let str:String = dictMain["price_str"] as? String
            {
                cell.lbl_3.text = str
            }
            if let str:String = dictMain["product_description"] as? String
            {
                cell.lbl_4.text = str
            }
            return cell
        }
        else if strType == "Detalles del pedido_2"{
            let cell:CellVarDetail = tableView.dequeueReusableCell(withIdentifier: "Detalles del pedido_2", for: indexPath) as! CellVarDetail
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.lbl_1.text = ""
            cell.lbl_2.text = ""
            cell.lbl_3.text = ""
            cell.lbl_4.text = ""
            
            if let str:String = dictMain["request_date_str"] as? String
            {
                cell.lbl_1.text = str
            }
            if let str:String = dictMain["delivery_date_str"] as? String
            {
                cell.lbl_2.text = str
            }
            if let str:String = dictMain["status_str"] as? String
            {
                cell.lbl_3.text = str
            }
            if let str:String = dictMain["full_address"] as? String
            {
                cell.lbl_4.text = str
            }
            return cell
        }
        else if strType == "Header"{
            let cell:CellVarDetail = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! CellVarDetail
            cell.selectionStyle = .none

            cell.imgView.image = nil
            cell.imgView.layer.cornerRadius = 25.0
            cell.imgView.layer.borderWidth = 1.5
            cell.imgView.layer.borderColor = UIColor.white.cgColor
            cell.imgView.layer.masksToBounds = true
            
            cell.lbl_1.text = ""
            
            if let imgStr:String = dictMain["front_cover_url"] as? String
            {
                cell.imgView.setImageUsingUrl(imgStr)
            }
            if let str:String = dictMain["gift_name"] as? String
            {
                cell.lbl_1.text = str
            }

            return cell
        }
        else if strType == "Detalles del certificado"{
            let cell:CellVarDetail = tableView.dequeueReusableCell(withIdentifier: "Detalles del certificado", for: indexPath) as! CellVarDetail
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.txtView.text = ""
            
            let tu = "Términos y Condiciones del Servicio"
            let pp = "Aviso de Privacidad."
            cell.txtView.text = "Al hacer click e “Mostrar Certificado” acepto que he leído y estoy de acuerdo con los \(tu) así como con el \(pp)"
            cell.txtView.addLinks([
                tu: self.terms,
                pp: self.privacy
            ])
            cell.txtView.onLinkTap = { url in
                print("url: \(url)")
                return true
            }
            
            cell.btn.layer.cornerRadius = 20.0
            cell.btn.layer.borderWidth = 1.5
            cell.btn.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
            cell.btn.layer.masksToBounds = true
            cell.btn.addTarget(self, action: #selector(self.btnMostrarClick), for: .touchUpInside)
            
            return cell
        }
        else if strType == "Detalles del certificado_WIDGET"{
            let cell:CellVarDetail = tableView.dequeueReusableCell(withIdentifier: "Detalles del certificado_WIDGET", for: indexPath) as! CellVarDetail
            cell.selectionStyle = .none
            
            cell.arrData = arrColV_Widgets
                        
            return cell
        }
        else if strType == "¿Cómo redimir este certificado?"{
            let cell:CellVarDetail = tableView.dequeueReusableCell(withIdentifier: "¿Cómo redimir este certificado?", for: indexPath) as! CellVarDetail
            cell.selectionStyle = .none
            cell.lbl_1.text = ""
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true

            if let str:String = dictMain["instuctions"] as? String
            {
                cell.lbl_1.text = str
            }
            return cell
        }
        else if strType == "Detalles del pedido"{
            let cell:CellVarDetail = tableView.dequeueReusableCell(withIdentifier: "Detalles del pedido", for: indexPath) as! CellVarDetail
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.lbl_1.text = ""
            cell.lbl_2.text = ""
            cell.lbl_3.text = ""
            cell.lbl_4.text = ""
            cell.lbl_5.text = ""
            
            if let str:String = dictMain["request_date_str"] as? String
            {
                cell.lbl_1.text = str
            }
            if let str:String = dictMain["delivery_date_str"] as? String
            {
                cell.lbl_2.text = str
            }
            if let str:String = dictMain["brand"] as? String
            {
                cell.lbl_3.text = str
            }
            if let str:String = dictMain["gift_name"] as? String
            {
                cell.lbl_4.text = str
            }
            if let str:String = dictMain["denomination_str"] as? String
            {
                cell.lbl_5.text = str
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}        
    
    @objc func btnMostrarClick(){
        
        if let code:String = dictMain["code_id"] as? String{
            callGetTC(param: ["code_id":code])
        }
    }
}

extension VarClickDetailVC
{
    func callGetTC(param: [String:Any])
    {
        self.showSpinnerWith(title: "Cargando...")
        
        WebService.requestService(url: ServiceName.PUT_AcceptTermsWalletGift.rawValue, method: .put, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let _:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                self.acceptance_status = true
                                self.arrData = ["Header", "Detalles del certificado_WIDGET", "¿Cómo redimir este certificado?", "Detalles del pedido"]
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func back(){
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
