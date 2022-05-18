//
//  PointsTransactionAchievementVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 25/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class PointsTransactionAchievementVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
  //  @IBOutlet weak var lblDate:UILabel!
  //  @IBOutlet weak var lblSoldProduct:UILabel!
  //  @IBOutlet weak var lblEarnedPoints:UILabel!
    @IBOutlet weak var tblView_Header: UITableView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_vTblHeader_Ht:NSLayoutConstraint!

    var strTitle = ""
    var strAchievementID = ""
    var arrData: [[String:Any]] = []
    var arrData_TopTable: [String] = []
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblTitle.text = strTitle
   //     self.tblView_Header.isScrollEnabled = false
        
        callGetSales()
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

extension PointsTransactionAchievementVC
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

extension PointsTransactionAchievementVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if tableView == tblView_Header
        {
            return nil
        }
        // show Header for Detail 1
        let headerCell: CellPoints_Header = tableView.dequeueReusableCell(withIdentifier: "CellPoints_Header") as! CellPoints_Header
        headerCell.selectionStyle = .none
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblView_Header
        {
            return 0
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblView_Header
        {
            return arrData_TopTable.count
        }
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblView_Header
        {
            let stri = self.arrData_TopTable[indexPath.row]
            
            let ht = stri.height(withConstrainedWidth: self.tblView_Header.frame.size.width, font: UIFont(name: CustomFont.semiBold, size: 16.0)!)
            
            if stri == " "
            {
                return 25
            }
            else
            {
                return ht + 5
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblView_Header
        {
            let cell:Cell_PointsAchievement_HeaderRow = tblView_Header.dequeueReusableCell(withIdentifier: "Cell_PointsAchievement_HeaderRow", for: indexPath) as! Cell_PointsAchievement_HeaderRow
            cell.selectionStyle = .none
            cell.lblTitlte.text = ""
            let str:String = arrData_TopTable[indexPath.row]
            cell.lblTitlte.text = str
            return cell
        }
        else
        {
            // Bottom Table
            // show Header for Detail 1
            let cell:CellPoints_Rows = tableView.dequeueReusableCell(withIdentifier: "CellPoints_Rows", for: indexPath) as! CellPoints_Rows
            cell.selectionStyle = .none
            
            let dict:[String:Any] = arrData[indexPath.row]
            
            cell.lblFecha.text = ""
            cell.lblConcepto.text = ""
            cell.lblPuntos.text = ""
            
            if let title:String  = dict["sale_date_str"] as? String
            {
                cell.lblFecha.text = title
            }
            if let title:String  = dict["sku"] as? String
            {
                cell.lblConcepto.text = title
            }
            if let title:String  = dict["quantity_str"] as? String
            {
                cell.lblPuntos.text = title
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {    }
}

extension PointsTransactionAchievementVC
{
    func callGetSales()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["achievement_id":strAchievementID]
        WebService.requestService(url: ServiceName.GET_TransactionSales.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        self.arrData_TopTable.removeAll()
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let d:[String:Any] = dict["achievement"] as? [String:Any]
                            {
                                DispatchQueue.main.async {
                                    
                                    if let date:String = d["creation_date_str"] as? String
                                    {
                                        self.arrData_TopTable.append("Fecha de cálculo: " + date)
                                    }
                                    if let str:String = d["period_description"] as? String
                                    {
                                        self.arrData_TopTable.append("Periodo Analizado: \(str)")
                                    }
                                    if let str:String = d["general_minimum_sales_str"] as? String
                                    {
                                        self.arrData_TopTable.append("Cuota UNEFON: \(str)")
                                    }
                                    if let str:Int = d["total_sold_products"] as? Int
                                    {
                                        self.arrData_TopTable.append("Unidades Vendidas: \(str)")
                                    }
                                    if let str:String = d["performance_str"] as? String
                                    {
                                        self.arrData_TopTable.append("Alcance Cuota UNEFON: \(str)")
                                    }
                                    
                                    if let check:Int = d["has_att_kpi"] as? Int
                                    {
                                        if check == 1
                                        {
                                            self.arrData_TopTable.append(" ")
                                            self.arrData_TopTable.append("Aplicó Objectivo AT&T: Sí")
                                        }
                                        
                                        if let str:String = d["att_metric_name"] as? String
                                        {
                                            self.arrData_TopTable.append("Objectivo: \(str)")
                                        }
                                        if let str:String = d["att_result_description"] as? String
                                        {
                                            self.arrData_TopTable.append("Resultado AT&T: \(str)")
                                        }
                                    }
                                    
                                    var heightOfTopTbl:CGFloat = 0.0
                                    
                                    for stri in self.arrData_TopTable
                                    {
                                        let ht = stri.height(withConstrainedWidth: self.tblView_Header.frame.size.width, font: UIFont(name: CustomFont.semiBold, size: 16.0)!)
                                        
                                        if stri == " "
                                        {
                                            heightOfTopTbl = heightOfTopTbl + 25
                                        }
                                        else
                                        {
                                            heightOfTopTbl = heightOfTopTbl + ht + 6
                                        }
                                    }
                                    
                                    self.c_vTblHeader_Ht.constant = heightOfTopTbl// CGFloat(self.arrData_TopTable.count * 35)
                                    
                                    if self.tblView_Header.delegate == nil
                                    {
                                        self.tblView_Header.delegate = self
                                        self.tblView_Header.dataSource = self
                                    }
                                    self.tblView_Header.reloadData()
                                }
                            }
                            if let arrDict: [[String:Any]] = dict["sales"] as? [[String:Any]]
                            {
                                self.arrData = arrDict
                            }
                            
                            DispatchQueue.main.async {
                                
                                if self.tblView.delegate == nil
                                {
                                    self.tblView.delegate = self
                                    self.tblView.dataSource = self
                                }
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}
