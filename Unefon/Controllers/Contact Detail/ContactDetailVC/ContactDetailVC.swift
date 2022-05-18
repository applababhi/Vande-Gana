//
//  ContactDetailVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 9/8/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class ContactDetailVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrData: [String] = []
    var dictData:[String:Any] = [:]
    var strTicketID = ""
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopBar()
        lblTitle.text = "Detalles del ticket"
        tblView.estimatedRowHeight = 30
        tblView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetList()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_ContactVC"), object: nil)
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

extension ContactDetailVC
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

extension ContactDetailVC
{
    func callGetList()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["ticket_id":strTicketID]
        WebService.requestService(url: ServiceName.GET_TicketDetail.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        self.dictData.removeAll()
                        if let dictQ:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            self.dictData = dictQ
                            
                            if let status:Int = dictQ["status"] as? Int
                            {
                                if status == 0
                                {
                                    self.arrData = ["Fecha de creación:", "Tema:", "Status:", "Descripción:", "Respuesta:"]
                                }
                                else
                                {
                                    self.arrData = ["Fecha de creación:", "Tema:", "Status:", "Descripción:", "Fecha Respuesta:", "Respuesta:"]
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
}

extension ContactDetailVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellContact_Detail = tableView.dequeueReusableCell(withIdentifier: "CellContact_Detail", for: indexPath) as! CellContact_Detail
        cell.selectionStyle = .none
        
        let str:String = arrData[indexPath.row]
        
        cell.lblTitle.text = ""
        cell.lblSubTitle.text = ""
        
        if str == "Fecha de creación:"
        {
            cell.lblTitle.text = str
            if let stitle:String = dictData["request_date_str"] as? String
            {
                cell.lblSubTitle.text = stitle
            }
        }
        else if str == "Tema:"
        {
            cell.lblTitle.text = str
            if let stitle:String = dictData["type_str"] as? String
            {
                cell.lblSubTitle.text = stitle
            }
        }
        else if str == "Status:"
        {
            cell.lblTitle.text = str
            if let stitle:String = dictData["status_str"] as? String
            {
                cell.lblSubTitle.text = stitle
            }
        }
        else if str == "Descripción:"
        {
            cell.lblTitle.text = str
            if let stitle:String = dictData["problem_description"] as? String
            {
                cell.lblSubTitle.text = stitle
            }
        }
        else if str == "Fecha Respuesta:"
        {
            cell.lblTitle.text = str
            if let stitle:String = dictData["solution_date_str"] as? String
            {
                cell.lblSubTitle.text = stitle
            }
        }
        else if str == "Respuesta:"
        {
            cell.lblTitle.text = str
            if let stitle:String = dictData["solution_description"] as? String
            {
                cell.lblSubTitle.text = stitle
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
}
