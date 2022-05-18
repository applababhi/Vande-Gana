//
//  HistoryChartVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 22/2/20.
//  Copyright © 2020 Shalini. All rights reserved.
//

import UIKit

class HistoryChartVC: UIViewController {

    @IBOutlet weak var collView:UICollectionView!
    var arr_BarsCollV:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collView.delegate = self
        collView.dataSource = self
        collView.reloadData()
    }
    
    func scrollToNextCell(){

        //get cell size
        let cellSize = view.frame.size

        //get current content Offset of the Collection view
        let contentOffset = collView.contentOffset

        if collView.contentSize.width <= collView.contentOffset.x + cellSize.width
        {
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            collView.scrollRectToVisible(r, animated: true)

        } else {
            let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            collView.scrollRectToVisible(r, animated: true);
        }

    }
    
    @IBAction func btnLeftClick(btn:UIButton)
    {
        print("Left Click")
        
        scrollToNextCell()
    }
    
    @IBAction func btnRightClick(btn:UIButton)
    {
        print("Right Click")
        
        scrollToNextCell()
    }
}

extension HistoryChartVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_BarsCollV.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arr_BarsCollV[indexPath.item]
        
        let cell:CollCellHistoryChart = collView.dequeueReusableCell(withReuseIdentifier: "CollCellHistoryChart", for: indexPath) as! CollCellHistoryChart
        cell.lblWeekName.text = ""
        cell.lblBar1.text = ""
        cell.lblBar2.text = ""
        cell.lblBar1.textColor = UIColor(named: "App_LightGrey")!
        cell.lblBar2.textColor = UIColor(named: "App_Blue")!
        cell.lblWeekName.textColor = UIColor(named: "App_LightGrey")!
        
        cell.c_vBar1_Ht.constant = 0
        cell.c_vBar2_Ht.constant = 0
        
        cell.vBar1.backgroundColor = UIColor(named: "App_LightGrey")!
        cell.vBar2.backgroundColor = UIColor(named: "App_Blue")!
        cell.vBar1.layer.cornerRadius = 5.0
        cell.vBar1.layer.masksToBounds = true
        cell.vBar2.layer.cornerRadius = 5.0
        cell.vBar2.layer.masksToBounds = true
        
        cell.lblBar1.font = UIFont(name: CustomFont.regular, size: 12)
        cell.lblBar2.font = UIFont(name: CustomFont.regular, size: 12)
        
        if let str:String = dict["month_name"] as? String
        {
            cell.lblWeekName.text = str
        }
        
        if let str:String = dict["week_name"] as? String
        {
            cell.lblWeekName.text = str
        }
        
        if let str:String = dict["kpi_str"] as? String
        {
            cell.lblBar1.text = str  // Black
            
            if str.count > 5
            {
                cell.lblBar1.font = UIFont(name: CustomFont.regular, size: 10)
            }
        }
        if let str:String = dict["sales_str"] as? String
        {
            cell.lblBar2.text = str  // BLUE
            
            if str.count > 5
            {
                cell.lblBar2.font = UIFont(name: CustomFont.regular, size: 10)
            }
        }
        
        // KPI = Black ;  Sales = Blue
        
        let viewBarHeight = (cell.vMain.frame.size.height) - 28 // 22 Label height on bar & 6 is padding
        
        if let doubleKpi:Double = dict["kpi"] as? Double
        {
            if let doubleSales:Double = dict["sales"] as? Double
            {
                if doubleKpi > doubleSales
                {
                    cell.c_vBar1_Ht.constant = viewBarHeight
                    cell.c_vBar2_Ht.constant = viewBarHeight/1.8
                }
                else if doubleKpi == doubleSales
                {
                    cell.c_vBar1_Ht.constant = viewBarHeight/2
                    cell.c_vBar2_Ht.constant = viewBarHeight/2
                }
                else
                {
                    cell.c_vBar1_Ht.constant = viewBarHeight/1.8
                    cell.c_vBar2_Ht.constant = viewBarHeight
                }
            }
        }
        
        if let intKpi:Int = dict["kpi"] as? Int
        {
            if let intSales:Int = dict["sales"] as? Int
            {
                if intKpi > intSales
                {
                    cell.c_vBar1_Ht.constant = viewBarHeight
                    cell.c_vBar2_Ht.constant = viewBarHeight/1.8
                }
                else if intKpi == intSales
                {
                    cell.c_vBar1_Ht.constant = viewBarHeight/2
                    cell.c_vBar2_Ht.constant = viewBarHeight/2
                }
                else
                {
                    cell.c_vBar1_Ht.constant = viewBarHeight/1.8
                    cell.c_vBar2_Ht.constant = viewBarHeight
                }
            }
        }
        
        if isPad == false
        {
            cell.lblWeekName.font = UIFont(name: CustomFont.regular, size: 10)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // To make Cells Display in Center
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if isPad
        {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
            {
                let totalCellWidth = 120 * collectionView.numberOfItems(inSection: 0)
                let totalSpacingWidth = 0
                
                let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
                let rightInset = leftInset
                
                print("- - - - -LANDScape Bar - - - - - - -")
                return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
            }
            else
            {
                let totalCellWidth = 120 * collectionView.numberOfItems(inSection: 0)
                let totalSpacingWidth = 0
                
                let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
                let rightInset = leftInset
                
                print("- - - - - PORTRait Bar- - - - - - -")
                return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
            }
        }
        else
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if isPad
        {
            return CGSize(width: 160, height: 190)
        }
        else
        {
            return CGSize(width: 160, height: 190)
        }
    }
}
