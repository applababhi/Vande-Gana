//
//  CellObj1Row.swift
//  Unefon
//
//  Created by Abhishek Visa on 6/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellObj1Row: UITableViewCell {

    @IBOutlet weak var viewBk:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblPoints:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
