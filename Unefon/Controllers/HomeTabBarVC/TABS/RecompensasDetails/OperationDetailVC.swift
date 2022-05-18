//
//  OperationDetailVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/10/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class OperationDetailVC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!

    var arrData:[String] = []
    var dictMain:[String:Any] = [:]
    
    var arr_transaction_widgets:[[String:Any]] = []
    var arr_concept_widgets:[[String:Any]] = []
    var arr_table_widgets:[[String:Any]] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblHeader.text = "Detalles de la Operación"
        
        if let ar:[[String:Any]] = dictMain["transaction_widgets"] as? [[String:Any]]{
            arr_transaction_widgets = ar
            for index in 0..<ar.count{
                arrData.append("transaction_widgets" + " " + "\(index)")
            }
        }
        if let ar:[[String:Any]] = dictMain["concept_widgets"] as? [[String:Any]]{
            arr_concept_widgets = ar
            for index in 0..<ar.count{
                arrData.append("concept_widgets" + " " + "\(index)")
            }
        }
        if let ar:[[String:Any]] = dictMain["table_widgets"] as? [[String:Any]]{
            arr_table_widgets = ar
            for index in 0..<ar.count{
                arrData.append("table_widgets" + " " + "\(index)")
            }
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

extension OperationDetailVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let strType:String = arrData[indexPath.row]
        
        if strType.contains("transaction_widgets")
        {
            return UITableView.automaticDimension
        }
        else if strType.contains("concept_widgets")
        {
            return 60
        }
        else if strType.contains("table_widgets")
        {
            var count = 105
            for index in 0..<arr_table_widgets.count
            {
                let dic:[String:Any] = arr_table_widgets[index]
                if let valA:[[String:Any]] = dic["values"] as? [[String:Any]]{
                    count = count + (valA.count * 42)
                }
            }
            return CGFloat(count)
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let strType:String = arrData[indexPath.row]
       
        if strType.contains("transaction_widgets")
        {
            let index = Int(strType.components(separatedBy: " ").last!) ?? 0
            let dict:[String:Any] = arr_transaction_widgets[index]
            
            let cell:CellOperationDetails = tableView.dequeueReusableCell(withIdentifier: "transaction_widgets", for: indexPath) as! CellOperationDetails
            cell.selectionStyle = .none
            
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.lblTitle_1.text = ""
            cell.lblTitle_2.text = ""
            cell.lblSubTitle_1.text = ""
            cell.lblSubTitle_2.text = ""
            
            if let str:String = dict["title"] as? String{
                cell.lblTitle_1.text = str
            }
            if let str:String = dict["value"] as? String{
                cell.lblTitle_2.text = str
                if let col:String = dict["value_color"] as? String{
                    cell.lblTitle_2.textColor = UIColor.colorWithHexString(col)
                }
            }
            if let str:String = dict["description"] as? String{
                cell.lblSubTitle_1.text = str
            }
            if let str:String = dict["value_description"] as? String{
                cell.lblSubTitle_2.text = str
            }
            
            return cell
        }
        else if strType.contains("concept_widgets")
        {
            let index = Int(strType.components(separatedBy: " ").last!) ?? 0
            let dict:[String:Any] = arr_concept_widgets[index]
            
            let cell:CellOperationDetails = tableView.dequeueReusableCell(withIdentifier: "concept_widgets", for: indexPath) as! CellOperationDetails
            cell.selectionStyle = .none
            
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.lblTitle_1.text = ""
            cell.lblTitle_2.text = ""
            
            if let str:String = dict["description"] as? String{
                cell.lblTitle_1.text = str
            }
            if let str:String = dict["value"] as? String{
                cell.lblTitle_2.text = str
                if let col:String = dict["value_color"] as? String{
                    cell.lblTitle_2.textColor = UIColor.colorWithHexString(col)
                }
            }
            
            return cell
        }
        else if strType.contains("table_widgets")
        {
            let index = Int(strType.components(separatedBy: " ").last!) ?? 0
            let dict:[String:Any] = arr_table_widgets[index]
            
            let cell:CellOperationDetails = tableView.dequeueReusableCell(withIdentifier: "table_widgets", for: indexPath) as! CellOperationDetails
            cell.selectionStyle = .none
            
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.lblTitle_1.text = ""
            cell.lblSubTitle_1.text = ""
            cell.lblSubTitle_2.text = ""
            
            if let str:String = dict["title"] as? String{
                cell.lblTitle_1.text = str
            }
            if let str:String = dict["header_title_1"] as? String{
                cell.lblSubTitle_1.text = str
            }
            if let str:String = dict["header_title_2"] as? String{
                cell.lblSubTitle_2.text = str
            }
            
            if let arr:[[String:Any]] = dict["values"] as? [[String:Any]]{
                cell.arrData = arr
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}
