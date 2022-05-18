//
//  CellActivaciones_ChartHeader.swift
//  Unefon
//
//  Created by Shalini Sharma on 2/26/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CellActivaciones_ChartHeader: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblKpi:UILabel!
    @IBOutlet weak var lblKpiValue:UILabel!
    @IBOutlet weak var lblSales:UILabel!
    @IBOutlet weak var lblSalesValue:UILabel!
    @IBOutlet weak var lblProgress:UILabel!
    @IBOutlet weak var lblMessage:UILabel!
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
