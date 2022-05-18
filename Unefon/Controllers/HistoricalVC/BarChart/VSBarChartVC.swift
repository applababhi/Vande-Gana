//
//  VSBarChartVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 11/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit
import Charts

class VSBarChartVC: UIViewController {
    
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var btnOverlayRight_iPhone:UIButton!
    
    var arr_NumberOfArrayInCollection:[[[String:Any]]] = []
    var maxIndexForFullArray:Int = 0
    var arr_EachIndexCollV:[[String:Any]] = []
    var currentShowingIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        maxIndexForFullArray = arr_NumberOfArrayInCollection.count - 1
        arr_EachIndexCollV = arr_NumberOfArrayInCollection.first!
        
        print(arr_NumberOfArrayInCollection)
        print(arr_EachIndexCollV)
        
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

extension VSBarChartVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_EachIndexCollV.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arr_EachIndexCollV[indexPath.item]
        
        let cell:CollCellVSBar = collView.dequeueReusableCell(withReuseIdentifier: "CollCellVSBar", for: indexPath) as! CollCellVSBar
        cell.lblWeekName.text = ""
     //   cell.lblWeekRange.text = ""
        
        if let str:String = dict["month_name"] as? String
        {
            cell.lblWeekName.text = str
        }
        
        if let str:String = dict["week_name"] as? String
        {
            cell.lblWeekName.text = str
        }
        
        if isPad == false
        {
            cell.lblWeekName.font = UIFont(name: CustomFont.regular, size: 10)
        }
        
        cell.showBarChart(dictEachCell: dict)
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
            return CGSize(width: 120, height: 200)
        }
        else
        {
            return CGSize(width: 120, height: 200)
        }
    }
}
