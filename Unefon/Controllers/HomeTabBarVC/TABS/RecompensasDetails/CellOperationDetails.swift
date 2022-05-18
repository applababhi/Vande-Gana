//
//  CellOperationDetails.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/10/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CollCell_OperationDetails: UICollectionViewCell {
    @IBOutlet weak var lblLeft:UILabel!
    @IBOutlet weak var lblRight:UILabel!
}

class CellOperationDetails: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblTitle_1:UILabel!
    @IBOutlet weak var lblTitle_2:UILabel!
    @IBOutlet weak var lblSubTitle_1:UILabel!
    @IBOutlet weak var lblSubTitle_2:UILabel!
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

extension CellOperationDetails : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CollCell_OperationDetails = collView.dequeueReusableCell(withReuseIdentifier: "CollCell_OperationDetails", for: indexPath) as! CollCell_OperationDetails
        cell.lblLeft.text = ""
        cell.lblRight.text = ""
                
        if let title:String = dict["description"] as? String
        {
            cell.lblLeft.text = "\(indexPath.item + 1) " + title
        }
        if let str:String = dict["value"] as? String
        {
            cell.lblRight.text = str
            if let col:String = dict["value_color"] as? String
            {
                cell.lblRight.textColor = UIColor.colorWithHexString(col)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {}
    
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
        let size = CGSize(width: WidthOfContent, height: 40)
        return size
    }
}
