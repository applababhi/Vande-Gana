//
//  RankingListVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 4/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class RankingListVC: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    
    @IBOutlet weak var lblHeader1:UILabel!
    @IBOutlet weak var lblHeader2:UILabel!
    @IBOutlet weak var lblHeader3:UILabel!
    @IBOutlet weak var lblHeader4:UILabel!
    @IBOutlet weak var lblBar1:UILabel!
    @IBOutlet weak var lblBar2:UILabel!
    @IBOutlet weak var lblBar3:UILabel!
    @IBOutlet weak var viewBar1:UIView!
    @IBOutlet weak var viewBar2:UIView!
    @IBOutlet weak var viewBar3:UIView!
    
    @IBOutlet weak var lblInnerBar1:UILabel!
    @IBOutlet weak var lblInnerBar2:UILabel!
    @IBOutlet weak var lblInnerBar3:UILabel!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    let altColor: UIColor = UIColor.init(red: 248.0/255.0, green: 245.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    var arrData: [[String:Any]] = []
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()

        lblTitle.text = "Ranking"
        lblHeader1.text = ""
        lblHeader2.text = ""
        lblHeader3.text = ""
        lblHeader4.text = ""
        tblView.estimatedRowHeight = 44
        tblView.rowHeight = UITableView.automaticDimension
        
        viewBar1.layer.cornerRadius = 5.0
        viewBar1.layer.masksToBounds = true
        viewBar2.layer.cornerRadius = 5.0
        viewBar2.layer.masksToBounds = true
        viewBar3.layer.cornerRadius = 5.0
        viewBar3.layer.masksToBounds = true
        
        lblBar1.text = ""
        lblBar2.text = ""
        lblBar3.text = ""
        
        
        setLabelSuperScript(myLabel: lblInnerBar1, mainStr: "1", superScript: "ero")
        setLabelSuperScript(myLabel: lblInnerBar2, mainStr: "2", superScript: "ndo")
        setLabelSuperScript(myLabel: lblInnerBar3, mainStr: "3", superScript: "ero")
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setLabelSuperScript(myLabel: UILabel, mainStr:String, superScript:String)
    {
        if let largeFont = UIFont(name: "Helvetica", size: 15), let superScriptFont = UIFont(name: "Helvetica", size:10) {
            let numberString = NSMutableAttributedString(string: mainStr, attributes: [.font: largeFont])
            numberString.append(NSAttributedString(string: superScript, attributes: [.font: superScriptFont, .baselineOffset: 10]))
            myLabel.attributedText = numberString
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetRanking()
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

extension RankingListVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerCell: CellRanking_Header = tableView.dequeueReusableCell(withIdentifier: "CellRanking_Header") as! CellRanking_Header
        headerCell.selectionStyle = .none
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let other2LblWidth = CGFloat(190.0) // (112+70)
        
        let dict:[String:Any] = arrData[indexPath.row]
        if let title:String = dict["workplace_name"] as? String
        {
            let width = (tableView.frame.size.width - other2LblWidth)
            let height = title.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.regular, size: 17.0)!)
          //  print("- - - - - >", height)

            if height < 40.0
            {
                return 55
            }
            else
            {
                return UITableView.automaticDimension
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellRankingList = tableView.dequeueReusableCell(withIdentifier: "CellRankingList", for: indexPath) as! CellRankingList
        cell.selectionStyle = .none
        let dict:[String:Any] = arrData[indexPath.row]
        
        cell.lblPosition.text = ""
        cell.lblStore.text = ""
        cell.lblPerformance.text = ""
        
        if (indexPath.row % 2 == 0)
        {
            cell.viewBk.backgroundColor = UIColor.white
        }
        else
        {
            cell.viewBk.backgroundColor = altColor
        }
        
        if let title:Int  = dict["position"] as? Int
        {
            cell.lblPosition.text = "\(title)"
        }
        if let title:String  = dict["workplace_name"] as? String
        {
            cell.lblStore.text = title
        }
        if let title:String  = dict["accumulated_points_str"] as? String
        {
            cell.lblPerformance.text = title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}

extension RankingListVC
{
    func callGetRanking()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_Ranking.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        self.arrData.removeAll()
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let arrT: [[String:Any]] = dict["all_users"] as? [[String:Any]]
                            {
                                self.arrData = arrT
                            }
                            
                            DispatchQueue.main.async {
                                
                                if let st: String = dict["level_name"] as? String
                                {
                                    self.lblHeader1.text = st
                                }
                                if let st: String = dict["message"] as? String
                                {
                                    self.lblHeader2.text = st
                                    
                                    if st.count > 75
                                    {
                                        self.lblHeader2.font = UIFont(name: CustomFont.semiBold, size: 14)
                                    }
                                }
                                if let st: String = dict["list_title"] as? String
                                {
                                    self.lblHeader3.text = st
                                }
                                if let st: String = dict["period_title"] as? String
                                {
                                    self.lblHeader4.text = st
                                }
                                
                                if let arrChart: [[String:Any]] = dict["podium"] as? [[String:Any]]
                                {
                                    if arrChart.count == 3
                                    {
                                        for index in 0..<arrChart.count
                                        {
                                            let dic:[String:Any] = arrChart[index]
                                            if let str: String = dic["workplace_name"] as? String
                                            {
                                                if index == 0
                                                {
                                                    self.lblBar1.text = str
                                                }
                                                else  if index == 1
                                                {
                                                    self.lblBar2.text = str
                                                }
                                                else  if index == 2
                                                {
                                                    self.lblBar3.text = str
                                                }
                                            }
                                        }
                                    }
                                    
                                    
                                }
                                
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
