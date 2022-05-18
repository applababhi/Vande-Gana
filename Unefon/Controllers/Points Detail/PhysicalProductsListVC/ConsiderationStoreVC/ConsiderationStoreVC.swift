//
//  ConsiderationStoreVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 23/9/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ConsiderationStoreVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!
    
    var focusManagerTF : FocusManager?
    var carouselViewReff: AACarousel!
    
    var hasBanner:Int!
    var arrData: [[String:Any]] = []
    var reffTapTF:UnderlineTextField!
    var strTxtFld = ""
    var product_sku = ""
    var showErrorMsgBottomUnderNext = false
    var strErrorMsgBottom = ""
//    var statePicker : UIPickerView!
//    var pickerArr: [[String:Any]] = []
    //var dictPickerSelected: [String:Any] = [:]
//    var strBrand = ""
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblTitle.text = "Canjear"
        self.focusManagerTF = FocusManager()
        hideKeyboardWhenTappedAround()
        callGetProductDetails()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_PhysicalProductList"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ConsiderationStoreVC
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

extension ConsiderationStoreVC: UITableViewDataSource, UITableViewDelegate
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
            if let ar:[String] = dict["banner"] as? [String]
            {
                if ar.count > 0
                {
                    return 350
                }
                else
                {
                    return 200
                }
            }
            return 200
        }
        else if keys.contains("description")
        {
            if let title:String = dict["description"] as? String
            {
                let width = (tableView.frame.size.width - 20.0)
                let height = title.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.regular, size: 17.0)!)
                return height + 7
            }
            return 0
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
        else if keys.contains("textfield")
            {
                return 75
            }
        else if keys.contains("button next")
        {
            if showErrorMsgBottomUnderNext == false
            {
                return 115
            }
            else
            {
                return 165
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

            if let img:String = dict["image"] as? String
            {
                cell.imgView.setImageUsingUrl(img)
            }
            if let title:String = dict["title"] as? String
            {
                cell.lblTitle.text = title
            }
            
            if let ar:[String] = dict["banner"] as? [String]
            {
                if ar.count > 0
                {
           //         print("HERE ADD BANNER -> ", ar)
                    cell.carouselView.delegate = self
                    cell.carouselView.setCarouselData(paths: ar,  describedTitle: [], isAutoScroll: true, timer: 2.7, defaultImage: "ph")
                    //optional method
                    cell.carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
                    cell.carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
                    
                    cell.carouselView.indexChangeClosure = { (index) in
                        //   print("Change the Labels here - - - Scroller - ", index)
                    }
                    
                    carouselViewReff = cell.carouselView
                }
            }
            
            return cell
        }
        else if keys.contains("description")
        {
            let cell:CellExchange_Description = tableView.dequeueReusableCell(withIdentifier: "CellExchange_Description", for: indexPath) as! CellExchange_Description
            cell.selectionStyle = .none
            cell.txtView.text = ""
            
            if let title:String = dict["description"] as? String
            {
                let strBeforeColon:String = title.components(separatedBy: ":").first!
                let range = NSMakeRange(0, strBeforeColon.count)
                cell.txtView.attributedText = attributedString(from: title, nonBoldRange: range)
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
                let strBeforeColon:String = title.components(separatedBy: ":").first!
                let range = NSMakeRange(0, strBeforeColon.count)
                cell.lblTitle.attributedText = attributedString(from: title, nonBoldRange: range)
            }
            
            return cell

        }
        else if keys.contains("textfield")
        {
            //
            let cell:CellExchange_TF = tableView.dequeueReusableCell(withIdentifier: "CellExchange_TF", for: indexPath) as! CellExchange_TF
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            cell.tf.text = ""
            if let focusManager = self.focusManagerTF {
                focusManager.addItem(item: cell.tf)
            }
            
            cell.lblTitle.text = "Cantidad a Solicitar:"
            
            cell.tf.delegate = self
            cell.tf.keyboardType = .numberPad
            cell.tf.layer.cornerRadius = 5.0
            cell.tf.layer.borderColor = UIColor.lightGray.cgColor
            cell.tf.layer.borderWidth = 1.0
            cell.tf.layer.masksToBounds = true
            cell.inCellAddLeftPaddingTo(TextField: cell.tf)
//            cell.tf.tag = 1001
            if let ph:String = dict["textfield"] as? String
            {
                cell.tf.keyboardType = .numberPad
                cell.tf.setPlaceHolderColorWith(strPH: ph)
                if strTxtFld != ""
                {
                    cell.tf.text = strTxtFld
                }
            }

            return cell
        }
        else if keys.contains("button next")
        {
            // Next Button
            let cell:CellConsiderationButton = tblView.dequeueReusableCell(withIdentifier: "CellConsiderationButton", for: indexPath) as! CellConsiderationButton
            cell.selectionStyle = .none
            
            cell.lblTopRed.text = ""
            cell.lblBottomRed.text = ""
            cell.lblBottomRed.isHidden = false
            
            if showErrorMsgBottomUnderNext == false
            {
                cell.c_lBottom_Ht.constant = 0
            }
            else
            {
                cell.c_lBottom_Ht.constant = 50
                cell.lblBottomRed.text = strErrorMsgBottom
            }
            
            if strTxtFld == ""
            {
                if let price:Int = dict["topLabel"] as? Int
                {
                    let title = "Costo en tokens: \n" + "\(price) tokens"
                    let strBeforeColon:String = title.components(separatedBy: ":").first!
                    let range = NSMakeRange(0, strBeforeColon.count)

                        cell.lblTopRed.attributedText = attributedStringWithColor(from: title, nonBoldRange: range, color: UIColor.colorWithHexString("#C75568"))
                }

            }
            else
            {
                if let price:Int = dict["topLabel"] as? Int
                {
                    if strTxtFld.isNumber == true
                    {
                            let title = "Costo en tokens: \n" + "\(Int(strTxtFld)! * price) tokens"
                            let strBeforeColon:String = title.components(separatedBy: ":").first!
                            let range = NSMakeRange(0, strBeforeColon.count)

                                cell.lblTopRed.attributedText = attributedStringWithColor(from: title, nonBoldRange: range, color: UIColor.colorWithHexString("#C75568"))
                    }
                }

            }
            
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
        if strTxtFld != ""
        {
            // call api
            
            if strTxtFld.isNumber == false
            {
                self.showAlertWithTitle(title: "Validación", message: "El texto introducido no es numérico", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            
            callNextClickApi()
        }
        else
        {
            self.showAlertWithTitle(title: "Validación", message: "Por favor agregue alguna cantidad para proceder", okButton: "Ok", cancelButton: "", okSelectorName: nil)
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

extension ConsiderationStoreVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            focusManagerTF!.focusTouch(item: textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            let control = textField as! UnderlineTextField
            control.updateFocus(isFocus: false)
        }
        
        strTxtFld = textField.text!
        tblView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        strTxtFld = textField.text!
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Scroller Delegate
extension ConsiderationStoreVC: AACarouselDelegate
{
    //require method
    func downloadImages(_ url: String, _ index:Int)
    {
        let imageView1 = UIImageView()
        
        imageView1.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "ph"), options: [.transition(.fade(1))], progressBlock: nil) { (downloadImage, error, cacheType, url) in
            if downloadImage != nil && self.carouselViewReff != nil
            {
                self.carouselViewReff.images[index] = downloadImage!
            }
        }
    }
    
    //optional method (show first image faster during downloading of all images)
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        
        imageView.kf.setImage(with: URL(string: url[index]), placeholder: UIImage.init(named: "ph"))
    }
    
    //optional method (interaction for touch image)
    func didSelectCarouselView(_ view:AACarousel ,_ index:Int) {
        
        print("selected Banner Index - ",index)
    }
}

extension ConsiderationStoreVC
{
    func callGetProductDetails()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "product_sku":product_sku]
        WebService.requestService(url: ServiceName.GET_PhysicalProductsStoreDetails.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let dicT:[String:Any] = json["response_object"] as? [String:Any]
                        {
                          //  print(dicT)
                            
                            if let hasbanner:Int = dicT["has_banners"] as? Int
                            {
                                self.hasBanner = hasbanner
                            }
                            
                            if let di:[String:Any] = dicT["physical_product"] as? [String:Any]
                            {
                                var tempDict:[String:Any] = [:]
                                
                                if let img:String = di["cover_url"] as? String
                                {
                                    tempDict["image"] = img
                                }
                                if let title:String = di["product_name"] as? String
                                {
                                    tempDict["title"] = title
                                }
                                
                                if let arBanner:[[String:Any]] = dicT["banners"] as? [[String:Any]]
                                {
                                    var arrBan:[String] = []
                                    for d in arBanner
                                    {
                                        if let img:String = d["high_res_url"] as? String
                                        {
                                            arrBan.append(img)
                                        }
                                    }
                                    tempDict["banner"] = arrBan
                                }
                                self.arrData.append(tempDict)   // cell 1
                                //////////
                                if let brand:String = di["brand"] as? String
                                {
                                    let d1:[String:Any] = ["label": "Marca: " + brand]
                                    self.arrData.append(d1)  // cell 2
                                }
                                /////////
                                if let price_str:String = di["price_str"] as? String
                                {
                                    let d1:[String:Any] = ["label": "Precio Unitario: " + price_str]
                                    self.arrData.append(d1)  // cell 3
                                }
                                /////////
                                if let diC:[String:Any] = dicT["available_stock"] as? [String:Any]
                                {
                                    if let units:String = diC["available_units_str"] as? String
                                    {
                                        let d1:[String:Any] = ["label": "Inventario Disponible: " + units]
                                        self.arrData.append(d1)  // cell 4
                                    }
                                }
                                ////////
                                if let desc:String = di["product_description"] as? String
                                {
                                    let d1:[String:Any] = ["description": "Descripción: \n" + desc]
                                    self.arrData.append(d1)  // cell 5
                                }
                                ////////
                                if let char:String = di["product_characteristics"] as? String
                                {
                                    let d1:[String:Any] = ["description": "Características: \n" + char]
                                    self.arrData.append(d1)  // cell 6
                                }
                                ////////
                                self.arrData.append(["textfield": "Agregar cantidad"])  // cell 7
                                ////////
                                if let price:Int = di["price"] as? Int
                                {
                                    self.arrData.append(["button next": "Button Next", "topLabel":price])  // cell 8
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
                }
            }
        }
    }

    func callNextClickApi()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "quantity":Int(strTxtFld)!, "product_sku":product_sku]
        WebService.requestService(url: ServiceName.POST_PhysicalProductPreview.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
              // print(jsonString)
            
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
                            self.showErrorMsgBottomUnderNext = true
                            self.strErrorMsgBottom = msg
                            self.tblView.reloadData()
                         //   self.showAlertWithTitle(title: "Error", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        if let dif:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                let vc: ProductPreviewVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "ProductPreviewVC_ID") as! ProductPreviewVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.dictMain = dif
                                vc.product_sku = self.product_sku
                                vc.modalPresentationStyle = .overFullScreen
                                vc.modalPresentationCapturesStatusBarAppearance = true
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
}
