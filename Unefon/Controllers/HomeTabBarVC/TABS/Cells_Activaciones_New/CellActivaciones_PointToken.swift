//
//  CellActivaciones_PointToken.swift
//  Unefon
//
//  Created by Shalini Sharma on 2/26/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CellActivaciones_PointToken: UITableViewCell {
    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblPointValue:UILabel!
    @IBOutlet weak var lblTokenValue:UILabel!
    @IBOutlet weak var lblPoints:UILabel!
    @IBOutlet weak var lblTokens:UILabel!
    @IBOutlet weak var lblComments:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
