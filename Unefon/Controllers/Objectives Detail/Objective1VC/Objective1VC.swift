//
//  Objective1VC.swift
//  Unefon
//
//  Created by Abhishek Visa on 6/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class Objective1VC: UIViewController {
    
    @IBOutlet weak var lblNumber:UILabel!
    @IBOutlet weak var txtView:UITextView!
    @IBOutlet weak var tblView:UITableView!
    
    var strDescription:String = ""
    var numberKPI:Int = 0
    
    var arrData: [[String:Any]] = []
    let altColor: UIColor = UIColor.init(red: 248.0/255.0, green: 245.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  lblNumber.text = "\(numberKPI)"

        var formatedCurrency = "\(numberKPI)".toCurrencyFormat()
        formatedCurrency = formatedCurrency.components(separatedBy: ".").first!
        formatedCurrency = formatedCurrency.replacingOccurrences(of: "$", with: "")
        lblNumber.text = formatedCurrency

        txtView.text = strDescription
        tblView.estimatedRowHeight = 60
        tblView.rowHeight = UITableView.automaticDimension
        tblView.dataSource = self
        tblView.delegate = self
    }    
}

extension Objective1VC
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

extension Objective1VC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerCell: CellPoints_Header = tableView.dequeueReusableCell(withIdentifier: "CellPoints_Header") as! CellPoints_Header
        headerCell.selectionStyle = .none
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let other2LblWidth = CGFloat(190.0) // (112+70)
        
        let dict:[String:Any] = arrData[indexPath.row]
        if let title:String = dict["range_description"] as? String
        {
            let width = (tableView.frame.size.width - other2LblWidth)
            let height = title.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.regular, size: 17.0)!)
            // print("- - - - - >", height)
            
            if height < 30.0
            {
                return 55
            }
            else
            {
                return UITableView.automaticDimension
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellObj1Row = tableView.dequeueReusableCell(withIdentifier: "CellObj1Row", for: indexPath) as! CellObj1Row
        cell.selectionStyle = .none
        
        let dict:[String:Any] = arrData[indexPath.row]
        
        cell.lblTitle.text = ""
        cell.lblPoints.text = ""
        
        if (indexPath.row % 2 == 0)
        {
            cell.viewBk.backgroundColor = UIColor.white
        }
        else
        {
            cell.viewBk.backgroundColor = altColor
        }
        
        if let title:String  = dict["range_description"] as? String
        {
            cell.lblTitle.text = title
        }
        if let title:String  = dict["points_str"] as? String
        {
            cell.lblPoints.text = title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
