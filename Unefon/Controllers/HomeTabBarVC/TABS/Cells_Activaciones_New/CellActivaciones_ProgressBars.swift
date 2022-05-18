//
//  CellActivaciones_ProgressBars.swift
//  Unefon
//
//  Created by Shalini Sharma on 2/26/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit
import LinearProgressBar

class CellActivaciones_ProgressBars: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblTitle_1:UILabel!
    @IBOutlet weak var lblTitle_2:UILabel!
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

    func setProgressBarGradient() -> CAGradientLayer{
        let fistColor = UIColor.green // UIColor.colorWithHexString("#0D0D0D")
        let lastColor = UIColor.yellow // UIColor.colorWithHexString("#1E1E1E")
        
        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.colors = [fistColor.cgColor, lastColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 5, y: 5, width: (self.bounds.size.width - 30), height: 20)
        
        return gradient
    }
}

class CollCell_ProgressBarNew: UICollectionViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSalesValue:UILabel!
    @IBOutlet weak var lblKpiValue:UILabel!
    @IBOutlet weak var progressBar: LinearProgressBar!
}

extension CellActivaciones_ProgressBars : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CollCell_ProgressBarNew = collView.dequeueReusableCell(withReuseIdentifier: "CollCell_ProgressBarNew", for: indexPath) as! CollCell_ProgressBarNew
        cell.lblTitle.text = ""
        cell.lblSalesValue.text = ""
        cell.lblKpiValue.text = ""
        
        if let name:String = dict["region_name"] as? String
        {
            if let progress:String = dict["progress_str"] as? String
            {
              //  let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.green]
                let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("C8C8C9")]
                let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("34CDF2")]
                let attributedString1 = NSMutableAttributedString(string:name + " ", attributes:attrs1)
                let attributedString2 = NSMutableAttributedString(string:progress, attributes:attrs2)
                attributedString1.append(attributedString2)
                cell.lblTitle.attributedText = attributedString1
            }
        }
        if let title:String = dict["sales_str"] as? String
        {
            cell.lblSalesValue.text = title
            
        }
        if let str:String = dict["kpi_str"] as? String
        {
            cell.lblKpiValue.text = str
        }
        
        if let valProgress:Double = dict["progress"] as? Double
        {
            // print("- - - - - - - - - - - - - - - -   ", valProgress)
            cell.progressBar.progressValue = CGFloat(valProgress * 100)
            
            cell.progressBar.capType = Int32(1) // to make progress bar inner proggress round
       //     cell.progressBar.layer.insertSublayer(self.setProgressBarGradient(), at: 0)
            cell.progressBar.barColor = UIColor.colorWithHexString("34CDF2") // blue
            cell.progressBar.trackColor = .clear
            cell.progressBar.barThickness = 15
            cell.progressBar.barPadding = 5
            
            cell.progressBar.layer.cornerRadius = 15.0
            cell.progressBar.layer.borderWidth = 2.3
            cell.progressBar.layer.borderColor = UIColor.white.cgColor
            cell.progressBar.layer.masksToBounds = true
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
        let size = CGSize(width: WidthOfContent, height: 128)
        return size
    }
}
