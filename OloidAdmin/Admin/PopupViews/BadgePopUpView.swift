//
//  BadgePopUpView.swift
//  CICOApp_CMode
//
//  Created by Tanvi Mittal on 25/01/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

protocol BadgePopUpViewDelegate : NSObjectProtocol {
    
    func onBadgeViewNextTapped(userID:String, name: String, badgeNumber: String)
    func onBadgeViewCancelTapped()
}

class BadgePopUpView: UIView, UITextFieldDelegate {
    
    weak var delegate:BadgePopUpViewDelegate?
    @IBOutlet weak var badgeTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var userID: String?
    var userName: String?
    
    @IBOutlet weak var view: UIView!
    
    static func instantiate() -> BadgePopUpView {
        
        let view = UINib(nibName: "BadgePopUpView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BadgePopUpView
        return view
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var valueToBeReturned: Bool = false
        var regex: NSRegularExpression
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if text.count <= 35 {
            do {
                regex = try NSRegularExpression(pattern: ".*[^0-9].*", options: [])
                
                if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count)) != nil {
                    valueToBeReturned = false
                }
                else {
                    valueToBeReturned = true
                }
            }
            catch {
                //print("ERROR")
            }
        }
        
        return valueToBeReturned
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
        if let id = userID,
            let name = userName {
            self.delegate?.onBadgeViewNextTapped(userID: id, name: name, badgeNumber: badgeTextField?.text ?? "")
        }
        else {
            self.delegate?.onBadgeViewNextTapped(userID: "", name: "", badgeNumber: badgeTextField?.text ?? "")
        }
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.delegate?.onBadgeViewCancelTapped()
    }
}
