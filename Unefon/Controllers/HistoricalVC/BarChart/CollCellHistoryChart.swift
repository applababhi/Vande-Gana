//
//  CollCellHistoryChart.swift
//  Unefon
//
//  Created by Shalini Sharma on 22/2/20.
//  Copyright © 2020 Shalini. All rights reserved.
//

import UIKit

class CollCellHistoryChart: UICollectionViewCell {
    
    @IBOutlet weak var lblWeekName:UILabel!
    @IBOutlet weak var vMain:UIView!
    @IBOutlet weak var vBar1:UIView!
    @IBOutlet weak var vBar2:UIView!
    @IBOutlet weak var lblBar1:UILabel!
    @IBOutlet weak var lblBar2:UILabel!
    
    @IBOutlet weak var c_vBar1_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_vBar2_Ht:NSLayoutConstraint!
}
