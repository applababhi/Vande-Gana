//
//  FAQCreateVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 5/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class FAQCreateVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var focusManagerTF : FocusManager?

    var arrRows: [[String:Any]] = [["type": "radio", "title":"Añadir pregunta o artículo", "ph":"", "height":110],
                                   ["type": "tf", "title":"Título", "ph":"Título", "height":80],
                                   ["type": "textView", "title":"Contenido", "ph":"Contenido", "height":160],
                                   ["type": "btnnext", "title":"SIGUIENTE", "ph":"", "height":60]
    ]

    var strTitleTF = ""
    var strTxtView = ""
    var strQuestionRadio = ""
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopBar()

        lblTitle.text = "Añadir pregunta o artículo"
        
        self.focusManagerTF = FocusManager()
        tblView.delegate = self
        tblView.dataSource = self
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_FAQlistVC"), object: nil)
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

extension FAQCreateVC
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

extension FAQCreateVC: UITextFieldDelegate, UITextViewDelegate
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
        
        strTitleTF = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tblView.reloadData()
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        strTxtView = textView.text!
    }
}

extension FAQCreateVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrRows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let d:[String:Any] = arrRows[indexPath.row] as! [String:Any]
        
        if let height: Int = d["height"] as? Int
        {
            return CGFloat(height)
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let d:[String:Any] = arrRows[indexPath.row] as! [String:Any]
        var strType:String = ""
        if let typ: String = d["type"] as? String
        {
            strType = typ
        }
        
        if strType.localizedStandardContains("radio") == true
        {
            // Gender
            let cell:CellFaqCreate_Radio = tblView.dequeueReusableCell(withIdentifier: "CellFaqCreate_Radio", for: indexPath) as! CellFaqCreate_Radio
            cell.selectionStyle = .none
            cell.imgQuestion.image = UIImage(named: "radioUnsel")
            cell.imgArticle.image = UIImage(named: "radioUnsel")
            
            if strQuestionRadio == "Pregunta"
            {
                cell.imgQuestion.image = UIImage(named: "radioSel")
            }
            else if strQuestionRadio == "Artículo"
            {
                cell.imgArticle.image = UIImage(named: "radioSel")
            }
            
            cell.btnQuestion.addTarget(self, action: #selector(self.btnQuestionClick(btn:)), for: .touchUpInside)
            cell.btnArticle.addTarget(self, action: #selector(self.btnArticleClick(btn:)), for: .touchUpInside)
            return cell
        }
        else if strType.localizedStandardContains("btnnext") == true
        {
            // Next Button
            let cell:Cell_Reg1_BtnNext = tblView.dequeueReusableCell(withIdentifier: "Cell_Reg1_BtnNext", for: indexPath) as! Cell_Reg1_BtnNext
            cell.selectionStyle = .none
            
            cell.btnNext.layer.cornerRadius = 5.0
            cell.btnNext.layer.masksToBounds = true
            cell.btnNext.addTarget(self, action: #selector(self.btnNextClick(btn:)), for: .touchUpInside)
            return cell
        }
        else if strType.localizedStandardContains("textView") == true
        {
            // Disable Picker
            let cell:CellFaqCreate_TxtView = tblView.dequeueReusableCell(withIdentifier: "CellFaqCreate_TxtView", for: indexPath) as! CellFaqCreate_TxtView
            cell.selectionStyle = .none
            
            cell.txtView.delegate = self
            cell.txtView.text = strTxtView
            
            cell.viewBk.layer.cornerRadius = 5.0
            cell.viewBk.layer.borderWidth = 1.3
            cell.viewBk.layer.masksToBounds = true
            
            return cell
        }
        else
        {
            // Normal Textfields
            let cell:Cell_Reg1_TF = tblView.dequeueReusableCell(withIdentifier: "Cell_Reg1_TF", for: indexPath) as! Cell_Reg1_TF
            cell.selectionStyle = .none
            
            if let focusManager = self.focusManagerTF {
                focusManager.addItem(item: cell.tf)
            }
            
            cell.tf.tag = indexPath.row
            cell.tf.keyboardType = .default
            cell.tf.delegate = self
            cell.tf.isUserInteractionEnabled = true
            cell.tf.textColor = UIColor.black
            cell.tf.isSecureTextEntry = false
            cell.inCellAddRightPaddingTo(TextField: cell.tf, imageName: "")
            
            if let title: String = d["title"] as? String
            {
                cell.lbl.text = title
            }
            if let ph: String = d["ph"] as? String
            {
                cell.tf.setPlaceHolderColorWith(strPH: ph)
            }
            
            cell.tf.text = strTitleTF
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FAQCreateVC
{
    // MARK: Actions
    
    @objc func btnQuestionClick(btn:UIButton)
    {
        strQuestionRadio = "Pregunta"
        tblView.reloadData()
    }
    
    @objc func btnArticleClick(btn:UIButton)
    {
        strQuestionRadio = "Artículo"
        tblView.reloadData()
    }
    
    @objc func btnNextClick(btn:UIButton)
    {
        if strTitleTF.isEmpty || strTxtView.isEmpty || strQuestionRadio.isEmpty
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            callCreatePost()
        }
    }
}

extension FAQCreateVC
{
    func callCreatePost()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        var radio = 1
        
        if strQuestionRadio == "Pregunta"
        {
            radio = 1
        }
        else
        {
            radio = 2
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "title":strTitleTF, "content":strTxtView, "type": radio, "image_media_id":""]
        WebService.requestService(url: ServiceName.POST_FAQCreatePost.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.back))
                        }
                    }
                }
            }
        }
    }
    
    @objc func back()
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_FAQlistVC"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
