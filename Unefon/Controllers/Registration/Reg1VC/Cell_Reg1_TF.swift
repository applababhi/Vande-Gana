//
//  Cell_Reg1_TF.swift
//  Unefon
//
//  Created by Abhishek Visa on 29/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class Cell_Reg1_TF: UITableViewCell {

    @IBOutlet weak var lbl:UILabel!
    @IBOutlet weak var tf:UnderlineTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func inCellAddRightPaddingTo(TextField:UITextField, imageName:String)
    {
        let viewT = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        viewT.backgroundColor = .clear
        
        TextField.rightViewMode = UITextField.ViewMode.always
        
        if imageName != ""
        {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 10, height: 10))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            let image = UIImage(named: imageName)
            imageView.image = image
            viewT.addSubview(imageView)
        }
        
        TextField.rightView = viewT
    }
    
}
