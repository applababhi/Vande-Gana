//
//  PointdetailTransactionsVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 24/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class PointdetailTransactionsVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblBalace:UILabel!
    @IBOutlet weak var lblBalaceSubHeader:UILabel!
    @IBOutlet weak var viewBk:UIView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!
    
    var balance:Int = 0
    var arrData: [[String:Any]] = []
    let altColor: UIColor = UIColor.init(red: 248.0/255.0, green: 245.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    var strBalanceSubHeader = "Del 1de Junio de 2019 al 30 de Junio de 2019"
    var isDisableDetailClickOnTap = false

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblBalaceSubHeader.text = strBalanceSubHeader
        
        setUpTopBar()
        viewBk.layer.cornerRadius = 5.0
        viewBk.layer.masksToBounds = true

        lblTitle.text = "Transacciones"
        if isDisableDetailClickOnTap == true
        {
            lblTitle.text = "Tokens"
        }
        
        var formatedCurrency = "\(balance)".toCurrencyFormat()
        formatedCurrency = formatedCurrency.components(separatedBy: ".").first!
        formatedCurrency = formatedCurrency.replacingOccurrences(of: "$", with: "")
        lblBalace.text = formatedCurrency

        tblView.estimatedRowHeight = 50
        tblView.rowHeight = UITableView.automaticDimension
        tblView.dataSource = self
        tblView.delegate = self
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        //NotificationCenter.default.post(name: Notification.Name("viewWillAppear_PointsDetailVC"), object: nil)
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

extension PointdetailTransactionsVC
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

extension PointdetailTransactionsVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // show Header for Detail 1
        let headerCell: CellPoints_Header = tableView.dequeueReusableCell(withIdentifier: "CellPoints_Header") as! CellPoints_Header
        headerCell.selectionStyle = .none
        
        headerCell.lblPoints.text = "Puntos"
        
        if isDisableDetailClickOnTap == true
        {
            // tokens
            headerCell.lblPoints.text = "Tokens"
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
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
        // show Header for Detail 1
        let cell:CellPoints_Rows = tableView.dequeueReusableCell(withIdentifier: "CellPoints_Rows", for: indexPath) as! CellPoints_Rows
        cell.selectionStyle = .none
        
        let dict:[String:Any] = arrData[indexPath.row]
        
        cell.lblFecha.text = ""
        cell.lblConcepto.text = ""
        cell.lblPuntos.text = ""
        
        if (indexPath.row % 2 == 0)
        {
            cell.contentView.backgroundColor = UIColor.white
        }
        else
        {
            cell.contentView.backgroundColor = altColor
        }
        
        if let title:String  = dict["transaction_date_str"] as? String
        {
            cell.lblFecha.text = title
        }
        if let title:String  = dict["description"] as? String
        {
            cell.lblConcepto.text = title
        }
        if let title:String  = dict["points_str"] as? String
        {
            cell.lblPuntos.text = title
        }
        
        if isDisableDetailClickOnTap == true
        {
            // tokens
            if let title:String  = dict["tokens_str"] as? String
            {
                cell.lblPuntos.text = title
            }

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isDisableDetailClickOnTap == true
        {
            return
        }
        
        let dict:[String:Any] = arrData[indexPath.row]
        
        if let type:Int  = dict["transaction_type"] as? Int
        {
            if type == 1
            {
                // look for achievement_id
                if let id:String  = dict["achievement_id"] as? String
                {
                    let vc: PointsTransactionAchievementVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "PointsTransactionAchievementVC_ID") as! PointsTransactionAchievementVC
                    vc.strAchievementID = id
                    if let str:String  = dict["description"] as? String
                    {
                        vc.strTitle = str
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalPresentationCapturesStatusBarAppearance = true
                    self.presentModal(vc: vc)
                }
            }
            else if type == 3
            {
                // look for redemption_id
                if let id:String  = dict["redemption_id"] as? String
                {
                    let vc: PointsTransactionRedemptionVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "PointsTransactionRedemptionVC_ID") as! PointsTransactionRedemptionVC
                    vc.strRedemptionID = id
                    if let str:String  = dict["description"] as? String
                    {
                        vc.strTitle = str
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalPresentationCapturesStatusBarAppearance = true
                    self.presentModal(vc: vc)
                }
            }
        }
    }
}
