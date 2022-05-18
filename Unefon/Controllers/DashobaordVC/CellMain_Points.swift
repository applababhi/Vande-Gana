//
//  CellMain_Points.swift
//  Unefon
//
//  Created by Abhishek Visa on 1/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellMain_Points: UITableViewCell {

    @IBOutlet weak var viewBk:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblMessage:UILabel!
    
    @IBOutlet weak var lblMonthlyFee:UILabel!
    @IBOutlet weak var lblScope:UILabel!
    @IBOutlet weak var lblActivation:UILabel!
    @IBOutlet weak var lblPoints:UILabel!
    
    @IBOutlet weak var btnHistory:UIButton!
    @IBOutlet weak var btnDetails:UIButton!
//    @IBOutlet weak var btnExchange:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
