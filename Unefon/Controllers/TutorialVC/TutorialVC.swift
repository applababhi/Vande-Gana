//
//  TutorialVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 11/8/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var baseView:UIView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!
    
    var arrVideo: [[String:Any]] = []    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTopBar()
        lblTitle.text = "LA PLATAFORMA"
        callVideos()
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
}

extension TutorialVC
{
    func callVideos()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_Objectives.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //                   print(jsonString)
            
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
                                if let arrObj4:[[String:Any]] = dict["tutorials"] as? [[String:Any]]
                                {
                                    let controller: Objective4VC = AppStoryBoards.Objectives.instance.instantiateViewController(withIdentifier: "Objective4VC_ID") as! Objective4VC
                                    controller.arrData = arrObj4
                                    
                                    controller.view.frame = self.baseView.bounds;
                                    controller.willMove(toParent: self)
                                    self.baseView.addSubview(controller.view)
                                    self.addChild(controller)
                                    controller.didMove(toParent: self)
                                    
                                    let dictTemp:[String:Any] = ["array":arrObj4]
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
