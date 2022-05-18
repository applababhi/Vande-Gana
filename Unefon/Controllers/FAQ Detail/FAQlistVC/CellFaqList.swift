//
//  CellFaqList.swift
//  Unefon
//
//  Created by Abhishek Visa on 5/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellFaqList: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var lblReply:UILabel!
    @IBOutlet weak var btnViewAnswer:UIButton!
    @IBOutlet weak var viewBk:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
