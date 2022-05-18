//
//  FAQdetailVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 5/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class FAQdetailVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrReplies: [[String:Any]] = [[:]]
    var post_id:String = ""
    var strTitle = ""
    var strBlueText = ""
    var strSubTitle = ""
    var strImage = ""
    var canMarkSolution = 0
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopBar()

        lblTitle.text = "cada cuándo actualizan Ios puntos?"
        
        callGetFullPost()
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

extension FAQdetailVC
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

extension FAQdetailVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrReplies.count + 1  // +1 for header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 365
        }
        else
        {
            // replies
            return 170
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            // Header
            let cell:CellFaqDetail_Header = tableView.dequeueReusableCell(withIdentifier: "CellFaqDetail_Header", for: indexPath) as! CellFaqDetail_Header
            cell.selectionStyle = .none
            
            cell.btnReply.layer.cornerRadius = 5.0
            cell.btnReply.layer.masksToBounds = true
            cell.btnReply.addTarget(self, action: #selector(self.btnReplyClick(btn:)), for: .touchUpInside)
            
            cell.lblTitle.text = strTitle
            cell.lblSubtitle.text = strSubTitle
            cell.btnDate.setTitle(strBlueText, for: .normal)
            
            cell.imgView.layer.cornerRadius = 45.0
            cell.imgView.layer.borderWidth = 0.3
            cell.imgView.layer.masksToBounds = true
            cell.imgView.setImageUsingUrl(strImage)
            
            return cell
        }
        else
        {
            // replies
            let cell:Cell_FaqReply = tableView.dequeueReusableCell(withIdentifier: "Cell_FaqReply", for: indexPath) as! Cell_FaqReply
            cell.selectionStyle = .none
            cell.viewBk.layer.cornerRadius = 5.0
            cell.viewBk.layer.borderWidth = 1.0
            cell.viewBk.layer.masksToBounds = true
            cell.btnMarkSolution.layer.cornerRadius = 5.0
            cell.lblTitle.text = ""
            cell.lblSubtitle.text = ""
            cell.lblCount.text = ""
            cell.imgTick.isHidden = true
            cell.btnMarkSolution.isHidden = true
            cell.btnMarkSolution.tag = indexPath.row - 1
            cell.btnMarkSolution.addTarget(self, action: #selector(self.btnMarkSolutionClick(btn:)), for: .touchUpInside)
            cell.btnLike.tag = indexPath.row - 1
            cell.btnLike.addTarget(self, action: #selector(self.btnLikeClick(btn:)), for: .touchUpInside)
            cell.btnDislike.tag = indexPath.row - 1
            cell.btnDislike.addTarget(self, action: #selector(self.btnDisLikeClick(btn:)), for: .touchUpInside)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false

            if canMarkSolution == 1
            {
                cell.btnMarkSolution.isHidden = false
            }
            
            let d:[String:Any] = arrReplies[indexPath.row - 1] as! [String:Any]
            
            if let str:String = d["content"] as? String
            {
                cell.lblTitle.text = str
            }
            if let str:String = d["signature"] as? String
            {
                cell.lblSubtitle.text = str
            }
            if let str:String = d["score_str"] as? String
            {
                cell.lblCount.text = str
            }
            
            if let check:Int = d["can_vote"] as? Int
            {
                if check == 1
                {
                    cell.btnLike.isUserInteractionEnabled = true
                    cell.btnDislike.isUserInteractionEnabled = true
                }
            }
            
            if let check:Int = d["is_solution"] as? Int
            {
                if check == 1
                {
                    cell.imgTick.isHidden = false
                    cell.btnMarkSolution.isHidden = true // if its a solution then hide Can Mark Solu
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    @objc func btnReplyClick(btn:UIButton)
    {
        print(btn.tag)
    }
    
    @objc func btnLikeClick(btn:UIButton)
    {
        print(btn.tag)
        let d:[String:Any] = arrReplies[btn.tag] as! [String:Any]
        if let str:String = d["reply_id"] as? String
        {
            callLikePost(replyID: str)
        }
    }
    
    @objc func btnDisLikeClick(btn:UIButton)
    {
        print(btn.tag)
        let d:[String:Any] = arrReplies[btn.tag] as! [String:Any]
        if let str:String = d["reply_id"] as? String
        {
            callDislikePost(replyID: str)
        }
    }
    
    @objc func btnMarkSolutionClick(btn:UIButton)
    {
        print(btn.tag)
        let d:[String:Any] = arrReplies[btn.tag] as! [String:Any]
        if let str:String = d["reply_id"] as? String
        {
            callMarkSolution(replyID: str)
        }
    }
}

extension FAQdetailVC
{
    func callGetFullPost()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["post_id":post_id]
        WebService.requestService(url: ServiceName.GET_FAQPost.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        self.arrReplies.removeAll()
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let dic: [String:Any] = dict["post"] as? [String:Any]
                            {
                                if let str: String = dic["title"] as? String
                                {
                                    self.strTitle = str
                                }
                                if let str: String = dic["signature"] as? String
                                {
                                    self.strBlueText = str
                                }
                                if let str: String = dic["content"] as? String
                                {
                                    self.strSubTitle = str
                                }
                                if let str: String = dic["profile_picture_url"] as? String
                                {
                                    self.strImage = str
                                }
                                if let can: Int = dic["can_mark_solution"] as? Int
                                {
                                    self.canMarkSolution = can
                                }
                            }
                            
                            if let arrDict: [[String:Any]] = dict["replies"] as? [[String:Any]]
                            {
                                self.arrReplies = arrDict
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
    
    func callLikePost(replyID:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "reply_id":replyID]
        WebService.requestService(url: ServiceName.POST_FAQLike.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
   //         print(jsonString)
            
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
                            self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            self.callGetFullPost()
                        }
                    }
                }
            }
        }
    }
    
    func callDislikePost(replyID:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "reply_id":replyID]
        WebService.requestService(url: ServiceName.POST_FAQDisLike.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //         print(jsonString)
            
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
                            self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            self.callGetFullPost()
                        }
                    }
                }
            }
        }
    }
    
    func callMarkSolution(replyID:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "reply_id":replyID]
        WebService.requestService(url: ServiceName.POST_FAQDMarkSolution.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
          //           print(jsonString)
            
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
                            self.showAlertWithTitle(title: "AT&T", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            self.callGetFullPost()
                        }
                    }
                }
            }
        }
    }
}
