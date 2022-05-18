//
//  CellConsiderationButton.swift
//  Unefon
//
//  Created by Shalini Sharma on 24/9/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellConsiderationButton: UITableViewCell {

    @IBOutlet weak var lblTopRed:UILabel!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var lblBottomRed:UILabel!
    @IBOutlet weak var c_lBottom_Ht:NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
