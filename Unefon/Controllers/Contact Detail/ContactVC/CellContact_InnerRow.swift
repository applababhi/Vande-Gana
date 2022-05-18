//
//  CellContact_InnerRow.swift
//  Unefon
//
//  Created by Shalini Sharma on 9/8/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellContact_InnerRow: UITableViewCell {

    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblDescription:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var lblVer:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
