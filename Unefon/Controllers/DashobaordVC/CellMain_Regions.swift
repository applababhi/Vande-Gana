
//
//  CellMain_Regions.swift
//  Unefon
//
//  Created by Shalini Sharma on 24/2/21.
//  Copyright © 2021 Shalini. All rights reserved.
//

import UIKit
import LinearProgressBar

class CellMain_Regions: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    
    var arrData:[[String:Any]] = [] {
        didSet{
            if tblView.delegate == nil
            {
                tblView.delegate = self
                tblView.dataSource = self
            }
            tblView.reloadData()
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

extension CellMain_Regions: UITableViewDataSource, UITableViewDelegate
{    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let dict:[String:Any] = arrData[indexPath.item]
        let cell:CellMainRegion_Inner = tableView.dequeueReusableCell(withIdentifier: "CellMainRegion_Inner", for: indexPath) as! CellMainRegion_Inner
        cell.selectionStyle = .none

        cell.lblTitle.text = ""
        cell.lblLeft.text = ""
        cell.lblRight.text = ""
        
        if let str:String = dict["region_name_str"] as? String
        {
            cell.lblTitle.text = str
        }
        if let str:String = dict["sales_str"] as? String
        {
            cell.lblLeft.text = str
        }
        if let str:String = dict["kpi_str"] as? String
        {
            cell.lblRight.text = str
        }
        
        if let valProgress:Double = dict["progress"] as? Double
        {
            cell.progressBar.progressValue = CGFloat(valProgress * 100)
            
            cell.progressBar.capType = Int32(1) // to make progress bar inner proggress round
            cell.progressBar.barColor = UIColor.colorWithHexString("3c608c")
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
}
