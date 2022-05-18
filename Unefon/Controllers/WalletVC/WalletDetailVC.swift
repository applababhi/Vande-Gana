//
//  WalletDetailVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 2/8/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class WalletDetailVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    var giftType:Int = 0
    var arrUI: [String] = ["header", "instruction"] // "hyperlink1","hyperlink2", "checkbox", "type1","type3","type4"
    var dictMain:[String:Any] = [:]
    var isCheckboxClick = false
    var isCheckboxClickResponse = false
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!
    
    var check_backToWalletNotfCenter = false


    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopBar()

        tblView.dataSource = self
        tblView.delegate = self
        tblView.estimatedRowHeight = 50
        tblView.rowHeight = UITableView.automaticDimension
        updateArrUI()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        if check_backToWalletNotfCenter ==  true
        {
            // back to walletVC
            NotificationCenter.default.post(name: Notification.Name("viewWillAppear_WalletVC"), object: nil)
        }
        else
        {
            // back to excahangeDetail
            NotificationCenter.default.post(name: Notification.Name("viewWillAppear_ExchangeDetailVC"), object: nil)
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
    
    func updateArrUI()
    {
        if giftType == 1
        {
            // 1 = Digtial Code
            arrUI.append("type1")
        }
        else if giftType == 2
        {
            // 2 = Pre Generated Account (Currently not available for Unefon)
        }
        else if giftType == 3
        {
            // 3 = Pre Generated Digital Code
            arrUI.append("type3")
        }
        else if giftType == 4
        {
            // 4 = Gift Card with PIN
            if let _:String = dictMain["terms_conditions_url"] as? String
            {
                arrUI.append("hyperlink1")
            }
            if let _:String = dictMain["privacy_advice_url"] as? String
            {
                arrUI.append("hyperlink2")
            }
            arrUI.append("checkbox")
            // arrUI.append("type4") hode initially
        }
    }
}

extension WalletDetailVC
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

extension WalletDetailVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrUI.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let strType:String = arrUI[indexPath.row]
        
        if strType == "header"
        {
            return 290
        }
        else if strType == "instruction"
        {
            return UITableView.automaticDimension
        }
        else if strType == "hyperlink1"
        {
            // return 45
            return UITableView.automaticDimension
        }
        else if strType == "hyperlink2"
        {
            //return 45
            return UITableView.automaticDimension
        }
        else if strType == "checkbox"
        {
            return 50
        }
        else if strType == "type1"
        {
            return 127
        }
        else if strType == "type3"
        {
            return 45
        }
        else if strType == "type4"
        {
            return 155
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let strType:String = arrUI[indexPath.row]
        
        if strType == "header"
        {
            let cell:CellWallet_Header = tableView.dequeueReusableCell(withIdentifier: "CellWallet_Header", for: indexPath) as! CellWallet_Header
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            cell.lblType.text = ""
            cell.lblBrand.text = ""
            cell.lblPoints.text = ""

            cell.imgView.layer.cornerRadius = 45.0
            cell.imgView.layer.borderWidth = 0.3
            cell.imgView.layer.masksToBounds = true
            if let imgStr:String = dictMain["front_cover_url"] as? String
            {
                cell.imgView.setImageUsingUrl(imgStr)
            }
            
            if let str:String = dictMain["gift_name"] as? String
            {
                cell.lblTitle.text = str
            }
            if let str:String = dictMain["gift_type_str"] as? String
            {
                cell.lblType.text = "Tipo: " + str
            }
            if let str:String = dictMain["brand"] as? String
            {
                cell.lblBrand.text = "Marca: " + str
            }
            if let str:String = dictMain["points_str"] as? String
            {
                cell.lblPoints.text = "Monto: " + str
            }
            
            return cell
        }
        else if strType == "instruction"
        {
            let cell:CellWallet_Instructions = tableView.dequeueReusableCell(withIdentifier: "CellWallet_Instructions", for: indexPath) as! CellWallet_Instructions
            cell.selectionStyle = .none
            
            cell.lblInstructions.text = ""
            if let str:String = dictMain["instructions"] as? String
            {
                cell.lblInstructions.text = str
            }
            return cell
        }
        else if strType == "hyperlink1"
        {
            let cell:CellWallet_Hyperlink = tableView.dequeueReusableCell(withIdentifier: "CellWallet_Hyperlink", for: indexPath) as! CellWallet_Hyperlink
            cell.selectionStyle = .none
            
            cell.btnLink.titleLabel?.numberOfLines = 0
            cell.btnLink.titleLabel?.lineBreakMode = .byWordWrapping
            cell.btnLink.sizeToFit()
            if let str:String = dictMain["terms_conditions_url"] as? String
            {
                cell.btnLink.setTitle(str, for: .normal)
            }
            cell.btnLink.tag = indexPath.row
            cell.btnLink.addTarget(self, action: #selector(self.hyperlink1Click(btn:)), for: .touchUpInside)
            return cell
        }
        else if strType == "hyperlink2"
        {
            let cell:CellWallet_Hyperlink = tableView.dequeueReusableCell(withIdentifier: "CellWallet_Hyperlink", for: indexPath) as! CellWallet_Hyperlink
            cell.selectionStyle = .none
            cell.btnLink.tag = indexPath.row
            cell.btnLink.titleLabel?.numberOfLines = 0
            cell.btnLink.titleLabel?.lineBreakMode = .byWordWrapping
            cell.btnLink.sizeToFit()

            if let str:String = dictMain["privacy_advice_url"] as? String
            {
                cell.btnLink.setTitle(str, for: .normal)
            }
            cell.btnLink.addTarget(self, action: #selector(self.hyperlink2Click(btn:)), for: .touchUpInside)
            return cell
        }
        else if strType == "checkbox"
        {
            let cell:CellWallet_Checkbox = tableView.dequeueReusableCell(withIdentifier: "CellWallet_Checkbox", for: indexPath) as! CellWallet_Checkbox
            cell.selectionStyle = .none

            if isCheckboxClick == false
            {
                cell.imgView.image = UIImage(named: "uncheck")
            }
            else
            {
                // Agreed
                cell.imgView.image = UIImage(named: "check")
            }
            cell.btn.addTarget(self, action: #selector(self.checkboxClick(btn:)), for: .touchUpInside)
            return cell
        }
        else if strType == "type1"
        {
            let cell:CellWallet_Type1 = tableView.dequeueReusableCell(withIdentifier: "CellWallet_Type1", for: indexPath) as! CellWallet_Type1
            cell.selectionStyle = .none

            cell.btnDownload.layer.cornerRadius = 5.0
            cell.btnDownload.layer.masksToBounds = true
            cell.btnShare.layer.cornerRadius = 5.0
            cell.btnShare.layer.masksToBounds = true

            cell.btnStoreUrl.setTitle("", for: .normal)
            cell.lblCode.text = ""
            
            cell.btnStoreUrl.addTarget(self, action: #selector(self.openUrlType1Store(btn:)), for: .touchUpInside)
            cell.btnDownload.addTarget(self, action: #selector(self.downloadType1(btn:)), for: .touchUpInside)
            cell.btnShare.addTarget(self, action: #selector(self.shareType1(btn:)), for: .touchUpInside)

            if let str:String = dictMain["store_url"] as? String
            {
                cell.btnStoreUrl.setTitle(str, for: .normal)
            }
            if let str:String = dictMain["code"] as? String
            {
                cell.lblCode.text = "Código: " + str
            }
            return cell
        }
        else if strType == "type3"
        {
            let cell:CellWallet_LinkType3 = tableView.dequeueReusableCell(withIdentifier: "CellWallet_LinkType3", for: indexPath) as! CellWallet_LinkType3
            cell.selectionStyle = .none
            
            cell.btnLink.addTarget(self, action: #selector(self.openUrlType3(btn:)), for: .touchUpInside)
            if let str:String = dictMain["code_url"] as? String
            {
                cell.btnLink.setTitle(str, for: .normal)
            }
            
            return cell
        }
        else if strType == "type4"
        {
            let cell:CellWallet_Type4 = tableView.dequeueReusableCell(withIdentifier: "CellWallet_Type4", for: indexPath) as! CellWallet_Type4
            cell.selectionStyle = .none
            
            cell.btnViewDetails.layer.cornerRadius = 5.0
            cell.btnViewDetails.layer.masksToBounds = true
            cell.lblPin.text = ""
            cell.lblCode.text = ""
            cell.btnLoginUrl.setTitle("", for: .normal)
            cell.btnViewDetails.addTarget(self, action: #selector(self.viewDetailApi(btn:)), for: .touchUpInside)
            cell.btnLoginUrl.addTarget(self, action: #selector(self.openUrlType4(btn:)), for: .touchUpInside)
            
            if isCheckboxClickResponse == false
            {
                cell.lblPin.isHidden = true
                cell.lbl.isHidden = true
                cell.lblCode.isHidden = true
                cell.btnLoginUrl.isHidden = true
            }
            else
            {
                cell.lblPin.isHidden = false
                cell.lbl.isHidden = false
                cell.lblCode.isHidden = false
                cell.btnLoginUrl.isHidden = false
            }
            
            if let str:String = dictMain["login_url"] as? String
            {
                cell.btnLoginUrl.setTitle(str, for: .normal)
            }
            if let str:String = dictMain["code"] as? String
            {
                cell.lblCode.text = "Código(Num. de Tarjeta): " + str
            }
            if let str:String = dictMain["password"] as? String
            {
                cell.lblPin.text = "Password(NIP): " + str
            }
            
            
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension WalletDetailVC
{
    @objc func hyperlink1Click(btn:UIButton)
    {
        if let str:String = dictMain["terms_conditions_url"] as? String
        {
            if let url = URL(string: str)
            {
                // print(url)
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func hyperlink2Click(btn:UIButton)
    {
        if let str:String = dictMain["privacy_advice_url"] as? String
        {
            if let url = URL(string: str)
            {
                // print(url)
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func checkboxClick(btn:UIButton)
    {
        isCheckboxClick = !isCheckboxClick
        
        if isCheckboxClick == true
        {
            arrUI.append("type4")
        }
        else
        {
            if arrUI.contains("type4")
            {
                arrUI.removeLast()
            }
        }
        
        tblView.reloadData()
    }
    
    @objc func openUrlType4(btn:UIButton)
    {
        if let str:String = dictMain["login_url"] as? String
        {
            if let url = URL(string: str)
            {
                // print(url)
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func openUrlType3(btn:UIButton)
    {
        if let str:String = dictMain["code_url"] as? String
        {
            if let url = URL(string: str)
            {
                // print(url)
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func openUrlType1Store(btn:UIButton)
    {
        if let str:String = dictMain["store_url"] as? String
        {
            if let url = URL(string: str)
            {
                // print(url)
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func downloadType1(btn:UIButton)
    {
        var id = ""
        if let idT:String = dictMain["requested_code_id"] as? String
        {
            id = idT
        }
        
        let urlToPass:String = "\(baseUrl)" + "gifts/codes/reports/code_request" + "?code_request_id=\(id)"
        
        let vc: NewsDetailVC = AppStoryBoards.NewsDetail.instance.instantiateViewController(withIdentifier: "NewsDetailVC_ID") as! NewsDetailVC
        vc.modalTransitionStyle = .crossDissolve
        vc.strTitle = "Código Digital"
        vc.pdfFilePath = urlToPass
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func shareType1(btn:UIButton)
    {
        callEnviarType1Api()
    }
    
    @objc func viewDetailApi(btn:UIButton)
    {
        var codeId = ""
        if let str:String = dictMain["code_id"] as? String
        {
            codeId = str
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["code_id":codeId]
        
        WebService.requestService(url: ServiceName.PUT_AcceptTermsWalletGift.rawValue, method: .put, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
        //    print(jsonString)
            if error != nil
            {
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
                        
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                        }
                        DispatchQueue.main.async {
                            self.isCheckboxClickResponse = true
                            self.tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc func callEnviarType1Api()
    {
        var codeId = ""
        if let str:String = dictMain["requested_code_id"] as? String
        {
            codeId = str
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["code_request_id":codeId]
        
        WebService.requestService(url: ServiceName.PUT_EnviarType1.rawValue, method: .put, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
         //   print(jsonString)
            if error != nil
            {
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
                        
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.back))
                        }
                        DispatchQueue.main.async {

                        }
                    }
                }
            }
        }
    }
    
    @objc func back(){
        if check_backToWalletNotfCenter ==  true
        {
            // back to walletVC
            NotificationCenter.default.post(name: Notification.Name("viewWillAppear_WalletVC"), object: nil)
        }
        else
        {
            // back to excahangeDetail
            NotificationCenter.default.post(name: Notification.Name("viewWillAppear_ExchangeDetailVC"), object: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
