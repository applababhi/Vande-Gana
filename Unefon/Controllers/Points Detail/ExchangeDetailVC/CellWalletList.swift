//
//  CellWalletList.swift
//  Unefon
//
//  Created by Abhishek Visa on 29/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellWalletList: UITableViewCell {

    @IBOutlet weak var viewBk:UIView!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UIInsetDownLabel!
    @IBOutlet weak var lblSubTitle:UIInsetUpLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
