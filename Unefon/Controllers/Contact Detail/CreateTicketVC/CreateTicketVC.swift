//
//  CreateTicketVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 5/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CreateTicketVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var txtView:UITextView!
    @IBOutlet weak var btnCreate:UIButton!
    @IBOutlet weak var viewBk:UIView!
    var focusManagerTF : FocusManager?
    @IBOutlet weak var tfPicker: UnderlineTextField!
    var planPicker : UIPickerView!
    var pickerArr: [[String:Any]] = []
    var idPickerSelected: Int!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!


    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopBar()
        txtView.delegate = self
        lblTitle.text = "Crear un nuevo Ticket de Ayuda"
        btnCreate.layer.cornerRadius = 5.0
        btnCreate.layer.masksToBounds = true
        
        viewBk.layer.cornerRadius = 5.0
        viewBk.layer.borderWidth = 1.3
        viewBk.layer.masksToBounds = true

        self.focusManagerTF = FocusManager()
        if let focusManager = self.focusManagerTF {
            focusManager.addItem(item: self.tfPicker)
        }
        
        callPickerListApi()
        
        tfPicker.delegate = self
        tfPicker.setPlaceHolderColorWith(strPH: "Tema Values")
        addRightPaddingTo(TextField: tfPicker, imageName: "down")
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_ContactVC"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createClicked(btn:UIButton)
    {
        if txtView.text!.isEmpty == true && idPickerSelected != nil
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            callSubmitTicket()
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

extension CreateTicketVC
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

extension CreateTicketVC:  UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    }
}

extension CreateTicketVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            focusManagerTF!.focusTouch(item: textField)
        }
        
        if pickerArr.count > 0
        {
            showPickerView()
        }
        else
        {
            textField.resignFirstResponder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            let control = textField as! UnderlineTextField
            control.updateFocus(isFocus: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension CreateTicketVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        self.planPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.planPicker.delegate = self
        self.planPicker.dataSource = self
        self.planPicker.backgroundColor = UIColor.white
        tfPicker.inputView = self.planPicker
        
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
        tfPicker.inputAccessoryView = toolBar
    }
    
    @objc func donePickerClick() {
        planPicker.removeFromSuperview()
        tfPicker.resignFirstResponder()
    }
    @objc func cancelPickerClick() {
        planPicker.removeFromSuperview()
        tfPicker.resignFirstResponder()
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
        if let str = dict["value"] as? String
        {
            strTitle = str
        }
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dict:[String:Any] = pickerArr[row]
        if let str = dict["value"] as? String
        {
            tfPicker.text = str
        }
        if let sID = dict["id"] as? Int
        {
            idPickerSelected = sID
        }
    }
}

extension CreateTicketVC
{
    func callPickerListApi()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["catalogue_id":"4"]
        WebService.requestService(url: ServiceName.GET_StatesList.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        self.pickerArr.removeAll()
                        var strState = ""
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let valArr:[[String:Any]] = dict["values"] as? [[String:Any]]
                            {
                                self.pickerArr = valArr
                                
                                if valArr.count > 0
                                {
                                    let d:[String:Any] = valArr.first!
                                    if let name:String = d["value"] as? String
                                    {
                                        strState = name
                                    }
                                    if let sID = d["id"] as? Int
                                    {
                                        self.idPickerSelected = sID
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.tfPicker.text = strState
                        }
                    }
                }
            }
        }
    }
    
    func callSubmitTicket()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "type":idPickerSelected!, "problem_description":txtView.text!]
        WebService.requestService(url: ServiceName.POST_CreateTicket.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
        //       print(jsonString)
            
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
                        if let _:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                if let msg:String = json["message"] as? String
                                {
                                    self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.back))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func back()
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_ContactVC"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

