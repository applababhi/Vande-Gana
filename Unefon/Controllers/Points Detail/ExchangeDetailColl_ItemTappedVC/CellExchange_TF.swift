//
//  CellExchange_TF.swift
//  Unefon
//
//  Created by Abhishek Visa on 3/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellExchange_TF: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tf:UITextField!

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
            let imageView = UIImageView(frame: CGRect(x: 0, y: 3, width: 15, height: 15))
            imageView.contentMode = .center
            let image = UIImage(named: imageName)
            imageView.image = image
            viewT.addSubview(imageView)
        }
        
        TextField.rightView = viewT
    }
    
    
    func inCellAddLeftPaddingTo(TextField:UITextField)
    {
        let viewT = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        viewT.backgroundColor = .clear
        
        TextField.leftViewMode = UITextField.ViewMode.always
                
        TextField.leftView = viewT
    }
}
