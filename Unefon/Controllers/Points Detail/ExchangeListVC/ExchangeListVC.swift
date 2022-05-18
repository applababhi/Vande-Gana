//
//  ExchangeListVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 3/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ExchangeListVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrData: [[String:Any]] = [["title": "CANJEAR MIS PUNTOS EN LA TIENDA DE REGALOS", "id":1], ["title": "CANJEAR MIS TOKENS POR MATERIAL VISIBILITY", "id":2]]
    
 //   var arrData: [[String:Any]] = [["title": "CANJEAR MIS PUNTOS EN LA TIENDA DE REGALOS", "id":1]]

    
    var check_From_PointsDetailVC_ForNotfCenter = false
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblTitle.text = "Canjear"
        
        tblView.dataSource = self
        tblView.delegate = self
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        if check_From_PointsDetailVC_ForNotfCenter == true
        {
            // back top pointsDetail
            NotificationCenter.default.post(name: Notification.Name("viewWillAppear_PointsDetailVC"), object: nil)
        }
        else
        {
            // back to Dashboard
            NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        }
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

extension ExchangeListVC
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

extension ExchangeListVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellExchange_Rows = tableView.dequeueReusableCell(withIdentifier: "CellExchange_Rows", for: indexPath) as! CellExchange_Rows
        cell.selectionStyle = .none
        
        cell.imgView.contentMode = .center
        let dict:[String:Any] = arrData[indexPath.row]
        
        cell.lblTitle.text = ""
        cell.viewBk.layer.cornerRadius = 10.0
        cell.viewBk.layer.borderWidth = 1.5
        cell.viewBk.layer.masksToBounds = true
        
        if indexPath.row == 0
        {
            cell.imgView.image = UIImage(named: "cards")
        }
        else
        {
            cell.imgView.image = UIImage(named: "tent")
        }
        
        cell.imgView.setImageColor(color: k_baseColor)

      //  cell.imgView.layer.cornerRadius = 30.0
      //  cell.imgView.layer.borderWidth = 0.5
      //  cell.imgView.layer.masksToBounds = true
        
        if let title:String = dict["title"] as? String
        {
            cell.lblTitle.text = title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrData[indexPath.row]

        if let idClick:Int = dict["id"] as? Int
        {
            if idClick == 1
            {
                let vc: ExchangeDetailVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "ExchangeDetailVC_ID") as! ExchangeDetailVC
                vc.modalTransitionStyle = .crossDissolve
                if let title:String = dict["title"] as? String
                {
                    vc.strTitle = title
                }
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.present(vc, animated: true, completion: nil)
            }
            else if idClick == 2
            {
                // Physical Products
                let vc: ConsiderationsListVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "ConsiderationsListVC_ID") as! ConsiderationsListVC
                vc.modalTransitionStyle = .crossDissolve
                if let title:String = dict["title"] as? String
                {
                    vc.strTitle = title
                }
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
