//
//  CellFaqDetail_Header.swift
//  Unefon
//
//  Created by Abhishek Visa on 5/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellFaqDetail_Header: UITableViewCell {

    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubtitle:UILabel!
    @IBOutlet weak var btnDate:UIButton!
    @IBOutlet weak var btnReply:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
