//
//  EntListSub2VC.swift
//  Unefon
//
//  Created by Shalini Sharma on 7/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

import AVKit
import AVFoundation

class EntListSub2VC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    
    var arrData:[[String:Any]] = []
    var arrThumbnails:[UIImage] = []
    
    var check_IfWindowRotated = false
    var check_SetRotateWindow = false
    var portraitFrame:CGRect!
    
    var selectedVideoID = ""
    var playerViewController:LandscapePlayer!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portraitFrame = k_window.frame
        
        if arrData.count > 0
        {
            self.showSpinnerWith(title: "Cargando...")
            getImageThumbnailsForAllLinks()
        }
    }
    
    func getImageThumbnailsForAllLinks()
    {
        print("- - - - ", arrData.count)
        for d in arrData
        {
            print("\n")
            print(">>>>>> ", d)
            if let urlStr:String = d["video_url"] as? String
            {
                let videoURL = URL(string: urlStr)
                
                AVAsset(url: videoURL!).generateThumbnail { [weak self] (image) in
                    DispatchQueue.main.async {
                        guard let image = image else { return }
                        self!.arrThumbnails.append(image)
                        
                        self!.tblView.dataSource = self
                        self!.tblView.delegate = self
                        self!.tblView.estimatedRowHeight = 50
                        self!.tblView.rowHeight = UITableView.automaticDimension
                        
                        //print(arrData)
                        self!.tblView.reloadData()
                        
                        print("Thumbnails Count - - ", self!.arrThumbnails.count)
                        self!.hideSpinner()
                    }
                }
            }
        }
        
    }
    
}

extension EntListSub2VC: UITableViewDataSource, UITableViewDelegate
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
        let dict: [String:Any] = arrData[indexPath.row]
        let cell:Cell_EntListSub2 = tableView.dequeueReusableCell(withIdentifier: "Cell_EntListSub2", for: indexPath) as! Cell_EntListSub2
        cell.selectionStyle = .none
        
        cell.videoPlayer.layer.cornerRadius = 6.0
        cell.videoPlayer.layer.masksToBounds = true
        
        cell.lblTitle.text = ""
        cell.lblDesc.text = ""
        cell.btnPlay.isHidden = true
        cell.btnPlay.tag = indexPath.row
        
        if let str:String = dict["title"] as? String
        {
            cell.lblTitle.text = str
        }
        if let str:String = dict["content"] as? String
        {
            cell.lblDesc.text = str
        }
        if let _:String = dict["video_url"] as? String
        {
            cell.btnPlay.isHidden = false
            cell.btnPlay.addTarget(self, action: #selector(self.btnPlayClick(btn:)), for: .touchUpInside)
            
            let img:UIImage = arrThumbnails[indexPath.row]
            cell.setThumbnailToView(img: img)
        }
        return cell
    }
    
    @objc func btnPlayClick(btn:UIButton)
    {
        let dict: [String:Any] = arrData[btn.tag]
        
        if let urlStr:String = dict["video_url"] as? String
        {
            if let vID:String = dict["video_id"] as? String
            {
                selectedVideoID = vID
                
                callTrackingVideoStart(urlStr: urlStr)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("- > > > > Handle FORCE ROTATION - - - - - - - ")
        
        if check_IfWindowRotated == true
        {
            k_window.rotate(angle: -90)
            check_IfWindowRotated = false
            k_window.frame = portraitFrame
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if check_SetRotateWindow == true
        {
            check_SetRotateWindow = false
            check_IfWindowRotated = true
            k_window.rotate(angle: 90)
        }
    }
}

class LandscapePlayer: AVPlayerViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeLeft
    }
}

extension UIView {
    
    /**
     Rotate a view by specified degrees
     
     - parameter angle: angle in degrees
     */
    func rotate(angle angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }
    
}

extension EntListSub2VC
{
    func callTrackingVideoStart(urlStr:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "object_id":selectedVideoID]
    //    print(param)
        WebService.requestService(url: ServiceName.POST_TrackerVideoStart.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                // set Video and Play
                
                DispatchQueue.main.async {
                    self.check_SetRotateWindow = true
                    //            print(urlStr)
                    let videoURL = URL(string: urlStr)
                    let player = AVPlayer(url: videoURL!)
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)

                    self.playerViewController = LandscapePlayer()
                    
                    self.playerViewController.player = player
                    self.present(self.playerViewController, animated: true) {
                        self.playerViewController.player!.play()
                    }
                }
            }
        }
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        
        print("Video Ended - - - - -")
        
        self.playerViewController.dismiss(animated: true, completion: nil)
        playerViewController = nil
        NotificationCenter.default.removeObserver(self)
        
        callTrackingVideoEnd()
    }
    
    func callTrackingVideoEnd()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "object_id":selectedVideoID]
    //    print(param)
        WebService.requestService(url: ServiceName.POST_TrackerVideoEnd.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                // set Video and Play
                
                DispatchQueue.main.async {
                    self.selectedVideoID = ""
                }
            }
        }
    }
}
