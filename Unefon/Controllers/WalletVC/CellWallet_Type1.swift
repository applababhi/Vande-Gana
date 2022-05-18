//
//  CellWallet_Type1.swift
//  Unefon
//
//  Created by Shalini Sharma on 2/8/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellWallet_Type1: UITableViewCell {

    @IBOutlet weak var btnDownload:UIButton!
    @IBOutlet weak var btnStoreUrl:UIButton!
    @IBOutlet weak var lblCode:UILabel!
    @IBOutlet weak var btnShare:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
