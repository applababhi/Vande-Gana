//
//  ExchangeDetailColl_ItemTappedVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 3/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ExchangeDetailColl_ItemTappedVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    var focusManagerTF : FocusManager?
    
    var carouselViewReff: AACarousel!
    var canRequest:Int!
    var hasBanner:Int!
    
    var strGiftID = ""
    var hyperlink_Store = ""
    var hyperlink_Brand = ""
    var arrData: [[String:Any]] = []
    var reffTapTF:UnderlineTextField!
    var statePicker : UIPickerView!
    var pickerArr: [[String:Any]] = []
    var strTxtFld = ""
    var dictPickerSelected: [String:Any] = [:]
    
    var strBrand = ""
    @IBOutlet weak var viewAlert:UIView!
    @IBOutlet weak var lblAlert_Title:UILabel!
    @IBOutlet weak var lblAlert_Brand:UILabel!
    @IBOutlet weak var lblAlert_Quantity:UILabel!
    @IBOutlet weak var lblAlert_Cost:UILabel!
    @IBOutlet weak var btnAlert_Confirm:UIButton!
    @IBOutlet weak var btnAlert_Cancel:UIButton!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!


    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        lblTitle.text = "Canjear"
        viewAlert.alpha = 0.0
        self.focusManagerTF = FocusManager()
        hideKeyboardWhenTappedAround()
        callGetGiftDetail()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_ExchangeDetailVC"), object: nil)

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func alertConfirmClicked(btn:UIButton)
    {
        print("Call Api preview BUY GIFT - - - - - - ")
        callConfirmBuyGift()
    }
    
    @IBAction func alertCancelClicked(btn:UIButton)
    {
        UIView.animate(withDuration: 0.5) {
            self.viewAlert.alpha = 0.0
        }
    }
}

extension ExchangeDetailColl_ItemTappedVC
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

extension ExchangeDetailColl_ItemTappedVC: UITableViewDataSource, UITableViewDelegate
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
                return height + 70
            }
            return 0
        }
        else if keys.contains("hyperlink")
        {
            return 50
        }
        else if keys.contains("label")
        {
            if self.canRequest == 0
            {
                // Hide Both Textfields
                return 0
            }
            else
            {
                return 65
            }
        }
        else if keys.contains("button next")
        {
            return 74
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
      //      cell.imgView.layer.cornerRadius = 70.0
         //   cell.imgView.layer.borderWidth = 0.4
       //     cell.imgView.layer.masksToBounds = true

            if let img:String = dict["image"] as? String
            {
                cell.imgView.setImageUsingUrl(img)
            }
            if let title:String = dict["title"] as? String
            {
                cell.lblTitle.text = title
                lblAlert_Title.text = "Tipo: " + title
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
                cell.txtView.text = title
            }
            
            return cell
        }
        else if keys.contains("hyperlink")
        {
            let cell:CellExchange_Hyperlink = tableView.dequeueReusableCell(withIdentifier: "CellExchange_Hyperlink", for: indexPath) as! CellExchange_Hyperlink
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            
            if let title:String = dict["title"] as? String
            {
                cell.lblTitle.text = title
            }
            
            if let link:String = dict["hyperlink"] as? String
            {
                if cell.lblTitle.text! == "URL de la Tienda"
                {
                    // Store
                    hyperlink_Store = link
                    cell.btn.tag = 101
                }
                else
                {
                    // Brand
                    hyperlink_Brand = link
                    cell.btn.tag = 102
                }

                cell.btn.setTitle(link, for: .normal)
                cell.btn.addTarget(self, action: #selector(self.btnHyperlinkClick(btn:)), for: .touchUpInside)
            }
            
            return cell

        }
        else if keys.contains("label")
        {
            let cell:CellExchange_TF = tableView.dequeueReusableCell(withIdentifier: "CellExchange_TF", for: indexPath) as! CellExchange_TF
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            cell.tf.text = ""
            if let focusManager = self.focusManagerTF {
                focusManager.addItem(item: cell.tf)
            }
            
            cell.tf.delegate = self
            cell.tf.keyboardType = .default
            
            if let title:String = dict["label"] as? String
            {
                cell.lblTitle.text = title
            }
            
            if keys.contains("textfield")
            {
                cell.inCellAddRightPaddingTo(TextField: cell.tf, imageName: "")
                cell.tf.tag = 1001
                if let ph:String = dict["textfield"] as? String
                {
                    cell.tf.keyboardType = .numberPad
                    cell.tf.setPlaceHolderColorWith(strPH: ph)
                    if strTxtFld != ""
                    {
                        cell.tf.text = strTxtFld
                        lblAlert_Quantity.text = "Cantidad: " + strTxtFld
                    }
                }
            }
            else
            {
                // picker
                cell.tf.tag = 1002
                cell.inCellAddRightPaddingTo(TextField: cell.tf, imageName: "down")

                if let ph:String = dict["picker"] as? String
                {
                    cell.tf.setPlaceHolderColorWith(strPH: ph)
                }
                if let str = dictPickerSelected["title"] as? String
                {
                    cell.tf.text = str
                }
            }
            
            return cell
        }
        else if keys.contains("button next")
        {
            // Next Button
            let cell:CellExchange_NextBtn = tblView.dequeueReusableCell(withIdentifier: "CellExchange_NextBtn", for: indexPath) as! CellExchange_NextBtn
            cell.selectionStyle = .none
            
            cell.lblRed.text = ""
            cell.btnNext.isHidden = false
            
            if self.canRequest == 0
            {
                cell.btnNext.isHidden = true
                cell.lblRed.text = "En este momento no cuentas con los puntos suficientes para adquirir este código de regalo."
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
        if strTxtFld != "" && dictPickerSelected.count > 0
        {
            lblAlert_Quantity.text = "Cantidad: " + strTxtFld
            UIView.animate(withDuration: 0.5) {
                self.viewAlert.alpha = 1.0
            }
        }
        else
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
    }
    
    @objc func btnHyperlinkClick(btn:UIButton)
    {
        var link = ""
        if btn.tag == 101
        {
            // Store
             link = hyperlink_Store
        }
        else
        {
            // Brand = Tag = 102
             link = hyperlink_Brand
        }
        
        if let url = URL(string: link)
        {
           // print(url)
            UIApplication.shared.open(url)
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

extension ExchangeDetailColl_ItemTappedVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            focusManagerTF!.focusTouch(item: textField)
        }
        
        if textField.tag == 1002
        {
            reffTapTF = textField as? UnderlineTextField
            showPickerView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            let control = textField as! UnderlineTextField
            control.updateFocus(isFocus: false)
        }
        
        if textField.tag == 1001
        {
            // quantity
            strTxtFld = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1001
        {
            // quantity
            strTxtFld = textField.text!
        }
        textField.resignFirstResponder()
        return true
    }
}

extension ExchangeDetailColl_ItemTappedVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        
        if pickerArr.count == 0
        {
            self.showAlertWithTitle(title: "AT&T", message: "No hay denominaciones", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            self.view.endEditing(true)
            return
        }
        
        self.statePicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.statePicker.delegate = self
        self.statePicker.dataSource = self
        self.statePicker.backgroundColor = UIColor.white
        reffTapTF.inputView = self.statePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Hecho", style: .plain, target: self, action: #selector(self.donePickerClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //  let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelPickerClick))
        //  toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        reffTapTF.inputAccessoryView = toolBar
    }
    
    @objc func donePickerClick() {
        statePicker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
    }
    @objc func cancelPickerClick() {
        statePicker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var strTitle:String = ""
        let dict:[String:Any] = pickerArr[row]
        if let str = dict["denomination"] as? String
        {
            strTitle = str
            lblAlert_Cost.text = "Monto: " + str
        }
        if let str = dict["denomination"] as? Int
        {
            strTitle = "\(str)"
            lblAlert_Cost.text = "Monto: " + strTitle
        }
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dict:[String:Any] = pickerArr[row]
        if let str = dict["denomination"] as? String
        {
            reffTapTF.text = str
            dictPickerSelected = dict
        }
        if let str = dict["denomination"] as? Int
        {
            reffTapTF.text = "\(str)"
            dictPickerSelected = dict
        }
    }
}

extension ExchangeDetailColl_ItemTappedVC
{
    func callGetGiftDetail()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "gift_id":strGiftID]
        WebService.requestService(url: ServiceName.GET_GiftDetail.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
   //         print(jsonString) // get_details_for_user
            
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
                            if let canR:Int = dicT["can_request"] as? Int
                            {
                                self.canRequest = canR
                            }
                            
                            if let di:[String:Any] = dicT["gift"] as? [String:Any]
                            {
                                var tempDict:[String:Any] = [:]
                                if let id:String = di["gift_id"] as? String
                                {
                                    tempDict["gift_id"] = id
                                }
                                if let img:String = di["front_cover_url"] as? String
                                {
                                    tempDict["image"] = img
                                }
                                if let brand:String = di["brand"] as? String
                                {
                                    self.strBrand = brand
                                    self.lblAlert_Brand.text = "Marca: " + brand
                                }
                                if let title:String = di["gift_name"] as? String
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
                                self.arrData.append(tempDict)
                                
                                if let desc:String = di["description"] as? String
                                {
                                    let d1:[String:Any] = ["description": desc]
                                    self.arrData.append(d1)
                                }
                                
                                if let desc:String = di["brand_url"] as? String
                                {
                                    let d1:[String:Any] = ["hyperlink": desc, "title": "URL de la Marca"]
                                    self.arrData.append(d1)
                                }
                                
                                if let desc:String = di["store_url"] as? String
                                {
                                    let d1:[String:Any] = ["hyperlink": desc, "title": "URL de la Tienda"]
                                    self.arrData.append(d1)
                                }
                                
                                self.arrData.append(["label": "Cantidad", "id":2, "textfield":"Introducir cantidad"])
                                self.arrData.append(["label": "Denominaciones", "id":2, "picker":"Ingrese denominaciones"])
                                
                                if let arrPicker:[[String:Any]] = dicT["denominations"] as? [[String:Any]]
                                {
                                    self.pickerArr = arrPicker
                                }
                                
                                self.arrData.append(["button next": "Button Next", "id":2])
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
    
    func callConfirmBuyGift()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        var denom = 0
        if let picker:Int = dictPickerSelected["denomination"] as? Int
        {
            denom = picker
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "gift_id":strGiftID, "denomination":denom, "quantity": strTxtFld]
    //    print(param)
        WebService.requestService(url: ServiceName.POST_previewBuyGiftPost.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                // take to Confirm Password Screen
                                UIView.animate(withDuration: 0.5) {
                                    self.viewAlert.alpha = 0.0
                                }
                                
                                let vc: BuyGiftVC = BuyGiftVC(nibName: "BuyGiftVC", bundle: Bundle.main)
                                vc.dictMain = dict
                                vc.strQuantity = self.strTxtFld
                                vc.strGiftId = self.strGiftID
                                vc.modalPresentationStyle = .overFullScreen
                                vc.modalPresentationCapturesStatusBarAppearance = true
                                self.presentModal(vc: vc)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: Scroller Delegate
extension ExchangeDetailColl_ItemTappedVC: AACarouselDelegate
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
