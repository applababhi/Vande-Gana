//
//  ConsiderationsListVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 23/9/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ConsiderationsListVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnTienda:UIButton!
    @IBOutlet weak var btnMyOrder:UIButton!
    @IBOutlet weak var viewTiendaLine:UIView!
    @IBOutlet weak var viewMyOrderLine:UIView!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrData: [[String:Any]] = []
    var strTitle:String = ""
    var strSelectedView:String = ""
    
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

        NotificationCenter.default.addObserver(self, selector: #selector(self.callViewWillAppearios13(notfication:)), name: Notification.Name("viewWillAppear_PhysicalProductList"), object: nil)

        setUpTopBar()
        lblTitle.text = strTitle
        
        btnTienda.setTitleColor(k_baseColor, for: .normal)
        viewTiendaLine.backgroundColor = k_baseColor
        btnMyOrder.setTitleColor(UIColor.lightGray, for: .normal)
        viewMyOrderLine.backgroundColor = UIColor.lightGray
        
        strSelectedView = "Store"
    }
        
    override func viewWillAppear(_ animated: Bool) {
        callGetPhysicalProducts(serviceName: strSelectedView)
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tiendaClick(btn:UIButton)
    {
        strSelectedView = "Store"
        callGetPhysicalProducts(serviceName: "Store")
        btnTienda.setTitleColor(k_baseColor, for: .normal)
        viewTiendaLine.backgroundColor = k_baseColor
        btnMyOrder.setTitleColor(UIColor.lightGray, for: .normal)
        viewMyOrderLine.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func myOrderClick(btn:UIButton)
    {
        strSelectedView = "MyOrder"
        callGetPhysicalProducts(serviceName: "MyOrder")
        btnMyOrder.setTitleColor(k_baseColor, for: .normal)
        viewMyOrderLine.backgroundColor = k_baseColor
        btnTienda.setTitleColor(UIColor.lightGray, for: .normal)
        viewTiendaLine.backgroundColor = UIColor.lightGray
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

extension ConsiderationsListVC
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

extension ConsiderationsListVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellConsideration_List = tableView.dequeueReusableCell(withIdentifier: "CellConsideration_List", for: indexPath) as! CellConsideration_List
        cell.selectionStyle = .none
        
        let dict:[String:Any] = arrData[indexPath.row]
        
        cell.lblTitle.text = ""
        cell.lblSubTitle1.text = ""
        cell.lblSubTitle2.text = ""
        
        cell.viewBk.layer.cornerRadius = 5.0
        cell.viewBk.layer.borderWidth = 0.7
        cell.viewBk.layer.borderColor = UIColor.lightGray.cgColor
        cell.viewBk.layer.masksToBounds = true
                
        if strSelectedView == "Store"
        {
            if let dStore:[String:Any] = dict["physical_product"] as? [String:Any]
            {
                if let title:String = dStore["product_name"] as? String
                {
                    cell.lblTitle.text = title
                }
                if let sub:String = dStore["price_str"] as? String
                {
                    cell.lblSubTitle1.text = sub
                    cell.lblSubTitle1.textColor = UIColor.colorWithHexString("#36817A")
                }
                if let imgStr:String = dStore["cover_url"] as? String
                {
                    cell.imgView.setImageUsingUrl(imgStr)
                }
            }
            if let dStore:[String:Any] = dict["available_stock"] as? [String:Any]
            {
                if let sub:String = dStore["available_units_str"] as? String
                {
                    cell.lblSubTitle2.text = sub
                    cell.lblSubTitle2.textColor = UIColor.lightGray
                }
            }
        }
        else
        {
            if let title:String = dict["product_name"] as? String
            {
                cell.lblTitle.text = title
            }
            if let sub:String = dict["short_status_str"] as? String
            {
                cell.lblSubTitle1.text = sub
                cell.lblSubTitle1.textColor = UIColor.lightGray
                
                if let status:Int = dict["status"] as? Int
                {
                    if status == 0
                    {
                        cell.lblSubTitle1.textColor = UIColor.lightGray
                    }
                    if status == 1
                    {
                        cell.lblSubTitle1.textColor = k_baseColor
                    }
                    if status == 2
                    {
                        cell.lblSubTitle1.textColor = UIColor.colorWithHexString("#36817A")
                    }
                }
            }
            if let imgStr:String = dict["cover_url"] as? String
            {
                cell.imgView.setImageUsingUrl(imgStr)
            }
            if let sub:String = dict["price_str"] as? String
            {
                cell.lblSubTitle2.text = sub
                cell.lblSubTitle2.textColor = UIColor.lightGray
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrData[indexPath.row]

        if strSelectedView == "Store"
        {
            let vc: ConsiderationStoreVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "ConsiderationStoreVC_ID") as! ConsiderationStoreVC
            vc.modalTransitionStyle = .crossDissolve
            
            if let dStore:[String:Any] = dict["physical_product"] as? [String:Any]
            {
                if let title:String = dStore["product_sku"] as? String
                {
                    vc.product_sku = title
                }
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.present(vc, animated: true, completion: nil)

        }
        else
        {
            // My Orders
            let vc: ConsiderationMyOrderVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "ConsiderationMyOrderVC_ID") as! ConsiderationMyOrderVC
            vc.modalTransitionStyle = .crossDissolve
            vc.dictMain = dict
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension ConsiderationsListVC
{
    func callGetPhysicalProducts(serviceName:String)
    {
        var service:String = ""
        
        if serviceName == "Store"
        {
            service = ServiceName.GET_PhysicalProductsStore.rawValue
        }
        else
        {
            // My Orders
            service = ServiceName.GET_PhysicalProductsStoreMyOrder.rawValue
        }
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        var param: [String:Any] = [:]
        
        if serviceName == "Store"
        {
            param = ["uuid":uuid, "category":"0"]
        }
        else
        {
            param = ["uuid":uuid]
        }
        
        WebService.requestService(url: service, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        self.arrData.removeAll()
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrData = arr
                            
                            DispatchQueue.main.async {
                                
                                if self.tblView.delegate == nil
                                {
                                    self.tblView.dataSource = self
                                    self.tblView.delegate = self
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
