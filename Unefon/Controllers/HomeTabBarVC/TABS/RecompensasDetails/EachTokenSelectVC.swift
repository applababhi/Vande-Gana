//
//  EachTokenSelectVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/10/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class EachTokenSelectVC: UIViewController  {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!
    
    var dictMain:[String:Any] = [:]
    var price = 0
    var quantity = 0
    var cost = 0
    var isContinueEnable = false
    
//    let arrData:[String] = ["Header", "Detalles del certificado", "¿De qué denominación deseas adquirir certificados?", "¿Cuántos certificados deseas adquirir?", "Resumen de la Operación a Realizar", "Continue"]
    
    let arrData:[String] = ["Header", "Detalles del Producto", "¿Cuántos procutos deseas adquirir?", "Resumen de la Operación a Realizar", "Continue"]

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblHeader.text = "Certificado de Regalo"
        hideKeyboardWhenTappedAround()
        
        if let strV:Int = dictMain["price"] as? Int{
            price = strV
        }
        
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

extension EachTokenSelectVC: UITableViewDataSource, UITableViewDelegate
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
        else if strType == "Detalles del Producto"{
            return 260
        }
        else if strType == "¿Cuántos procutos deseas adquirir?"{
            return 127
        }
        else if strType == "Resumen de la Operación a Realizar"{
            return 217
        }
        else if strType == "Continue"{
            return 50
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let strType:String = arrData[indexPath.row]
       
        if strType == "Header"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.imgView.image = nil
            cell.imgView.layer.cornerRadius = 25.0
            cell.imgView.layer.borderWidth = 1.5
            cell.imgView.layer.borderColor = UIColor.white.cgColor
            cell.imgView.layer.masksToBounds = true
            
            cell.lblTitle.text = ""
            
            if let imgStr:String = dictMain["cover_url"] as? String
            {
                cell.imgView.setImageUsingUrl(imgStr)
            }
            if let str:String = dictMain["product_name"] as? String
            {
                cell.lblTitle.text = str
            }
            
            return cell
        }
        else if strType ==  "Detalles del Producto"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Detalles del Producto", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.lbl1.text = ""
            cell.lbl2.text = ""
            cell.lbl3.text = ""
            cell.lbl4.text = ""
            
            if let str:String = dictMain["product_description"] as? String
            {
                cell.lbl1.text = str
            }
            if let str:String = dictMain["product_characteristics"] as? String
            {
                cell.lbl2.text = str
            }
            if let str:String = dictMain["product_sku"] as? String
            {
                cell.lbl3.text = str
            }
            if let str:String = dictMain["price_str"] as? String
            {
                cell.lbl4.text = str
            }
            return cell
        }
        else if strType == "¿Cuántos procutos deseas adquirir?"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "¿Cuántos procutos deseas adquirir?", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            cell.tf.delegate = self
            //number
            
            if quantity == 0 {
                cell.tf.text = ""
                cell.tf.placeholder = "0"
            }else{
                cell.tf.text = "\(quantity)"
            }
                        
            cell.inCellAddPaddingTo(TextField: cell.tf, imageName: "")
            cell.tf.layer.cornerRadius = 5.0
            cell.tf.layer.borderColor = UIColor.white.cgColor
            cell.tf.layer.borderWidth = 1.0
            cell.tf.layer.masksToBounds = true

            return cell
        }
        else if strType == "Resumen de la Operación a Realizar"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Resumen de la Operación a Realizar", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            cell.selectionStyle = .none
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.lblTitle.text = ""
            cell.lblSubtitle.text = ""
            cell.lblStatus.text = ""
            
            if let str:String = dictMain["tokens_balance_str"] as? String
            {
                cell.lblTitle.text = str
            }
            
            cell.lblSubtitle.text = "\(cost)" + " tokens"
            
            if let balance:Int = dictMain["tokens_balance"] as? Int
            {
                if cost <= balance{
                    cell.lblStatus.text = "Puedes Realizar el Pedido"
                    cell.lblStatus.textColor = UIColor.colorWithHexString("#84EE51")
                    isContinueEnable = true
                  //  tblView.reloadData()
                }
                else{
                    cell.lblStatus.text = "Tu Saldo es Menor al Costo del Pedido"
                    cell.lblStatus.textColor = UIColor.colorWithHexString("#EC2243")
                    isContinueEnable = false
                  //  tblView.reloadData()
                }
            }

            return cell
        }
        else if strType == "Continue"{
            let cell:CellCanjearListMain = tableView.dequeueReusableCell(withIdentifier: "Continue", for: indexPath) as! CellCanjearListMain
            cell.selectionStyle = .none
            
            cell.btn.layer.cornerRadius = 18.0
            cell.btn.layer.borderWidth = 1.0
            cell.btn.layer.masksToBounds = true

            cell.btn.addTarget(self, action: #selector(self.btnContinueClick(btn:)), for: .touchUpInside)
            
            if isContinueEnable == true{
                cell.btn.isEnabled = true
                cell.btn.setTitleColor(UIColor(named: "App_Blue")!, for: .normal)
                cell.btn.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
            }
            else{
                cell.btn.isEnabled = false
                cell.btn.setTitleColor(.lightGray, for: .normal)
                cell.btn.layer.borderColor = UIColor.lightGray.cgColor
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func btnContinueClick(btn:UIButton){
        callPOSTProductRequest()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension EachTokenSelectVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("- - - - - - -  DO CALCULATION  .... .... ")
        quantity = Int(textField.text!) ?? 0
        if price > 0{
            cost = quantity * price
            print("COST..... ....  ... ", cost)
        }
        tblView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tblView.reloadData()
        textField.resignFirstResponder()
        return true
    }
}

extension EachTokenSelectVC
{
    func callPOSTProductRequest()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        var product_sku = ""
        if let str:String = dictMain["product_sku"] as? String
        {
            product_sku = str
        }

        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "product_sku":product_sku, "quantity":quantity]
        WebService.requestService(url: ServiceName.POST_PhysicalProductPreview.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                                let vc: EachTokenDetailVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "EachTokenDetailVC_ID") as! EachTokenDetailVC
                                vc.dictMain = dictM
                                vc.product_sku = product_sku
                                
                                if let str:String = self.dictMain["product_characteristics"] as? String{
                                    vc.product_characteristics = str
                                }
                                if let str:String = self.dictMain["product_description"] as? String{
                                    vc.product_description = str
                                }
                                if let str:String = self.dictMain["tokens_balance_str"] as? String{
                                    vc.tokens_balance_str = str
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
