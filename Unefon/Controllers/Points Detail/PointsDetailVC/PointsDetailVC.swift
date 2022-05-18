//
//  PointsDetailVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 2/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class PointsDetailVC: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    
    var dictMain: [String:Any] = [:]
    var dPointsWidget: [String:Any] = [:]
    var dPointsHeader: [String:Any] = [:]
    var balance:Int = 0
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!
    
    deinit {
            NotificationCenter.default.removeObserver(self)
        }

    @objc func callViewWillAppearios13(notfication: NSNotification) {
            self.viewWillAppear(true)
        }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.callViewWillAppearios13(notfication:)), name: Notification.Name("viewWillAppear_PointsDetailVC"), object: nil)
        
        setUpTopBar()
        lblTitle.text = "Mis puntos"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetPointsDetail()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
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

extension PointsDetailVC
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

extension PointsDetailVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 160
        }
        else
        {
            // points widget
            return 420
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell:CellPointsDetail_Header = tableView.dequeueReusableCell(withIdentifier: "CellPointsDetail_Header", for: indexPath) as! CellPointsDetail_Header
            cell.selectionStyle = .none
            
            cell.viewBk.layer.cornerRadius = 5.0
            cell.viewBk.layer.masksToBounds = true
            cell.btnDetails.layer.cornerRadius = 5.0
            cell.btnDetails.layer.masksToBounds = true
            cell.btnExchange.layer.cornerRadius = 5.0
            cell.btnExchange.layer.masksToBounds = true
            cell.lblTitle.text = ""
            cell.lblMessage.text = ""
            cell.btnDetails.addTarget(self, action: #selector(self.btnDetailsHeaderClick(btn:)), for: .touchUpInside)
            cell.btnExchange.addTarget(self, action: #selector(self.btnExchangeHeaderClick(btn:)), for: .touchUpInside)

            if let str:Int = dPointsHeader["balance"] as? Int
            {
                var formatedCurrency = "\(str)".toCurrencyFormat()
                formatedCurrency = formatedCurrency.components(separatedBy: ".").first!
                formatedCurrency = formatedCurrency.replacingOccurrences(of: "$", with: "")
                cell.lblTitle.text = formatedCurrency
            }
            
            cell.lblMessage.text = "Puntos Disponibles para Canjear"
            return cell
        }
        else
        {
            // points Widget
            let cell:CellMain_Points = tblView.dequeueReusableCell(withIdentifier: "CellMain_Points", for: indexPath) as! CellMain_Points
            cell.selectionStyle = .none
            
            cell.viewBk.layer.cornerRadius = 5.0
            cell.viewBk.layer.masksToBounds = true
            cell.btnDetails.layer.cornerRadius = 5.0
            cell.btnDetails.layer.masksToBounds = true
            
            cell.btnDetails.addTarget(self, action: #selector(self.btnDetailsBottomClick(btn:)), for: .touchUpInside)
            
            cell.lblTitle.text = ""
            cell.lblMessage.text = ""
            cell.lblMonthlyFee.text = ""
            cell.lblScope.text = ""
            cell.lblActivation.text = ""
            cell.lblPoints.text = ""
            
            if let str:String = dPointsWidget["period"] as? String
            {
                cell.lblTitle.text = str
            }
            if let str:String = dPointsWidget["message"] as? String
            {
                cell.lblMessage.text = str
            }
            if let str:String = dPointsWidget["kpis_str"] as? String
            {
                cell.lblMonthlyFee.text = str
            }
            if let str:String = dPointsWidget["performance_str"] as? String
            {
                cell.lblScope.text = str
            }
            if let str:String = dPointsWidget["user_registered_sales_quantity_str"] as? String
            {
                cell.lblActivation.text = str
            }
            if let str:String = dPointsWidget["user_registered_sales_points_str"] as? String
            {
                cell.lblPoints.text = str
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    @objc func btnDetailsBottomClick(btn:UIButton)
    {
        print("Take to View History Module")
        
        let vc: HistoricalVC = AppStoryBoards.Dashboard.instance.instantiateViewController(withIdentifier: "HistoricalVC_ID") as! HistoricalVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.presentModal(vc: vc)
    }
    
    @objc func btnDetailsHeaderClick(btn:UIButton)
    {
        if let arr: [[String:Any]] = dictMain["transactions"] as? [[String:Any]]
        {
            let vc: PointdetailTransactionsVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "PointdetailTransactionsVC_ID") as! PointdetailTransactionsVC
            vc.arrData = arr
            vc.balance = self.balance
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
    }
    
    @objc func btnExchangeHeaderClick(btn:UIButton)
    {
        let vc: ExchangeListVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "ExchangeListVC_ID") as! ExchangeListVC
        vc.check_From_PointsDetailVC_ForNotfCenter = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.presentModal(vc: vc)
    }
}

extension PointsDetailVC
{
    func callGetPointsDetail()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_PointsDetail.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                            self.dictMain = dict
                            if let bal: Int = dict["balance"] as? Int
                            {
                                self.dPointsHeader["balance"] = bal
                                self.balance = bal
                            }
                            
                            
                            if let str: String = dict["kpis_str"] as? String
                            {
                                self.dPointsWidget["kpis_str"] = str
                                
                                if let str1: String = dict["performance_str"] as? String
                                {
                                    self.dPointsWidget["performance_str"] = str1
                                }
                                if let str2: String = dict["user_registered_sales_quantity_str"] as? String
                                {
                                    self.dPointsWidget["user_registered_sales_quantity_str"] = str2
                                }
                                if let str3: String = dict["user_registered_sales_points_str"] as? String
                                {
                                    self.dPointsWidget["user_registered_sales_points_str"] = str3
                                }
                                if let str4: String = dict["message"] as? String
                                {
                                    self.dPointsWidget["message"] = str4
                                }
                                if let str5: String = dict["period"] as? String
                                {
                                    self.dPointsWidget["period"] = str5
                                }
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
