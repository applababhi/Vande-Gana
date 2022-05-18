//
//  CellRankingNew_Listing.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/2/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CellRankingNew_Listing: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var collView:UICollectionView!

    var arrData: [[String:Any]] = []{
        didSet{
            if collView.dataSource == nil{
                collView.dataSource = self
                collView.delegate = self
            }
                collView.reloadData()
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class CollCell_RankList: UICollectionViewCell {
    @IBOutlet weak var lblLeft:UILabel!
    @IBOutlet weak var lblMiddle:UILabel!
    @IBOutlet weak var lblRight:UILabel!
}

extension CellRankingNew_Listing : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CollCell_RankList = collView.dequeueReusableCell(withReuseIdentifier: "CollCell_RankList", for: indexPath) as! CollCell_RankList
        cell.lblLeft.text = ""
        cell.lblMiddle.text = ""
        cell.lblRight.text = ""
                
        if let title:Int = dict["position"] as? Int
        {
            cell.lblLeft.text = "\(title)"
            
        }
        if let str:String = dict["workplace_name"] as? String
        {
            cell.lblMiddle.text = str
        }
        if let str:String = dict["accumulated_points_str"] as? String
        {
            cell.lblRight.text = str
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    // To Change Cell Size Dynamically
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       // let dict:[String:Any] = arrData[indexPath.item]
        let WidthOfContent = collectionView.frame.size.width
        
        /*
        let constItemsHeight = CGFloat(60+170)
        var heightDesc:CGFloat = 0.0
        
        if let desc:String = dict["content"] as? String
        {
            heightDesc = desc.height(withConstrainedWidth: WidthOfContent, font: UIFont(name: CustomFont.regular, size: 16.0)!)
        }
        */
        let size = CGSize(width: WidthOfContent, height: 35)
        return size
    }
}
