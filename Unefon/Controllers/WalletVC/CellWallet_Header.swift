//
//  CellWallet_Header.swift
//  Unefon
//
//  Created by Shalini Sharma on 2/8/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellWallet_Header: UITableViewCell {

    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblType:UILabel!
    @IBOutlet weak var lblBrand:UILabel!
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
