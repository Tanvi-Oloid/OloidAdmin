//
//  GoodPicturePopUpView.swift
//  CICOApp_CMode
//
//  Created by Tanvi Mittal on 25/01/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

protocol GoodPicturePopUpViewDelegate : NSObjectProtocol {
    
    func onGoodViewSubmitTapped()
    func onGoodViewRetakeTapped()
}

class GoodPicturePopUpView: UIView {
    
    weak var delegate:GoodPicturePopUpViewDelegate?
    @IBOutlet weak var faceImage: UIImageView!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    
    static func instantiate() -> GoodPicturePopUpView {
        
        let view = UINib(nibName: "GoodPicturePopUpView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GoodPicturePopUpView
        
        return view
    }
    
   @IBAction func submitButtonAction(_ sender: Any) {
        self.delegate?.onGoodViewSubmitTapped()
    }
    @IBAction func retakeButtonAction(_ sender: Any) {
        self.delegate?.onGoodViewRetakeTapped()
    }
}
