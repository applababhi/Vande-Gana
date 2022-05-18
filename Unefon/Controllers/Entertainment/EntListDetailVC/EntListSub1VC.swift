//
//  EntListSub1VC.swift
//  Unefon
//
//  Created by Shalini Sharma on 7/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class EntListSub1VC: UIViewController {

    @IBOutlet weak var btnTomarTest:UIButton!
    @IBOutlet weak var tblView:UITableView!
    
    var arrData:[[String:Any]] = []
    var check_showTomarTest = false
    var imgHeaderUrl = ""
    var courseID = ""
    var dictQuiz:[String:Any] = [:]


    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if check_showTomarTest == false
        {
            btnTomarTest.isHidden = true
        }
        btnTomarTest.layer.cornerRadius = 6.0
        btnTomarTest.layer.masksToBounds = true
        
        self.tblView.dataSource = self
        self.tblView.delegate = self
        tblView.estimatedRowHeight = 50
        tblView.rowHeight = UITableView.automaticDimension

        self.tblView.reloadData()
    }
    
    @IBAction func btnTomarClick(btn:UIButton)
    {
        print("Navigate to Q/A")
        callGetQuiz()
    }
}

extension EntListSub1VC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count + 1 // 1 for Header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 150
        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell:Cell_EntListSub1_Header = tableView.dequeueReusableCell(withIdentifier: "Cell_EntListSub1_Header", for: indexPath) as! Cell_EntListSub1_Header
            cell.selectionStyle = .none

            cell.imgView.setImageUsingUrl(imgHeaderUrl)
            return cell
        }
        else
        {
            let dict: [String:Any] = arrData[indexPath.row - 1]
            let cell:Cell_EntListSub1 = tableView.dequeueReusableCell(withIdentifier: "Cell_EntListSub1", for: indexPath) as! Cell_EntListSub1
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            cell.lblDesc.text = ""
            
            if let str:String = dict["title"] as? String
            {
                cell.lblTitle.text = str
            }
            if let str:String = dict["content"] as? String
            {
                cell.lblDesc.text = str
            }
            
            return cell
        }

    }
}

extension EntListSub1VC
{
    func callGetQuiz()
    {
        k_helper.arrTomar_QA.removeAll()
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "course_id":courseID]
        WebService.requestService(url: ServiceName.GET_EnterQuiz.rawValue, method: .get, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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

                        if let d:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let arr:[[String:Any]] = d["questions"] as? [[String:Any]]
                            {
                                for index in 0..<arr.count
                                {
                                    var d2p:[String:Any] = [:]
                                    let dip:[String:Any] = arr[index] as! [String:Any]
                                    var arrAnswers:[[String:Any]] = []
                                    
                                    if let dQ:[String:Any] = dip["question"] as? [String:Any]
                                    {
                                        if let Qname:String = dQ["content"] as? String
                                        {
                                            d2p["qTitle"] = Qname
                                        }
                                        if let Qid:String = dQ["question_id"] as? String
                                        {
                                            d2p["qId"] = Qid
                                        }
                                    }
                                    if let aA:[[String:Any]] = dip["options"] as? [[String:Any]]
                                    {
                                        for k in 0..<aA.count
                                        {
                                            var d2pA:[String:Any] = [:]
                                            let da:[String:Any] = aA[k] as! [String:Any]
                                           
                                            if let ans:String = da["content"] as? String
                                            {
                                                d2pA["aTitle"] = ans
                                            }
                                            if let ansId:String = da["option_id"] as? String
                                            {
                                                d2pA["aId"] = ansId
                                            }
                                            d2pA["selection"] = false
                                            arrAnswers.append(d2pA)
                                        }
                                        d2p["aArray"] = arrAnswers
                                    }
                                    k_helper.arrTomar_QA.append(d2p)
                                }
                                    
                                DispatchQueue.main.async {
                                    
                                    let vc: TomarTestVC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "TomarTestVC_ID") as! TomarTestVC
                                    
                                    if let da:[String:Any] = d["quizz"] as? [String:Any]
                                    {
                                        if let strT:String = da["name"] as? String
                                        {
                                            vc.strHeader_Title = strT
                                        }
                                        if let strI:String = da["instructions"] as? String
                                        {
                                            vc.strHeader_Instructions = strI
                                        }
                                        if let strQ:String = da["quizz_id"] as? String
                                        {
                                            vc.strQuizID = strQ
                                        }
                                        if let strC:String = da["course_id"] as? String
                                        {
                                            vc.strCourseID = strC
                                        }
                                    }
                                    
                                    vc.modalTransitionStyle = .crossDissolve
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
}
