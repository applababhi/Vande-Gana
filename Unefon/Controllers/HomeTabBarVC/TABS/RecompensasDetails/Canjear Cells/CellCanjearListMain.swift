//
//  CellCanjearListMain.swift
//  Unefon
//
//  Created by Shalini Sharma on 3/5/22.
//  Copyright © 2022 Shalini. All rights reserved.
//

import UIKit

class CellCanjearListMain: UITableViewCell {

    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var vBk_Color:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubtitle:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var imgView_Slice:UIImageView!
    @IBOutlet weak var tf:UITextField!
    @IBOutlet weak var btn:UIButton!
    
    @IBOutlet weak var lblWarning:UILabel!
    @IBOutlet weak var c_Warning_Ht:NSLayoutConstraint!
    
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    @IBOutlet weak var lbl3:UILabel!
    @IBOutlet weak var lbl4:UILabel!
    @IBOutlet weak var lbl5:UILabel!
    
    @IBOutlet weak var tf_1:UITextField!
    @IBOutlet weak var tf_2:UITextField!
    @IBOutlet weak var tf_3:UITextField!
    @IBOutlet weak var tf_4:UITextField!
    @IBOutlet weak var tf_5:UITextField!
    @IBOutlet weak var tf_6:UITextField!  // PICKER
    @IBOutlet weak var tf_7:UITextField!
    @IBOutlet weak var tf_8:UITextField!
    @IBOutlet weak var tf_9:UITextField!
    
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
