//
//  NewsListVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 3/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class NewsListVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrData: [[String:Any]] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()

        lblTitle.text = "Anuncios"
        
        tblView.estimatedRowHeight = 44
        tblView.rowHeight = UITableView.automaticDimension
        tblView.dataSource = self
        tblView.delegate = self
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
       // NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
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

extension NewsListVC
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

extension NewsListVC: UITableViewDataSource, UITableViewDelegate
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
        let cell:CellNewsList = tableView.dequeueReusableCell(withIdentifier: "CellNewsList", for: indexPath) as! CellNewsList
        cell.selectionStyle = .none
        
        var dict:[String:Any] = arrData[indexPath.row]
        
        if isPad
        {
            cell.c_imgView_Ht_iPad.constant = 240
        }
        
        cell.imgView.image = nil
        cell.lblTitle.text = ""
        cell.lblDate.text = ""
        cell.lblDescription.text = ""
        
        cell.btnDownload.backgroundColor = .clear
        cell.btnDownload.setTitleColor(UIColor(named: "App_Blue")!, for: .normal)
        
        cell.btnDownload.layer.cornerRadius = 25.0
        cell.btnDownload.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
        cell.btnDownload.layer.borderWidth = 1.0
        cell.btnDownload.layer.masksToBounds = true
        cell.btnDownload.tag = indexPath.row
        cell.btnDownload.addTarget(self, action: #selector(self.btnDownloadClick(btn:)), for: .touchUpInside)
        cell.btnDownload.isHidden = true
        
        if let url:String = dict["attachment_url"] as? String
        {
            if url != ""
            {
                cell.btnDownload.isHidden = false
            }
        }
        
        if let title:String = dict["title"] as? String
        {
            cell.lblTitle.text = title
        }
        if let title:String = dict["cover_high_res_url"] as? String
        {
            cell.imgView.setImageUsingUrl(title)
        }
        if let title:String = dict["publish_date_str"] as? String
        {
            cell.lblDate.text = title
        }
        if let title:String = dict["content"] as? String
        {
            cell.lblDescription.text = title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    @objc func btnDownloadClick(btn:UIButton)
    {
        var dict:[String:Any] = arrData[btn.tag]
        if let url:String = dict["attachment_url"] as? String
        {
            if url != ""
            {
                let vc: NewsDetailVC = AppStoryBoards.NewsDetail.instance.instantiateViewController(withIdentifier: "NewsDetailVC_ID") as! NewsDetailVC
                vc.modalTransitionStyle = .crossDissolve
                if let titke:String = dict["title"] as? String
                {
                    vc.strTitle = titke
                }
                vc.pdfFilePath = url
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
