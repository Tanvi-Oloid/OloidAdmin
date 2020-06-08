//
//  BadPicturePopUpView.swift
//  CICOApp_CMode
//
//  Created by Tanvi Mittal on 25/01/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

protocol BadPicturePopUpViewDelegate : NSObjectProtocol {
    
    func onBadViewTryAgainTapped()
}

class BadPicturePopUpView: UIView {
    
    
    static func instantiate() -> BadPicturePopUpView {
        
        let view = UINib(nibName: "BadPicturePopUpView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BadPicturePopUpView
        return view
    }

    weak var delegate:BadPicturePopUpViewDelegate?
    @IBOutlet weak var msgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var faceImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var faceImage: UIImageView!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var tryButton: UIButton!
    
    @IBAction func tryButtonAction(_ sender: Any) {
        self.delegate?.onBadViewTryAgainTapped()
    }
}
