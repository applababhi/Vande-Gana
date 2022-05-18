//
//  ConsiderationMyOrderVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 23/9/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ConsiderationMyOrderVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!
        
    var hasTrackingURL = false
    var arrData: [[String:Any]] = []
    var dictMain: [String:Any] = [:]

    var check_backtoWalletForNotfCenter = false
    var statusID:Int = 0
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblTitle.text = "MIS PEDIDOS"

        hideKeyboardWhenTappedAround()
        setUpViews()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        if check_backtoWalletForNotfCenter == true
        {
            // back to wallet
            NotificationCenter.default.post(name: Notification.Name("viewWillAppear_WalletVC"), object: nil)
        }
        else
        {
            // back to physicalproductlist
            NotificationCenter.default.post(name: Notification.Name("viewWillAppear_PhysicalProductList"), object: nil)
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpViews()
    {
        if let sta:Int = dictMain["status"] as? Int
        {
            statusID = sta
        }
                   
        var tempDict:[String:Any] = [:]
        if let img:String = dictMain["cover_url"] as? String
        {
            tempDict["image"] = img
        }
        if let title:String = dictMain["product_name"] as? String
        {
            tempDict["title"] = title
        }
        
        self.arrData.append(tempDict)   // cell 1
        //////////
        if let brand:String = dictMain["brand"] as? String
        {
            let d1:[String:Any] = ["label": "Marca: " + brand]
            self.arrData.append(d1)  // cell 2
        }
        /////////
        if let price_str:String = dictMain["price_str"] as? String
        {
            let d1:[String:Any] = ["label": "Precio Unitario: " + price_str]
            self.arrData.append(d1)  // cell 3
        }
        /////////
        if let date:String = dictMain["request_date_str"] as? String
        {
            let d1:[String:Any] = ["label": "Fecha de Solicitud: " + date]
            self.arrData.append(d1)  // cell 4
        }
        ////////
        if let char:String = dictMain["long_status_str"] as? String
        {
            let d1:[String:Any] = ["label": "Status: " + char]
            self.arrData.append(d1)  // cell 5
        }
        ////////
        if statusID == 2
        {
            // Delivered
            if let char:String = dictMain["delivery_date_str"] as? String
            {
                let d1:[String:Any] = ["label": "Fecha de Entrega: " + char]
                self.arrData.append(d1)  // cell 6
            }
        }
        else
        {
            if let char:String = dictMain["shipping_date_str"] as? String
            {
                let d1:[String:Any] = ["label": "Fecha de Envío: " + char]
                self.arrData.append(d1)  // cell 6
            }
        }
                
        ////////
        if let char:String = dictMain["full_adddress"] as? String
        {
            let d1:[String:Any] = ["label": "Dirección de Entega: " + char]
            self.arrData.append(d1)  // cell 7
        }
        ////////
        self.arrData.append(["button": "ButtonURL"])  // cell 8
        
        
        if let char:Bool = dictMain["has_tracking_url"] as? Bool
        {
            hasTrackingURL = char
        }
        if let char:Int = dictMain["has_tracking_url"] as? Int
        {
            if char == 0
            {
                hasTrackingURL = false
            }
            else
            {
                hasTrackingURL = true
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

extension ConsiderationMyOrderVC
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

extension ConsiderationMyOrderVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let dict:[String:Any] = arrData[indexPath.row]
        let keys: [String] = Array(dict.keys)
        
        if keys.contains("image")
        {
            return 200
        }
        else if keys.contains("label")
        {
            if let title:String = dict["label"] as? String
                {
                    let width = (tableView.frame.size.width - 20.0)
                    let height = title.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.regular, size: 17.0)!)
                    return height + 7
                }
                return 0
        }
       else if keys.contains("button")
        {
            if hasTrackingURL == true
            {
                return 60
            }
           else
            {
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]
        let keys: [String] = Array(dict.keys)
        
        if keys.contains("image")
        {
            let cell:CellExchange_Header = tableView.dequeueReusableCell(withIdentifier: "CellExchange_Header", for: indexPath) as! CellExchange_Header
            cell.selectionStyle = .none
            cell.lblTitle.text = ""

            cell.imgView.layer.cornerRadius = 5.0
            cell.imgView.layer.masksToBounds = true
            
            if let img:String = dict["image"] as? String
            {
                cell.imgView.setImageUsingUrl(img)
            }
            if let title:String = dict["title"] as? String
            {
                cell.lblTitle.text = title
            }
            
            return cell
        }
        else if keys.contains("label")
        {
            let cell:CellConsiderationLabels = tableView.dequeueReusableCell(withIdentifier: "CellConsiderationLabels", for: indexPath) as! CellConsiderationLabels
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
                        
            if let title:String = dict["label"] as? String
            {
                //cell.lblTitle.text = title
                let strBeforeColon:String = title.components(separatedBy: ":").first!
                let range = NSMakeRange(0, strBeforeColon.count)
                              
                if title.contains("Status:") == true
                {
                    if statusID == 0
                    {
                        cell.lblTitle.attributedText = attributedStringWithColor(from: title, nonBoldRange: range, color: UIColor.lightGray)
                    }
                    if statusID == 1
                    {
                        cell.lblTitle.attributedText = attributedStringWithColor(from: title, nonBoldRange: range, color: k_baseColor)
                    }
                    if statusID == 2
                    {
                        cell.lblTitle.attributedText = attributedStringWithColor(from: title, nonBoldRange: range, color: UIColor.colorWithHexString("#36817A"))
                    }
                }
                else
                {
                    cell.lblTitle.attributedText = attributedString(from: title, nonBoldRange: range)
                }
            }
            
            return cell

        }
        else if keys.contains("button")
        {
            // Next Button
            let cell:CellConsiderationButton = tblView.dequeueReusableCell(withIdentifier: "CellConsiderationButton", for: indexPath) as! CellConsiderationButton
            cell.selectionStyle = .none
            
            cell.lblTopRed.text = ""
            cell.lblBottomRed.isHidden = true
            cell.lblBottomRed.isHidden = true
            
            
            cell.btnNext.layer.cornerRadius = 5.0
            cell.btnNext.layer.masksToBounds = true
            cell.btnNext.addTarget(self, action: #selector(self.btnNextClick(btn:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    @objc func btnNextClick(btn:UIButton)
    {
        if let urlstr:String = dictMain["tracking_url"] as? String
        {
            guard let url = URL(string: urlstr) else {
                 return
             }
            if UIApplication.shared.canOpenURL(url) {
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
             }
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

