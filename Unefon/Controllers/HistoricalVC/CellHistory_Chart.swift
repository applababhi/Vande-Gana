//
//  CellHistory_Chart.swift
//  Unefon
//
//  Created by Shalini Sharma on 25/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellHistory_Chart: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var v_Bk:UIView!
    
    @IBOutlet weak var v_Circle1:UIView!
    @IBOutlet weak var lblCircle1:UILabel!
    @IBOutlet weak var v_Circle2:UIView!
    @IBOutlet weak var lblCircle2:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
