//
//  PointsDetailMonthListVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 24/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class PointsDetailMonthListVC: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrData: [[String:Any]] = []
    let altColor: UIColor = UIColor.init(red: 248.0/255.0, green: 245.0/255.0, blue: 248.0/255.0, alpha: 1.0)


    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblTitle.text = "Ventas pos Mes"
        tblView.dataSource = self
        tblView.delegate = self
    }

    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_PointsDetailVC"), object: nil)
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

extension PointsDetailMonthListVC
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

extension PointsDetailMonthListVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // show Header for Detail 2
        let headerCell: CellPoints_Header_Detail2 = tableView.dequeueReusableCell(withIdentifier: "CellPoints_Header_Detail2") as! CellPoints_Header_Detail2
        headerCell.selectionStyle = .none
        
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // show Header for Detail 2
        let dict:[String:Any] = arrData[indexPath.row]
        let cell:CellPoints_Rows_Detail2 = tableView.dequeueReusableCell(withIdentifier: "CellPoints_Rows_Detail2", for: indexPath) as! CellPoints_Rows_Detail2
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        
        cell.btnDetail.tag = indexPath.row
        cell.btnDetail.layer.cornerRadius = 5.0
        cell.btnDetail.layer.masksToBounds = true
        
        if (indexPath.row % 2 == 0)
        {
            cell.contentView.backgroundColor = UIColor.white
        }
        else
        {
            cell.contentView.backgroundColor = altColor
        }
        
        if let month:String = dict["month_str"] as? String
        {
            if let year:Int = dict["year"] as? Int
            {
                cell.lblTitle.text = month + " \(year)"
            }
        }
        
        cell.btnDetail.addTarget(self, action: #selector(self.btnViewDetailsClick(btn:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    @objc func btnViewDetailsClick(btn:UIButton)
    {
        let dict:[String:Any] = arrData[btn.tag]
        if let arr: [[String:Any]] = dict["actions"] as? [[String:Any]]
        {
            let vc: PointsMonthDetailVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "PointsMonthDetailVC_ID") as! PointsMonthDetailVC
            vc.arrData = arr
            if let month:String = dict["month_str"] as? String
            {
                vc.strMonth = month
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }

    }
}
