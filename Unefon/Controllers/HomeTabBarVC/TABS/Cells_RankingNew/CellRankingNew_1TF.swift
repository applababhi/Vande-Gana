//
//  CellRankingNew_1TF.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/2/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CellRankingNew_1TF: UITableViewCell {

    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tf_1:UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func inCellAddPaddingTo(TextField:UITextField, imageName:String)
    {
        let viewT = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        viewT.backgroundColor = .clear
        
        TextField.leftViewMode = UITextField.ViewMode.always
        TextField.rightViewMode = UITextField.ViewMode.always
        
        if imageName != ""
        {
            let viewR = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            viewR.backgroundColor = .clear
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .center
            let image = UIImage(named: imageName)
            imageView.image = image
            viewR.addSubview(imageView)
            TextField.rightView = viewR
        }
        
        TextField.leftView = viewT
    }
}
