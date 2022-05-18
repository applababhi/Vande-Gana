//
//  Objective3VC.swift
//  Unefon
//
//  Created by Abhishek Visa on 6/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class Objective3VC: UIViewController {
    
    @IBOutlet weak var collView:UICollectionView!
    
    var arrData: [[String:Any]] = []

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collView.dataSource = self
        collView.delegate = self
    }
}

extension Objective3VC
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

extension Objective3VC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CellCollObj4 = collView.dequeueReusableCell(withReuseIdentifier: "CellCollObj4", for: indexPath) as! CellCollObj4
        cell.lblTitle.text = ""
        cell.lblDescription.text = ""
        cell.txtVDescription.text = ""
        cell.lblDescription.isHidden = true
        cell.txtVDescription.font = UIFont(name: CustomFont.regular, size: 15.0)
        
       // ["channel": YouTube, "content":  , "creation_date": 2019-09-20T00:00:00, "promotion_id": 57b037d1153f801788d655c4c357dfd4, "title": UNEFON ILIMITADO NO HA MUERTO, "video_url": https://www.youtube.com/embed/ur7WqenB3UY]
        
        cell.txtVDescription.setContentOffset(.zero, animated: false)
        
        if let title:String = dict["title"] as? String
        {
            cell.lblTitle.text = title.capitalized
        }
        if let title:String = dict["content"] as? String
        {
            cell.lblDescription.text = title
            cell.txtVDescription.text = title
        }
        if let url:String = dict["video_url"] as? String
        {
            // Load video from YouTube URL not working only for Unefon videos
            // let myVideoURL = NSURL(string: url)
            // cell.videoPlayer.loadVideoURL(myVideoURL! as URL)
            
            // we now display with vido id
            let arr:[String] = url.components(separatedBy: "/")
            cell.videoPlayer.load(withVideoId: "\(arr.last!)")
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // To Change Cell Size Dynamically
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let dict:[String:Any] = arrData[indexPath.item]
        let WidthOfContent = (collectionView.frame.size.width/2.0) - 10
        
        /*
         let constItemsHeight = CGFloat(60+170)
         var heightDesc:CGFloat = 0.0
         
         if let desc:String = dict["content"] as? String
         {
         heightDesc = desc.height(withConstrainedWidth: WidthOfContent, font: UIFont(name: CustomFont.regular, size: 16.0)!)
         }
         */
        let size = CGSize(width: WidthOfContent, height: 330)
        return size
    }
}
