//
//  CellRankingList.swift
//  Unefon
//
//  Created by Abhishek Visa on 4/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellRankingList: UITableViewCell {

    @IBOutlet weak var lblPosition:UILabel!
    @IBOutlet weak var lblStore:UILabel!
    @IBOutlet weak var lblPerformance:UILabel!
    @IBOutlet weak var viewBk:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
