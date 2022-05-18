//
//  CellExchange_Header.swift
//  Unefon
//
//  Created by Abhishek Visa on 3/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellExchange_Header: UITableViewCell {

    @IBOutlet weak var carouselView: AACarousel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgView:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
