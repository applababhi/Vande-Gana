//
//  CellVar.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/11/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CollCell_Var: UICollectionViewCell {
    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lbl_1:UILabel!
    @IBOutlet weak var lbl_2:UILabel!
    @IBOutlet weak var lbl_3:UILabel!
    @IBOutlet weak var btn:UIButton!
}

class CellVar: UITableViewCell {
    
    @IBOutlet weak var lbl_1:UILabel!
    @IBOutlet weak var lbl_2:UILabel!
    @IBOutlet weak var lbl_3:UILabel!
    @IBOutlet weak var btn_1:UIButton!
    @IBOutlet weak var btn_2:UIButton!
    
    @IBOutlet weak var collView:UICollectionView!
    var isMisPedidos = false
    var closure:([String:Any]) -> () = {_ in}

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

extension CellVar : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]

        if isMisPedidos == true
        {
            let cell:CollCell_Var = collView.dequeueReusableCell(withReuseIdentifier: "CollCell_Var_Pedios", for: indexPath) as! CollCell_Var
            cell.lbl_1.text = ""
            cell.lbl_2.text = ""
            
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.btn.layer.cornerRadius = 16.0
            cell.btn.layer.borderWidth = 1.0
            cell.btn.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
            cell.btn.layer.masksToBounds = true
                cell.btn.alpha = 1.0
                cell.btn.isUserInteractionEnabled = true
                    
            if let title:String = dict["product_name"] as? String
            {
                cell.lbl_1.text = title
            }
            if let str:String = dict["description"] as? String
            {
                cell.lbl_2.text = str
            }
            
            cell.btn.tag = indexPath.item
            cell.btn.addTarget(self, action: #selector(self.btnVerClick(btn:)), for: .touchUpInside)
            return cell
        }
        else
        {
            let cell:CollCell_Var = collView.dequeueReusableCell(withReuseIdentifier: "CollCell_Var", for: indexPath) as! CollCell_Var
            cell.lbl_1.text = ""
            cell.lbl_2.text = ""
            cell.lbl_3.text = ""
            
            cell.vBk.layer.cornerRadius = 5.0
            cell.vBk.layer.masksToBounds = true
            
            cell.btn.layer.cornerRadius = 16.0
            cell.btn.layer.borderWidth = 1.0
            cell.btn.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
            cell.btn.layer.masksToBounds = true
            
            cell.btn.alpha = 0.15
            cell.btn.isUserInteractionEnabled = false
            
            if let check:Int = dict["status"] as? Int
            {
                if check == 2
                {
                    cell.btn.alpha = 1.0
                    cell.btn.isUserInteractionEnabled = true
                }
            }
            
            if let title:String = dict["title"] as? String
            {
                cell.lbl_1.text = title
            }
            if let str:String = dict["hashed_code"] as? String
            {
                cell.lbl_2.text = str
            }
            if let str:String = dict["description"] as? String
            {
                cell.lbl_3.text = str
            }
            
            cell.btn.tag = indexPath.item
            cell.btn.addTarget(self, action: #selector(self.btnVerClick(btn:)), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func btnVerClick(btn:UIButton)
    {
        let dict:[String:Any] = arrData[btn.tag]
        closure(dict)
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
        let dict:[String:Any] = arrData[indexPath.item]
        let WidthOfContent = collectionView.frame.size.width
        
        
        let constItemsHeight = CGFloat(90)
        var heightDesc:CGFloat = 0.0
        
        if let desc:String = dict["description"] as? String
        {
            heightDesc = desc.height(withConstrainedWidth: 255, font: UIFont(name: CustomFont.regular, size: 16.0)!)
        }
        
        let size = CGSize(width: WidthOfContent, height: heightDesc + constItemsHeight)
        return size
    }
}
