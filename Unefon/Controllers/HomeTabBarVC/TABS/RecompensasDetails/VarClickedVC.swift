//
//  VarClickedVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/11/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class VarClickedVC: UIViewController{
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!
    
    var dictMain:[String:Any] = [:]
    var strTitle = ""
    var isMisPedidos = false
    var arrData:[String] = []
    var arrCollV:[[String:Any]] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        arrCollV
        
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

extension VarClickedVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let strType:String = arrData[indexPath.row]
        
        if strType == "Resumen de Solicitudes"{
            return 180
        }
        else if strType == "Descarga las Solicitudes"{
            return 100
        }
        else if strType == "Solicitudes"
        {
            var totalHeight = CGFloat(0)
            
            for dP in arrCollV
            {
                let constItemsHeight = CGFloat(90)
                var heightDesc:CGFloat = 0.0
                
                if let desc:String = dP["description"] as? String
                {
                    heightDesc = desc.height(withConstrainedWidth: 255, font: UIFont(name: CustomFont.regular, size: 16.0)!)
                }
                
                totalHeight = totalHeight + (heightDesc + constItemsHeight)
            }

            return CGFloat(50 + totalHeight)
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let strType:String = arrData[indexPath.row]
       
        if strType == "Resumen de Solicitudes"{
            let cell:CellVar = tableView.dequeueReusableCell(withIdentifier: "Resumen de Solicitudes", for: indexPath) as! CellVar
            cell.selectionStyle = .none
            cell.lbl_1.text = ""
            cell.lbl_2.text = ""
            cell.lbl_3.text = ""
            
            if let str:String = dictMain["requested_count_str"] as? String{
                cell.lbl_1.text = str
            }
            if let str:String = dictMain["delivered_count_str"] as? String{
                cell.lbl_2.text = str
            }
            if let str:String = dictMain["pending_count_str"] as? String{
                cell.lbl_3.text = str
            }

            return cell
        }
        else if strType == "Descarga las Solicitudes"{
            let cell:CellVar = tableView.dequeueReusableCell(withIdentifier: "Descarga las Solicitudes", for: indexPath) as! CellVar
            cell.selectionStyle = .none
            
            cell.btn_1.layer.cornerRadius = 22.0
            cell.btn_1.layer.masksToBounds = true
            cell.btn_2.layer.cornerRadius = 22.0
            cell.btn_2.layer.masksToBounds = true
            
            cell.btn_1.addTarget(self, action: #selector(self.pdfClick), for: .touchUpInside)
            cell.btn_2.addTarget(self, action: #selector(self.csvClick), for: .touchUpInside)

            return cell
        }
        else if strType == "Solicitudes"{
            let cell:CellVar = tableView.dequeueReusableCell(withIdentifier: "Solicitudes", for: indexPath) as! CellVar
            cell.selectionStyle = .none
            cell.selectionStyle = .none
            cell.arrData = arrCollV
            
            cell.isMisPedidos = self.isMisPedidos
            
            cell.closure = {(dictCollCell:[String:Any]) in
                
                if self.isMisPedidos == true
                {
                    if let code_id:String = dictCollCell["physical_product_request_id"] as? String
                    {
                        print("call api.....")
                        self.callGetDetailWith_1(code_id: code_id)
                    }
                }
                else
                {
                    if let code_id:String = dictCollCell["code_id"] as? String
                    {
                     //   print(dictCollCell)
                        print("call api.....", code_id)
                        self.callGetDetailWith(code_id: code_id)
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func pdfClick(){
        
        if let strURL:String = dictMain["code_requests_report_pdf"] as? String{
            if let url = URL(string: strURL) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func csvClick(){
        if let strURL:String = dictMain["code_requests_report_csv"] as? String{
            if let url = URL(string: strURL) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension VarClickedVC
{
    func callGetDetailWith(code_id:String)
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["code_id":code_id]
        WebService.requestService(url: ServiceName.GET_VarDetail_Code.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let dictM:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                let vc: VarClickDetailVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "VarClickDetailVC_ID") as! VarClickDetailVC
                                vc.dictMain = dictM
                                          
                                var check = false
                                if let acceptance_status:Bool = dictM["acceptance_status"] as? Bool
                                {
                                    check = acceptance_status
                                    vc.acceptance_status = acceptance_status
                                }
                                
                                if self.isMisPedidos == true
                                {
                                    vc.arrData = []
                                }
                                else
                                {
                                    if check == true
                                    {
                                        // no need to show hyperlink widget, rather show array of widgets
                                        vc.arrData = ["Header", "Detalles del certificado_WIDGET", "¿Cómo redimir este certificado?", "Detalles del pedido"]
                                    }
                                    else
                                    {
                                        vc.arrData = ["Header", "Detalles del certificado", "¿Cómo redimir este certificado?", "Detalles del pedido"]
                                    }
                                }
                                
                                if let arr:[[String:Any]] = dictM["widgets"] as? [[String:Any]]{
                                    vc.arrColV_Widgets = arr
                                }
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callGetDetailWith_1(code_id:String)
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["physical_product_request_id":code_id]
        WebService.requestService(url: ServiceName.GET_VarDetail_Code_1.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
      //      print(jsonString)
            
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
                                
                                let vc: VarClickDetailVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "VarClickDetailVC_ID") as! VarClickDetailVC
                                vc.dictMain = dictM
                                          
                                var check = false
                                if let acceptance_status:Bool = dictM["acceptance_status"] as? Bool
                                {
                                    check = acceptance_status
                                    vc.acceptance_status = acceptance_status
                                }
                                
                                if self.isMisPedidos == true
                                {
                                    vc.strTitle = "Producto Físico"
                                    
                                    if let arr:[[String:Any]] = dictM["widgets"] as? [[String:Any]]{
                                        if arr.count > 0
                                        {
                                            // with collV array of widgets
                                            vc.arrData = ["Header_2", "Detalles del certificado_WIDGET_2", "Detalles del producto_2", "Detalles del pedido_2"]
                                        }
                                        else{
                                            vc.arrData = ["Header_2", "Detalles del producto_2", "Detalles del pedido_2"]
                                        }
                                    }
                                    else
                                    {
                                        vc.arrData = ["Header_2", "Detalles del producto_2", "Detalles del pedido_2"]
                                    }
                                }
                                else
                                {
                                    if check == true
                                    {
                                        // no need to show hyperlink widget, rather show array of widgets
                                        vc.arrData = ["Header", "Detalles del certificado_WIDGET", "¿Cómo redimir este certificado?", "Detalles del pedido"]
                                    }
                                    else
                                    {
                                        vc.arrData = ["Header", "Detalles del certificado", "¿Cómo redimir este certificado?", "Detalles del pedido"]
                                    }
                                }
                                
                                if let arr:[[String:Any]] = dictM["widgets"] as? [[String:Any]]{
                                    vc.arrColV_Widgets = arr
                                }
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
