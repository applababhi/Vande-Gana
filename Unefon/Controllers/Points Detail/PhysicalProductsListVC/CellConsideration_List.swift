//
//  CellConsideration_List.swift
//  Unefon
//
//  Created by Shalini Sharma on 23/9/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellConsideration_List: UITableViewCell {

    @IBOutlet weak var viewBk:UIView!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle1:UILabel!
    @IBOutlet weak var lblSubTitle2:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
