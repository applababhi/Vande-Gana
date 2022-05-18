//
//  Objective2VC.swift
//  Unefon
//
//  Created by Abhishek Visa on 6/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class Objective2VC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    
    var arrData: [String] = []
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.estimatedRowHeight = 60
        tblView.rowHeight = UITableView.automaticDimension
        tblView.dataSource = self
        tblView.delegate = self
    }
}

extension Objective2VC
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

extension Objective2VC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let other2LblWidth = CGFloat(190.0) // (112+70)
        
        let title:String = arrData[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellObj2Row = tableView.dequeueReusableCell(withIdentifier: "CellObj2Row", for: indexPath) as! CellObj2Row
        cell.selectionStyle = .none
        
        let title:String = arrData[indexPath.row]
        
        cell.viewDot.layer.cornerRadius = 8.0
        cell.viewDot.layer.masksToBounds = true
        cell.lblTitle.text = ""
        
        cell.lblTitle.text = title

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
