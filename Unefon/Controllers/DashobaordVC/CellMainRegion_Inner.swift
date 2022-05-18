//
//  CellMainRegion_Inner.swift
//  Unefon
//
//  Created by Shalini Sharma on 24/2/21.
//  Copyright © 2021 Shalini. All rights reserved.
//

import UIKit
import LinearProgressBar

class CellMainRegion_Inner: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblLeft:UILabel!
    @IBOutlet weak var lblRight:UILabel!
    @IBOutlet weak var progressBar: LinearProgressBar!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
