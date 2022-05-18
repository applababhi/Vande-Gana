//
//  Modals.swift
//  Unefon
//
//  Created by Shalini Sharma on 18/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import Foundation
import UIKit

struct Dashboard
{
    var name:String = ""

    init(dict:Dictionary<String,Any>)
    {
           print(dict)

        if let name:String = dict["name"] as? String
        {
            self.name = name
        }
    }
}
