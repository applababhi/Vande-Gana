//
//  ExchangeDetailVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 2/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ExchangeDetailVC: UIViewController {

    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnTienda:UIButton!
    @IBOutlet weak var btnWallet:UIButton!
    @IBOutlet weak var viewTiendaLine:UIView!
    @IBOutlet weak var viewWalletLine:UIView!
    @IBOutlet weak var viewWallet:UIView!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var btnWalletDownload:UIButton!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrData: [[String:Any]] = []
    var arrWalletData: [[String:Any]] = []
    var strTitle:String = ""
    var check_forDownloadAny1Active:Bool = false
    
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

        NotificationCenter.default.addObserver(self, selector: #selector(self.callViewWillAppearios13(notfication:)), name: Notification.Name("viewWillAppear_ExchangeDetailVC"), object: nil)

        setUpTopBar()
        lblTitle.text = strTitle
        
        btnWalletDownload.layer.cornerRadius = 5.0
        viewWallet.isHidden = true
        btnTienda.setTitleColor(k_baseColor, for: .normal)
        viewTiendaLine.backgroundColor = k_baseColor
        btnWallet.setTitleColor(UIColor.lightGray, for: .normal)
        viewWalletLine.backgroundColor = UIColor.lightGray
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("SubmitGiftBuy"), object: nil)

    }
    
    @objc func methodOfReceivedNotification(notification: Notification)
    {
        print("Value of notification : ", notification.object ?? "")
        
        walletClick(btn: UIButton())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetGifts()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tiendaClick(btn:UIButton)
    {
        viewWallet.isHidden = true
        btnTienda.setTitleColor(k_baseColor, for: .normal)
        viewTiendaLine.backgroundColor = k_baseColor
        btnWallet.setTitleColor(UIColor.lightGray, for: .normal)
        viewWalletLine.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func walletClick(btn:UIButton)
    {
        callGetWallet()
        viewWallet.isHidden = false
        btnWallet.setTitleColor(k_baseColor, for: .normal)
        viewWalletLine.backgroundColor = k_baseColor
        btnTienda.setTitleColor(UIColor.lightGray, for: .normal)
        viewTiendaLine.backgroundColor = UIColor.lightGray
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

extension ExchangeDetailVC
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

extension ExchangeDetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CellColl_ExchangeDetail = collView.dequeueReusableCell(withReuseIdentifier: "CellColl_ExchangeDetail", for: indexPath) as! CellColl_ExchangeDetail
                
        // cell.contentView.dropShadow()
        cell.v_back.layer.cornerRadius = 5.0
        cell.v_back.layer.masksToBounds = true
        
        cell.v_backShadow.layer.cornerRadius = 5.0
        cell.v_backShadow.layer.borderWidth = 0.2
        cell.v_backShadow.layer.masksToBounds = true
        
        
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.shadowOpacity = 1
        cell.contentView.layer.shadowOffset = CGSize.zero
        cell.contentView.layer.shadowRadius = 3.5
        cell.contentView.layer.masksToBounds = true
        
        
        cell.imgVArrow.setImageColor(color: .white)
        cell.lblTitle.text = ""
        cell.lblSubTitle.text = ""
        cell.v_back.backgroundColor = UIColor.clear

        if let imgStr:String = dict["image"] as? String
        {
            cell.imgView.setImageUsingUrl(imgStr)
        }
        
        if let name:String = dict["name"] as? String
        {
            cell.lblTitle.text = name
        }
        
        if let sub:String = dict["subTitle"] as? String
        {
            cell.lblSubTitle.text = sub
        }
        
        if let col:String = dict["color"] as? String
        {
            cell.v_back.backgroundColor = UIColor.colorWithHexString(col)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrData[indexPath.item]
        
        let vc: ExchangeDetailColl_ItemTappedVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "ExchangeDetailColl_ItemTappedVC_ID") as! ExchangeDetailColl_ItemTappedVC
        vc.modalTransitionStyle = .crossDissolve
        if let strId:String = dict["gift_id"] as? String
        {
            vc.strGiftID = strId
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // To Change Cell Size Dynamically
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let WidthOfContent = (collectionView.frame.size.width) - 33
        
        let size = CGSize(width: WidthOfContent, height: 120)
        return size
    }
}

extension ExchangeDetailVC
{
    func callGetGifts()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "category":"0"]
        WebService.requestService(url: ServiceName.GET_UserGifts.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
          //  print(jsonString)
            
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
                            for d in arr
                            {
                                if let di:[String:Any] = d["gift"] as? [String:Any]
                                {
                                    var dict:[String:Any] = [:]
                                    if let id:String = di["gift_id"] as? String
                                    {
                                        dict["gift_id"] = id
                                    }
                                    if let img:String = di["front_cover_url"] as? String
                                    {
                                        dict["image"] = img
                                    }
                                    if let name:String = di["gift_name"] as? String
                                    {
                                        dict["name"] = name
                                    }
                                    if let name:String = di["gift_type_str"] as? String
                                    {
                                        dict["subTitle"] = name
                                    }
                                    if let color:String = di["background_color"] as? String
                                    {
                                        dict["color"] = color
                                    }
                                    self.arrData.append(dict)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                
                                if self.collView.delegate == nil
                                {
                                    self.collView.dataSource = self
                                    self.collView.delegate = self
                                }
                                self.collView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
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
           //  print(jsonString)  // "users/rewards/get"

            
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
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let arr:[[String:Any]] = dict["wallet"] as? [[String:Any]]{
                                self.arrWalletData = arr
                                for d in arr
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
        vc.strTitle = "File"
        vc.pdfFilePath = urlToPass
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true, completion: nil)
    }
}

extension ExchangeDetailVC: UITableViewDataSource, UITableViewDelegate
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
        let cell:CellWalletList = tableView.dequeueReusableCell(withIdentifier: "CellWalletList", for: indexPath) as! CellWalletList
        cell.selectionStyle = .none
        
        let dict:[String:Any] = arrWalletData[indexPath.row]
        
        cell.lblTitle.text = ""
        cell.lblSubTitle.text = ""
        
        cell.viewBk.layer.cornerRadius = 5.0
        cell.viewBk.layer.borderWidth = 0.7
        cell.viewBk.layer.borderColor = UIColor.lightGray.cgColor
        cell.viewBk.layer.masksToBounds = true
        
     //   cell.imgView.layer.cornerRadius = 50.0
     //   cell.imgView.layer.borderWidth = 0.4
     //   cell.imgView.layer.masksToBounds = true
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrWalletData[indexPath.row]
        
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
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalPresentationCapturesStatusBarAppearance = true
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
