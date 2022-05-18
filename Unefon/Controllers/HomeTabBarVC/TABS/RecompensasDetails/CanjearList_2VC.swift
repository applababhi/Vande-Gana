//
//  CanjearList_2VC.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/10/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CanjearList_2VC: UIViewController {
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var vTokenBalance:UIView!
    @IBOutlet weak var lblTokenBalance:UILabel!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!

    var arrData: [[String:Any]] = []
    var strTitle = ""
    var strBalance = "0"
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblHeader.text = strTitle
        
        vTokenBalance.layer.cornerRadius = 5.0
        vTokenBalance.layer.masksToBounds = true
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: CustomFont.semiBold, size: 29), NSAttributedString.Key.foregroundColor : UIColor(named: "App_Blue")!]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: CustomFont.regular, size: 17), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        let attributedString1 = NSMutableAttributedString(string:strBalance + " ", attributes:attrs1 as [NSAttributedString.Key : Any])
        let attributedString2 = NSMutableAttributedString(string:"   Tokens Disponibles", attributes:attrs2 as [NSAttributedString.Key : Any])
        attributedString1.append(attributedString2)
        lblTokenBalance.attributedText = attributedString1
        
        collView.delegate = self
        collView.dataSource = self
    }
    
    func setUpTopBar()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
            c_Header_Ht.constant = 90
            setHeadGradient(height: 90)
        }
        else if strModel == "iPhone Max"
        {
            c_Header_Ht.constant = 90
            setHeadGradient(height: 90)
        }
        else if strModel == "iPhone 5"
        {
            
        }
        else{
            c_Header_Ht.constant = 110
            setHeadGradient(height: 110)
        }
    }
    
    func setHeadGradient(height:Int){
        let fistColor = UIColor(named: "App_DarkBlack")!
        let lastColor = UIColor(named: "App_LightBlack")!
        
        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.colors = [fistColor.cgColor, lastColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: height)
        vHeader.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func btnBack(btn:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHeaderClick(btn:UIButton){
        print(". . . . . .  . Header clicked")
        callApiForOperations_2()
    }
    
    func callApiForOperations_2()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        let urlStr:String = ServiceName.GET_Operations_2.rawValue + uuid
        
        WebService.requestService(url: urlStr, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let dictResp:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                let vc: OperationsVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "OperationsVC_ID") as! OperationsVC
                                
                                if let str:String = dictResp["tokens_balance_str"] as? String{
                                    vc.strBalance = str
                                }
                                if let arr:[[String:Any]] = dictResp["transactions"] as? [[String:Any]]{
                                    vc.arrData = arr
                                }
                                vc.isTokenCall = true
                                vc.strTitle = "Mis Certificados"
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension CanjearList_2VC: UICollectionViewDataSource, UICollectionViewDelegate
{
    // MARK: - UICollectionView protocols
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dStore:[String:Any] = arrData[indexPath.item]
        let cell:CollCell_Store = collView.dequeueReusableCell(withReuseIdentifier: "CollCell_Store", for: indexPath as IndexPath) as! CollCell_Store
        
        cell.contentView.clipsToBounds = true
        cell.vShadow.clipsToBounds = true
        cell.lblTitle.text = ""
        cell.lblPrice.text = ""
        cell.imgView.image = nil
        cell.vBk.layer.cornerRadius = 20.0
        cell.vBk.layer.masksToBounds = true
      
        cell.vShadow.layer.cornerRadius = 20.0
        cell.vShadow.layer.masksToBounds = true
        
        cell.vShadow.isHidden = true
        
        cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 16)
        if let title:String = dStore["product_name"] as? String
        {
            cell.lblTitle.text = title
        }
        if let sub:String = dStore["price_str"] as? String
        {
            let attrs1 = [NSAttributedString.Key.font : UIFont(name: CustomFont.semiBold, size: 16), NSAttributedString.Key.foregroundColor : UIColor.yellow]
            let attrs2 = [NSAttributedString.Key.font : UIFont(name: CustomFont.regular, size: 11), NSAttributedString.Key.foregroundColor : UIColor.yellow]
            let attributedString1 = NSMutableAttributedString(string:sub, attributes:attrs1 as [NSAttributedString.Key : Any])
            let attributedString2 = NSMutableAttributedString(string:"  tokens", attributes:attrs2 as [NSAttributedString.Key : Any])
            attributedString1.append(attributedString2)
            cell.lblPrice.attributedText = attributedString1
        }
        if let imgStr:String = dStore["cover_url"] as? String
        {
            cell.imgView.setImageUsingUrl(imgStr)
        }

        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(self.CellClicked(btn:)), for: .touchUpInside)
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    
    @objc func CellClicked(btn:UIButton)
    {
        let dict:[String:Any] = arrData[btn.tag]
        if let product_sku:String = dict["product_sku"] as? String
        {
            callEachProductSelected(product_sku: product_sku)
        }
    }
}

extension CanjearList_2VC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let collectionViewWidth = (UIScreen.main.bounds.size.width/2.0) - 6
        let heightTotal:CGFloat = 210
        return CGSize(width: (collectionViewWidth), height: heightTotal)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension CanjearList_2VC
{
    func callEachProductSelected(product_sku:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }

        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "product_sku":product_sku]
        WebService.requestService(url: ServiceName.GET_EachProductSelectt.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
     //      print(jsonString)
            
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
                        
                        if let dictM:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                let vc: EachTokenSelectVC = AppStoryBoards.Recompensas.instance.instantiateViewController(withIdentifier: "EachTokenSelectVC_ID") as! EachTokenSelectVC
                                vc.dictMain = dictM
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}


class CollCell_Store: UICollectionViewCell {
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var btn:UIButton!
    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var vShadow:UIView!
}
