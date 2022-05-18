//
//  CellRecompensas_New_Canjear.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/4/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CellRecompensas_New_Canjear: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblBalance:UILabel!
    @IBOutlet weak var lblDescription:UILabel!
    @IBOutlet weak var btnOperation:UIButton!
    @IBOutlet weak var btnCanjear:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
