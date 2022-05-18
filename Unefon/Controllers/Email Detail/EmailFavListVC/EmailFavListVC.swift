//
//  EmailFavListVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 3/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class EmailFavListVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnTodos:UIButton!
    @IBOutlet weak var btnFavorite:UIButton!
    @IBOutlet weak var viewTodosLine:UIView!
    @IBOutlet weak var viewFavoriteLine:UIView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var isFavoriteClick = false
    var arrAllEmails: [[String:Any]] = []
    var arrFavorites: [[String:Any]] = []
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callViewWillAppearios13(notfication:)), name: Notification.Name("viewWillAppear_EmailFavListVC"), object: nil)
        
        setUpTopBar()
        lblTitle.text = "Bandeja de Entrada"
        
        // Todos mis correos (10)
        btnTodos.setTitle("Todos mis correos", for: .normal)
        btnTodos.setTitleColor(k_baseColor, for: .normal)
        viewTodosLine.backgroundColor = k_baseColor
        btnFavorite.setTitleColor(UIColor.lightGray, for: .normal)
        viewFavoriteLine.backgroundColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetAllEmails()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func todosClick(btn:UIButton)
    {
        isFavoriteClick = false
        btnTodos.setTitleColor(k_baseColor, for: .normal)
        viewTodosLine.backgroundColor = k_baseColor
        btnFavorite.setTitleColor(UIColor.lightGray, for: .normal)
        viewFavoriteLine.backgroundColor = UIColor.lightGray
        tblView.reloadData()
    }
    
    @IBAction func favoriteClick(btn:UIButton)
    {
        isFavoriteClick = true
        btnFavorite.setTitleColor(k_baseColor, for: .normal)
        viewFavoriteLine.backgroundColor = k_baseColor
        btnTodos.setTitleColor(UIColor.lightGray, for: .normal)
        viewTodosLine.backgroundColor = UIColor.lightGray
        tblView.reloadData()
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

extension EmailFavListVC
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

extension EmailFavListVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isFavoriteClick == false
        {
            // Todos
            return arrAllEmails.count
        }
        else
        {
            return arrFavorites.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellEmailFavList = tableView.dequeueReusableCell(withIdentifier: "CellEmailFavList", for: indexPath) as! CellEmailFavList
        cell.selectionStyle = .none
        
        var dict:[String:Any]!
        
        if isFavoriteClick == false
        {
            // Todos
            dict = arrAllEmails[indexPath.row]
        }
        else
        {
            dict = arrFavorites[indexPath.row]
        }
        
        cell.lblTitle.text = ""
        cell.lblSubTitle.text = ""
        cell.lblDate.text = ""
        
        if let title:String = dict["subject"] as? String
        {
            cell.lblTitle.text = title
        }
        if let title:String = dict["snippet"] as? String
        {
            cell.lblSubTitle.text = title
        }
        if let title:String = dict["absolute_date_str"] as? String
        {
            cell.lblDate.text = title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var dict:[String:Any] = [:]
        if isFavoriteClick == false
        {
            // Todos
            dict = arrAllEmails[indexPath.row]
        }
        else
        {
            // Fav
            dict = arrFavorites[indexPath.row]
        }
        let vc: EmailFavDetailVC = AppStoryBoards.EmailDetail.instance.instantiateViewController(withIdentifier: "EmailFavDetailVC_ID") as! EmailFavDetailVC
        vc.modalTransitionStyle = .crossDissolve
        
        if let title:String = dict["subject"] as? String
        {
            vc.strHeader = title
        }
        if let mailID:String = dict["mail_id"] as? String
        {
            vc.strMailID = mailID
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true, completion: nil)
    }
}

extension EmailFavListVC
{
    func callGetAllEmails()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_EmailList.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
        //    print(jsonString)
            
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
                        self.arrAllEmails.removeAll()
                        self.arrFavorites.removeAll()
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let readCount:Int = dict["read_count"] as? Int
                            {
                                if let totalCount:Int = dict["inbox_count"] as? Int
                                {
                                    let count = totalCount - readCount
                                    if count > 0
                                    {
                                        self.btnTodos.setTitle("Todos mis correos (\(count))", for: .normal)
                                    }
                                    else
                                    {
                                        self.btnTodos.setTitle("Todos mis correos", for: .normal)
                                    }
                                }
                            }
                            if let favCount:Int = dict["favourites_count"] as? Int
                            {
                                if favCount > 0
                                {
                                    self.btnFavorite.setTitle("Favoritos (\(favCount))", for: .normal)
                                }
                                else
                                {
                                    self.btnFavorite.setTitle("Favoritos", for: .normal)
                                }
                            }
                            
                            if let arr: [[String:Any]] = dict["mails"] as? [[String:Any]]
                            {
                                self.arrAllEmails = arr
                                
                                for d in self.arrAllEmails
                                {
                                    if let isFav:Int = d["is_favourite"] as? Int
                                    {
                                        if isFav == 1
                                        {
                                            self.arrFavorites.append(d)
                                        }
                                    }
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
}
