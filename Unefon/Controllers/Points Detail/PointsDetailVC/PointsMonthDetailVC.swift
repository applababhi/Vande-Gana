//
//  PointsMonthDetailVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 24/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class PointsMonthDetailVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrData: [[String:Any]] = []
    var strMonth = ""
    let altColor: UIColor = UIColor.init(red: 248.0/255.0, green: 245.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblTitle.text = strMonth
        tblView.estimatedRowHeight = 50
        tblView.rowHeight = UITableView.automaticDimension
        tblView.dataSource = self
        tblView.delegate = self
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

extension PointsMonthDetailVC
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

extension PointsMonthDetailVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // show Header for Detail 1
        let headerCell: CellPoints_Header = tableView.dequeueReusableCell(withIdentifier: "CellPoints_Header") as! CellPoints_Header
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
     //   cell.lblPuntos.text = ""
        
        if (indexPath.row % 2 == 0)
        {
            cell.contentView.backgroundColor = UIColor.white
        }
        else
        {
            cell.contentView.backgroundColor = altColor
        }
        
        if let title:String  = dict["date_str"] as? String
        {
            cell.lblFecha.text = title
        }
        if let title:String  = dict["description"] as? String
        {
            cell.lblConcepto.text = title
        }
        if let title:String  = dict["obtained_points_str"] as? String
        {
          //  cell.lblPuntos.text = title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
}
