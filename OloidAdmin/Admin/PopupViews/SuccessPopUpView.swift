//
//  SuccessPopUpView.swift
//  CICOApp_CMode
//
//  Created by Tanvi Mittal on 25/01/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

class SuccessPopUpView: UIView {
    @IBOutlet weak var faceImage: UIImageView!
    
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var faceImageHeightConstraint: NSLayoutConstraint!
    static func instantiate() -> SuccessPopUpView {
           
           let view = UINib(nibName: "SuccessPopUpView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SuccessPopUpView
           return view
       }
}
