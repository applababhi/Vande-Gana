//
//  FAQlistVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 5/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class FAQlistVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnAllQuestions:UIButton!
    @IBOutlet weak var btnMyQuestions:UIButton!
    @IBOutlet weak var btnAddQuestion:UIButton!
    @IBOutlet weak var viewTxtfld:UIView!
    @IBOutlet weak var btnSearch:UIButton!
    @IBOutlet weak var btnCancelSearch:UIButton!
    @IBOutlet weak var txtFld:UITextField!
    @IBOutlet weak var viewAllQLine:UIView!
    @IBOutlet weak var viewMyQLine:UIView!
    @IBOutlet weak var viewEmpty:UIView!
    @IBOutlet weak var tblViewSearch:UITableView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var isMyQuestionClick = false
    var arrAllQuestions: [[String:Any]] = []
    var arrMyQuestions: [[String:Any]] = []
    var arrSearch: [[String:Any]] = []
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callViewWillAppearios13(notfication:)), name: Notification.Name("viewWillAppear_FAQlistVC"), object: nil)
        
        setUpTopBar()

        lblTitle.text = "Foro de discusión"
        
        viewTxtfld.layer.cornerRadius = 5.0
        viewTxtfld.layer.borderWidth = 1.0
        viewTxtfld.layer.borderColor = k_baseColor.cgColor
        viewTxtfld.layer.masksToBounds = true
        
        txtFld.delegate = self
        txtFld.setPlaceHolderColorWith(strPH: "Busca una pregunta")
        btnAllQuestions.setTitleColor(k_baseColor, for: .normal)
        viewAllQLine.backgroundColor = k_baseColor
        btnMyQuestions.setTitleColor(UIColor.lightGray, for: .normal)
        viewMyQLine.backgroundColor = UIColor.lightGray
        
        btnAddQuestion.layer.cornerRadius = 5.0
        btnAddQuestion.layer.masksToBounds = true
        
        viewEmpty.isHidden = true
        tblViewSearch.isHidden = true
        btnCancelSearch.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetQuestionList()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
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
    
    @IBAction func addQuestionClick(btn:UIButton)
    {
        let vc: FAQCreateVC = AppStoryBoards.FAQ.instance.instantiateViewController(withIdentifier: "FAQCreateVC_ID") as! FAQCreateVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func todosClick(btn:UIButton)
    {
        tblViewSearch.isHidden = true
        isMyQuestionClick = false
        btnAllQuestions.setTitleColor(k_baseColor, for: .normal)
        viewAllQLine.backgroundColor = k_baseColor
        btnMyQuestions.setTitleColor(UIColor.lightGray, for: .normal)
        viewMyQLine.backgroundColor = UIColor.lightGray
        tblView.reloadData()
    }
    
    @IBAction func myQClick(btn:UIButton)
    {
        tblViewSearch.isHidden = true
        isMyQuestionClick = true
        btnMyQuestions.setTitleColor(k_baseColor, for: .normal)
        viewMyQLine.backgroundColor = k_baseColor
        btnAllQuestions.setTitleColor(UIColor.lightGray, for: .normal)
        viewAllQLine.backgroundColor = UIColor.lightGray
        tblView.reloadData()
    }
    
    @IBAction func searchClick(btn:UIButton)
    {
        if txtFld.text!.isEmpty == true
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            callGetSearchList(txt: txtFld.text!)
        }
    }
    
    @IBAction func cancelSearchClick(btn:UIButton)
    {
        self.txtFld.text = ""
        tblViewSearch.isHidden = true
        btnCancelSearch.isHidden = true
        callGetQuestionList()
    }
}

extension FAQlistVC
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

extension FAQlistVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView != tblViewSearch
        {
            if isMyQuestionClick == false
            {
                // Todos
                if arrAllQuestions.count == 0
                {
                    viewEmpty.isHidden = false
                }
                else
                {
                    viewEmpty.isHidden = true
                }
                return arrAllQuestions.count
            }
            else
            {
                if arrMyQuestions.count == 0
                {
                    viewEmpty.isHidden = false
                }
                else
                {
                    viewEmpty.isHidden = true
                }
                return arrMyQuestions.count
            }
        }
        else
        {
            // Search Table List
            return arrSearch.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView != tblViewSearch
        {
            return 170
        }
        else
        {
            // Search List
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView != tblViewSearch
        {
            let cell:CellFaqList = tableView.dequeueReusableCell(withIdentifier: "CellFaqList", for: indexPath) as! CellFaqList
            cell.selectionStyle = .none
            
            var dict:[String:Any]!
            
            if isMyQuestionClick == false
            {
                // Todos
                dict = arrAllQuestions[indexPath.row]
            }
            else
            {
                dict = arrMyQuestions[indexPath.row]
            }
            
            cell.lblTitle.text = ""
            cell.lblSubTitle.text = ""
            cell.lblReply.text = ""
            
            cell.viewBk.layer.cornerRadius = 5.0
            cell.viewBk.layer.borderWidth = 1.3
            cell.viewBk.layer.masksToBounds = true
            cell.btnViewAnswer.addTarget(self, action: #selector(self.btnViewAnswerClick(btn:)), for: .touchUpInside)
            cell.btnViewAnswer.layer.cornerRadius = 5.0
            cell.btnViewAnswer.layer.masksToBounds = true
            
            if let title:String = dict["title"] as? String
            {
                cell.lblTitle.text = title
            }
            if let title:String = dict["content_preview"] as? String
            {
                cell.lblSubTitle.text = title
            }
            if let title:String = dict["replies_str"] as? String
            {
                cell.lblReply.text = title
            }
            
            return cell
        }
        else
        {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellSearch", for: indexPath)
            cell.selectionStyle = .none
            
            cell.textLabel?.text = ""
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.textLabel?.font = UIFont(name: CustomFont.semiBold, size: 15.0)
            
            let dict:[String:Any]! = arrSearch[indexPath.row]
            
            if let title:String = dict["title"] as? String
            {
                cell.textLabel?.text = title
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == tblViewSearch
        {
            let dict:[String:Any]! = arrSearch[indexPath.row]
            if let id:String = dict["post_id"] as? String
            {
                let vc: FAQdetailVC = AppStoryBoards.FAQ.instance.instantiateViewController(withIdentifier: "FAQdetailVC_ID") as! FAQdetailVC
                vc.modalTransitionStyle = .crossDissolve
                vc.post_id = id
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc func btnViewAnswerClick(btn:UIButton)
    {
        print(btn.tag)
        
        var dict:[String:Any]!
        
        if isMyQuestionClick == false
        {
            // Todos
            dict = arrAllQuestions[btn.tag]
        }
        else
        {
            dict = arrMyQuestions[btn.tag]
        }
        
        if let id:String = dict["post_id"] as? String
        {
            let vc: FAQdetailVC = AppStoryBoards.FAQ.instance.instantiateViewController(withIdentifier: "FAQdetailVC_ID") as! FAQdetailVC
            vc.modalTransitionStyle = .crossDissolve
            vc.post_id = id
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension FAQlistVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension FAQlistVC
{
    func callGetQuestionList()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_FAQlist.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        self.arrAllQuestions.removeAll()
                        self.arrMyQuestions.removeAll()
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let arrDictAllQ: [[String:Any]] = dict["general_posts"] as? [[String:Any]]
                            {
                                self.arrAllQuestions = arrDictAllQ
                            }
                            if let arrDictMyQ: [[String:Any]] = dict["own_posts"] as? [[String:Any]]
                            {
                                self.arrMyQuestions = arrDictMyQ
                            }
                            
                            DispatchQueue.main.async {
                                if self.tblView.delegate == nil
                                {
                                    self.tblView.delegate = self
                                    self.tblView.dataSource = self
                                }
                                self.tblView.reloadData()
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callGetSearchList(txt:String)
    {
        var plan = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan_id.rawValue) as? String
        {
            plan = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan, "keywords":txt]
        WebService.requestService(url: ServiceName.POST_SearchFaq.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        self.arrSearch.removeAll()
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrSearch = arr

                            DispatchQueue.main.async {
                                if self.tblViewSearch.delegate == nil
                                {
                                    self.tblViewSearch.delegate = self
                                    self.tblViewSearch.dataSource = self
                                }
                                self.tblViewSearch.reloadData()
                                self.tblViewSearch.isHidden = false
                                self.btnCancelSearch.isHidden = false
                            }
                        }
                    }
                }
            }
        }
    }
}
