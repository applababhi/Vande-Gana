//
//  CellContact_List.swift
//  Unefon
//
//  Created by Shalini Sharma on 9/8/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellContact_List: UITableViewCell {

    @IBOutlet weak var tblViewInner:UITableView!
    var arrList: [[String:Any]] = [] {
        didSet{
            if self.tblViewInner.delegate == nil
            {
                self.tblViewInner.estimatedRowHeight = 30
                self.tblViewInner.rowHeight = UITableView.automaticDimension

                self.tblViewInner.dataSource = self
                self.tblViewInner.delegate = self
           //     self.tblViewInner.isScrollEnabled = true
            }
            self.tblViewInner.reloadData()
        }
    }
    let altColor: UIColor = UIColor.init(red: 248.0/255.0, green: 245.0/255.0, blue: 248.0/255.0, alpha: 1.0)

    var completion: (String)->Void = {_ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CellContact_List: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // show Header
        let headerCell: CellPoints_Header = tableView.dequeueReusableCell(withIdentifier: "CellPoints_Header") as! CellPoints_Header
        headerCell.selectionStyle = .none
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellContact_InnerRow = tableView.dequeueReusableCell(withIdentifier: "CellContact_InnerRow", for: indexPath) as! CellContact_InnerRow
        cell.selectionStyle = .none
        
        let dict:[String:Any] = arrList[indexPath.row]
        
        cell.lblDate.text = ""
        cell.lblDescription.text = ""
        cell.lblStatus.text = ""
        
        if (indexPath.row % 2 == 0)
        {
            cell.contentView.backgroundColor = UIColor.white
        }
        else
        {
            cell.contentView.backgroundColor = altColor
        }
        
        if let title:String  = dict["request_date"] as? String
        {
            cell.lblDate.text = title
        }
        if let title:String  = dict["problem_description"] as? String
        {
            cell.lblDescription.text = title
        }
        if let status:Int  = dict["status"] as? Int
        {
            if status == 0
            {
                cell.lblStatus.text = "Pendiente"
            }
            else
            {
                cell.lblStatus.text = "Resuelto"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrList[indexPath.row]
        
        if let id:String  = dict["ticket_id"] as? String
        {
            completion(id)
        }
    }
}
