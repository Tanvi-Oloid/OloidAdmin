//
//  AdminUtility.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 20/05/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

extension UIButton {
    
    func roundedCorners() {
        self.layer.cornerRadius = 12
        //self.layer.borderWidth = self.frame.width/2
        self.backgroundColor = #colorLiteral(red: 0.005939191673, green: 0.4685313702, blue: 1, alpha: 1)
        self.layer.masksToBounds = true
    }
    
    func makeRoundedCornersWithBorder() {
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.masksToBounds = true
    }
}

extension UITextField {
    func roundedWithGrayBorder()
    {
        self.layer.borderColor = #colorLiteral(red: 0.8077718616, green: 0.8078889251, blue: 0.8077461123, alpha: 1)
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 2
        self.layer.masksToBounds = true
    }
    func roundedWithBlueBorder()
    {
        self.layer.borderColor = #colorLiteral(red: 0.3830561638, green: 0.6513206959, blue: 0.9908674359, alpha: 1)
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 2
        self.layer.masksToBounds = true
    }
}

extension UIViewController {
    
    @objc func dismissAdminKeyboard() {
        view.endEditing(true)
    }
}

