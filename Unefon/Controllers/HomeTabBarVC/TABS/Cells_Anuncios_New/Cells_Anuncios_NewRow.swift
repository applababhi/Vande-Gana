//
//  Cells_Anuncios_NewRow.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/2/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class Cells_Anuncios_NewRow: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UIInsetDownLabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var vTransBlack:UIView!
    @IBOutlet weak var btn:UIButton!

    var calledGariantOnce = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setGradient(){
        
        if calledGariantOnce == false{
            calledGariantOnce = true
            
            let fistColor = UIColor.white
            let lastColor = UIColor(named: "App_DarkBlack")!
            
            let gradient: CAGradientLayer = CAGradientLayer()
    //        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
            gradient.colors = [fistColor.cgColor, lastColor.cgColor]
            gradient.opacity = 0.4
            gradient.locations = [0.0 , 0.5]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 230)
            vTransBlack.layer.insertSublayer(gradient, at: 0)
        }
    }
}
