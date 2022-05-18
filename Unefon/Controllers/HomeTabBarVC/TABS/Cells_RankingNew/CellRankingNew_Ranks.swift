//
//  CellRankingNew_Ranks.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/2/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CellRankingNew_Ranks: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    
    @IBOutlet weak var v_Row1:UIView!
    @IBOutlet weak var imgProgress_Row1:UIImageView!
    @IBOutlet weak var imgCircle_Row1:UIImageView!
    @IBOutlet weak var lblTitlte_Row1:UILabel!
    @IBOutlet weak var lblSubTitlte_Row1:UILabel!
    
    @IBOutlet weak var v_Row2:UIView!
    @IBOutlet weak var imgProgress_Row2:UIImageView!
    @IBOutlet weak var imgCircle_Row2:UIImageView!
    @IBOutlet weak var lblTitlte_Row2:UILabel!
    @IBOutlet weak var lblSubTitlte_Row2:UILabel!
    
    @IBOutlet weak var v_Row3:UIView!
    @IBOutlet weak var imgProgress_Row3:UIImageView!
    @IBOutlet weak var imgCircle_Row3:UIImageView!
    @IBOutlet weak var lblTitlte_Row3:UILabel!
    @IBOutlet weak var lblSubTitlte_Row3:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
