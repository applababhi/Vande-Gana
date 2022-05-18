//
//  Cell_FaqReply.swift
//  Unefon
//
//  Created by Abhishek Visa on 23/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class Cell_FaqReply: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubtitle:UILabel!
    @IBOutlet weak var btnMarkSolution:UIButton!
    @IBOutlet weak var viewBk:UIView!
    @IBOutlet weak var lblCount:UILabel!
    @IBOutlet weak var imgTick:UIImageView!
    @IBOutlet weak var btnLike:UIButton!
    @IBOutlet weak var btnDislike:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
