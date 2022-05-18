//
//  CellVarDetail.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/11/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CellVarDetail: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var txtView:TapableTextView!
    @IBOutlet weak var lbl_1:UILabel!
    @IBOutlet weak var lbl_2:UILabel!
    @IBOutlet weak var lbl_3:UILabel!
    @IBOutlet weak var lbl_4:UILabel!
    @IBOutlet weak var lbl_5:UILabel!
    @IBOutlet weak var btn:UIButton!
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

extension CellVarDetail : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CollCell_Var = collView.dequeueReusableCell(withReuseIdentifier: "CollCell_Var", for: indexPath) as! CollCell_Var
        cell.lbl_1.text = ""
        cell.lbl_2.text = ""
        
        cell.vBk.layer.cornerRadius = 5.0
        cell.vBk.layer.masksToBounds = true

        
        if let title:String = dict["title"] as? String
        {
            cell.lbl_1.text = title
        }
        if let str:String = dict["value"] as? String
        {
            cell.lbl_2.text = str
        }
        
        cell.btn.addTarget(self, action: #selector(self.btnVerClick(btn:)), for: .touchUpInside)
        cell.btn.addTarget(self, action: #selector(self.btnVerShowColorChangeEffect(btn:)), for: .touchDown)
        return cell
    }
    
    @objc func btnVerShowColorChangeEffect(btn:UIButton)
    {
        btn.setTitleColor(.yellow, for: .normal)
    }
    
    @objc func btnVerClick(btn:UIButton)
    {
       // btn.setTitleColor(UIColor(named: "App_Blue")!, for: .normal)
        
        let dict:[String:Any] = arrData[btn.tag]
        if let str:String = dict["value"] as? String
        {
            print("Code to COpy.....", str)
            let pasteboard = UIPasteboard.general
            pasteboard.string = str
        }
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
        
//
//        let constItemsHeight = CGFloat(90)
//        var heightDesc:CGFloat = 0.0
//
//        if let desc:String = dict["description"] as? String
//        {
//            heightDesc = desc.height(withConstrainedWidth: 255, font: UIFont(name: CustomFont.regular, size: 16.0)!)
//        }
        
        let size = CGSize(width: WidthOfContent, height: 70)
        return size
    }
}
