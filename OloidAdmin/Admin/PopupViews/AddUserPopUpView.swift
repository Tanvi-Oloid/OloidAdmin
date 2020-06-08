//
//  AddUserPopUpView.swift
//  CICOApp_CMode
//
//  Created by Tanvi Mittal on 25/01/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

//@IBDesignable

protocol AddUserPopUpviewDelegate : NSObjectProtocol {
    
    func onAddUserNextButtonTapped(userID:String, name: String)
    func onAddUserCancelButtonTapped()
    func onCollectionNameClick()
}

class AddUserPopUpview: UIView, UITextFieldDelegate {
    
    weak var delegate:AddUserPopUpviewDelegate?
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var collectionTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var userIdErrorLabel: UILabel!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isUserNumberIsValid = false
    
    var isDisplayNameIsValid = false
    
    @IBOutlet weak var view: UIView!
    
    
    static func instantiate() -> AddUserPopUpview {
        
        let view = UINib(nibName: "AddUserPopUpView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AddUserPopUpview
        
        
        return view
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == collectionTextField {

            textField.resignFirstResponder()
            if let refDelegate = self.delegate
            {
                refDelegate.onCollectionNameClick()
            }
        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var valueToBeReturned: Bool = false
        var regex: NSRegularExpression
        var containWhiteSpace: Bool = false
        
        if textField.text?.last == " "  && string == " "{
        // If consecutive spaces entered by user
         return false
        }
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if text.count <= 25 {
            do {
                if textField.tag == 61 {
                    regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: [])
                }
                else {
                    regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                }
                if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count)) != nil {
                    valueToBeReturned = false
                }
                else {
                    valueToBeReturned = true
                }
                if textField.tag == 61 {
                    isUserNumberIsValid = valueToBeReturned
                }
                else {
                    isDisplayNameIsValid = valueToBeReturned
                }
            }
            catch {
               // print("ERROR")
            }
        }
        
        if isUserNumberIsValid && isDisplayNameIsValid && !text.isEmpty && containWhiteSpace && collectionTextField.text != ""
        {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        }
        else
        {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
        
        if textField.tag == 62 {
            if text.contains(" ") && !text.hasSuffix(" ") {
                containWhiteSpace = true
                nextButton.isEnabled = true
                nextButton.alpha = 1.0
            }
            else {
                containWhiteSpace = false
                nextButton.isEnabled = false
                nextButton.alpha = 0.5
            }
        }
        return valueToBeReturned
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        
//        if textField.tag == 61 {
//            //self.formInputs?.setBadgeNumber(badgeNumber: textField.text ?? "")
//        }
//        else {
//           // self.formInputs?.setDisplayName(displayName: textField.text ?? "")
//        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
        if let userText = userIdTextField.text,
            let nameText = nameTextField.text {
           self.delegate?.onAddUserNextButtonTapped(userID: userText, name: nameText)
        }
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.delegate?.onAddUserCancelButtonTapped()
    }
}

