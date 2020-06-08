//
//  FaceErrorPopUpView.swift
//  CICOApp_CMode
//
//  Created by Tanvi Mittal on 11/02/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

class FaceErrorPopUpView: UIView {

    @IBOutlet weak var retryButton: UIButton!
    var actionHandler: (() -> Void)?
    
    @IBAction func retryButtonClicked(_ sender: Any) {
       if let actionHandler = self.actionHandler {
            actionHandler()
        }
    }
    
    static func instantiate() -> FaceErrorPopUpView {
           let view = UINib(nibName: "FaceErrorPopUpView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FaceErrorPopUpView
           return view
       }
}
