//
//  PunchInPopUpView.swift
//  CICOApp_CMode
//
//  Created by Tanvi Mittal on 11/02/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

class PunchInPopUpView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var punchInButton: UIButton!
    
    var actionHandler: (() -> Void)?
    
    @IBAction func punchInButtonAction(_ sender: Any) {
        if let actionHandler = self.actionHandler {
            actionHandler()
        }
    }
    
    override func awakeFromNib() {

        self.layoutIfNeeded()
        
        self.layer.cornerRadius = 10.0
        punchInButton.layer.cornerRadius = 4.0
        
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        
        nameLabel.minimumScaleFactor = 0.8
    }
    
    static func instantiate() -> PunchInPopUpView {
           
           let view = UINib(nibName: "PunchInPopUpView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PunchInPopUpView
        
           return view
       }
}
