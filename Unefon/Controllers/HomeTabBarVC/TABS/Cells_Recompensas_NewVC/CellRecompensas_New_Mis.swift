//
//  CellRecompensas_New_Mis.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/4/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CellRecompensas_New_Mis: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblDescription:UILabel!
    @IBOutlet weak var btn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class CellUserProfile: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lbl_1:UILabel!
    @IBOutlet weak var lbl_2:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
