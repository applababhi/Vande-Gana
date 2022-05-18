//
//  EntListSub3VC.swift
//  Unefon
//
//  Created by Shalini Sharma on 7/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class EntListSub3VC: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    
    var arrData:[[String:Any]] = []
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.dataSource = self
        self.tblView.delegate = self
        self.tblView.reloadData()
    }
    
}

extension EntListSub3VC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict: [String:Any] = arrData[indexPath.row]
        let cell:Cell_EntListSub3 = tableView.dequeueReusableCell(withIdentifier: "Cell_EntListSub3", for: indexPath) as! Cell_EntListSub3
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblSubTitle.text = ""
        
        cell.viewBk.layer.cornerRadius = 5.0
        cell.viewBk.layer.borderColor = UIColor.gray.cgColor
        cell.viewBk.layer.borderWidth = 0.7
        cell.viewBk.layer.masksToBounds = true
        
        if let str:String = dict["file_name"] as? String
        {
            cell.lblTitle.text = str
        }
        if let str:String = dict["size_str"] as? String
        {
            cell.lblSubTitle.text = str
        }
        if let imgStr:String = dict["icon_url"] as? String
        {
            cell.imgView.setImageUsingUrl(imgStr)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict: [String:Any] = arrData[indexPath.row]
        if let strPath:String = dict["full_url"] as? String
        {
            let urlString = strPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let titke:String = dict["file_name"] as? String
            {
                if let file:String = dict["file_id"] as? String
                {
                    callTrackingFileTapped(file_id: file, title: titke, urlString: urlString!)
                }
            }
        }
    }
}

extension EntListSub3VC
{
    func callTrackingFileTapped(file_id:String, title:String, urlString:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "object_id":file_id]
        WebService.requestService(url: ServiceName.POST_TrackerFileTap.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                let vc: NewsDetailVC = AppStoryBoards.NewsDetail.instance.instantiateViewController(withIdentifier: "NewsDetailVC_ID") as! NewsDetailVC
                vc.modalTransitionStyle = .crossDissolve
                vc.strTitle = title
                vc.check_backToEntertainmentDetailScreen = true
                vc.pdfFilePath = urlString
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
