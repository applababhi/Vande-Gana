//
//  CellMenu_Header.swift
//  Unefon
//
//  Created by Abhishek Visa on 2/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellMenu_Header: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var c_img_Ht_iPad:NSLayoutConstraint!
    @IBOutlet weak var c_img_Wd_iPad:NSLayoutConstraint!
    @IBOutlet weak var c_img_Tp_iPad:NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
