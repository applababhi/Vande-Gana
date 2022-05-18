//
//  WalletVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 8/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class WalletVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnWallet:UIButton!
    @IBOutlet weak var viewWalletLine:UIView!
    @IBOutlet weak var btnMyOrder:UIButton!
    @IBOutlet weak var viewMyOrderLine:UIView!

    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var btnWalletDownload:UIButton!
    
    @IBOutlet weak var c_bDownload_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_bWallet_Ld:NSLayoutConstraint!
    
    var arrWalletData: [[String:Any]] = []
    var dictMain:[String:Any] = [:]
    var check_forDownloadAny1Active = false
    var strSelectedView:String = "Wallet"
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.callViewWillAppearios13(notfication:)), name: Notification.Name("viewWillAppear_WalletVC"), object: nil)

        btnMyOrder.isHidden = true
        viewMyOrderLine.isHidden = true

        setUpTopBar()
        
        btnWallet.setTitleColor(k_baseColor, for: .normal)
        viewWalletLine.backgroundColor = k_baseColor
        btnMyOrder.setTitleColor(UIColor.lightGray, for: .normal)
        viewMyOrderLine.backgroundColor = UIColor.lightGray
        btnWalletDownload.isHidden = false
        
        btnWalletDownload.layer.cornerRadius = 5.0
        lblTitle.text = "Wallet"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetWallet()
    }
    
    @IBAction func walletClick(btn:UIButton)
    {
        strSelectedView = "Wallet"
        arrWalletData.removeAll()
        tblView.reloadData()
        
        if let a:[[String:Any]] = dictMain["wallet"] as? [[String:Any]]
        {
            arrWalletData = a
            for d in arrWalletData
            {
                if let check:Bool = d["is_active"] as? Bool
                {
                    if check == true
                    {
                        self.check_forDownloadAny1Active = true
                    }
                }
            }
        }
        
        btnWallet.setTitleColor(k_baseColor, for: .normal)
        viewWalletLine.backgroundColor = k_baseColor
        btnWalletDownload.isHidden = false
        btnMyOrder.setTitleColor(UIColor.lightGray, for: .normal)
        viewMyOrderLine.backgroundColor = UIColor.lightGray
        c_bDownload_Ht.constant = 50
        
        tblView.reloadData()
    }
    
    @IBAction func myOrderClick(btn:UIButton)
    {
        strSelectedView = "MyOrder"
        arrWalletData.removeAll()
        tblView.reloadData()
        
        if let a:[[String:Any]] = dictMain["physical_products"] as? [[String:Any]]
        {
            arrWalletData = a
        }
        
        btnWalletDownload.isHidden = true
        btnMyOrder.setTitleColor(k_baseColor, for: .normal)
        viewMyOrderLine.backgroundColor = k_baseColor
        btnWallet.setTitleColor(UIColor.lightGray, for: .normal)
        viewWalletLine.backgroundColor = UIColor.lightGray
        c_bDownload_Ht.constant = 0
        
        tblView.reloadData()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func walletDownloadClicked(btn:UIButton)
    {
        if check_forDownloadAny1Active == true
        {
            callGetDownloadPDF()
        }
        else
        {
            self.showAlertWithTitle(title: "AT&T", message: "No es posible generar el archivo debido a que aún no recibes códigos de regalo.", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
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

extension WalletVC
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

extension WalletVC
{
    func callGetWallet()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "category":"0"]
        WebService.requestService(url: ServiceName.GET_UserWalletList.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
               //     print(jsonString)
            
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
                        self.arrWalletData.removeAll()
                        if let dictM:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            self.dictMain = dictM
                            
                            DispatchQueue.main.async {
                                
                                if self.tblView.delegate == nil
                                {
                                    self.tblView.dataSource = self
                                    self.tblView.delegate = self
                                }
                                
                                if self.strSelectedView == "Wallet"
                                {
                                    self.walletClick(btn: UIButton())
                                }
                                else
                                {
                                    self.myOrderClick(btn: UIButton())
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callGetDownloadPDF()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        let urlToPass:String = "\(baseUrl)" + ServiceName.GET_UserWalletDownloadPDF.rawValue + "?uuid=\(uuid)"
        
        let vc: NewsDetailVC = AppStoryBoards.NewsDetail.instance.instantiateViewController(withIdentifier: "NewsDetailVC_ID") as! NewsDetailVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        vc.strTitle = "Archivo Consolidado"
        vc.pdfFilePath = urlToPass
        vc.check_backToWalletForNotCenter = true
        self.present(vc, animated: true, completion: nil)
    }
}

extension WalletVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrWalletData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if self.strSelectedView == "Wallet"
        {
              let cell:CellWalletList = tableView.dequeueReusableCell(withIdentifier: "CellWalletList", for: indexPath) as! CellWalletList
              cell.selectionStyle = .none
              
              let dict:[String:Any] = arrWalletData[indexPath.row]
              
              cell.lblTitle.text = ""
              cell.lblSubTitle.text = ""
              
              cell.viewBk.layer.cornerRadius = 5.0
              cell.viewBk.layer.borderWidth = 0.7
              cell.viewBk.layer.borderColor = UIColor.lightGray.cgColor
              cell.viewBk.layer.masksToBounds = true
              
            //  cell.imgView.layer.cornerRadius = 50.0
            //  cell.imgView.layer.borderWidth = 0.4
            //  cell.imgView.layer.masksToBounds = true
              
              if let title:String = dict["gift_name"] as? String
              {
                  cell.lblTitle.text = title
              }
              if let sub:String = dict["points_str"] as? String
              {
                  cell.lblSubTitle.text = sub
                  cell.lblSubTitle.textColor = UIColor.lightGray
                  
                  if let active:Int = dict["is_active"] as? Int
                  {
                      if active == 1
                      {
                          cell.lblSubTitle.textColor = UIColor(red: 220.0/255.0, green: 100.0/255.0, blue: 107.0/255.0, alpha: 1.0)
                      }
                  }
              }
              if let imgStr:String = dict["front_cover_url"] as? String
              {
                  cell.imgView.setImageUsingUrl(imgStr)
              }
              return cell

        }
        else
        {
            // my order
            let cell:CellConsideration_List = tableView.dequeueReusableCell(withIdentifier: "CellConsideration_List", for: indexPath) as! CellConsideration_List
            cell.selectionStyle = .none
            
            let dict:[String:Any] = arrWalletData[indexPath.row]
            
            cell.lblTitle.text = ""
            cell.lblSubTitle1.text = ""
            cell.lblSubTitle2.text = ""
            
            cell.viewBk.layer.cornerRadius = 5.0
            cell.viewBk.layer.borderWidth = 0.7
            cell.viewBk.layer.borderColor = UIColor.lightGray.cgColor
            cell.viewBk.layer.masksToBounds = true

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
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrWalletData[indexPath.row]
        
        if self.strSelectedView == "Wallet"
        {
            if let active:Int = dict["is_active"] as? Int
            {
                if active == 0
                {
                    DispatchQueue.main.async {
                        self.showAlertWithTitle(title: "AT&T", message: "Este código no ha sido entregado aún. Cuando se te entregue serás notficado vía correo electrónico.", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                    }
                }
                else
                {
                    if let type:Int = dict["gift_type"] as? Int
                    {
                        DispatchQueue.main.async {
                            let vc: WalletDetailVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "WalletDetailVC_ID") as! WalletDetailVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.dictMain = dict
                            vc.giftType = type
                            vc.check_backToWalletNotfCenter = true
                            vc.modalPresentationStyle = .overFullScreen
                            vc.modalPresentationCapturesStatusBarAppearance = true
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        else
        {
            // My Orders
            let vc: ConsiderationMyOrderVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "ConsiderationMyOrderVC_ID") as! ConsiderationMyOrderVC
            vc.modalTransitionStyle = .crossDissolve
            vc.dictMain = dict
            vc.check_backtoWalletForNotfCenter = true
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.present(vc, animated: true, completion: nil)

        }
        
    }
}
