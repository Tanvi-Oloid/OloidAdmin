//
//  AdminLoginViewController.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 20/05/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

class AdminLoginViewController: UIViewController, UINavigationControllerDelegate {
    
    var adminAPIManager = AdminAPIManager.init()
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningView.isHidden = true
        nameTextField.roundedWithGrayBorder()
        emailTextField.roundedWithGrayBorder()
        passwordTextField.roundedWithGrayBorder()
        loginButton.roundedCorners()
//        loginButton.alpha = 0.5
//        loginButton.isUserInteractionEnabled = false
        
        
        self.nameTextField.text = "uber"
        self.emailTextField.text = "shankar@oloid.ai"
        self.passwordTextField.text = "Oloid@123"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {

         super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    
    @IBAction func onLoginPressed(_ sender: Any) {
        let name =  self.nameTextField.text
        let email =  self.emailTextField.text
        let pwd =  self.passwordTextField.text
        
        activityIndicator.startAnimating()
        
        let isEmailValid = isValidEmail(testStr: self.emailTextField.text ?? "")
        
        if name == nil || email == nil || pwd == nil || !isEmailValid {
            warningView.isHidden = false
        }
        else  {
            
            if let name = name,
                let email = email,
                let pwd = pwd {
                adminAPIManager.callLoginAPI(tenantName: name, uName: email, password: pwd) { (response, error) in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        if error == nil {
                           
                            let storyBoard = UIStoryboard.init(name: "Admin", bundle:.main)
                            let vc = storyBoard.instantiateViewController(withIdentifier:"AdminSettingsViewController") as! AdminSettingsViewController
                            
                            vc.idToken = response
                            self.navigationController?.delegate = self
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else {
                            
                        }
                    }
                }
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
//    func keyboardWillShow(notification: NSNotification) {
//        if keyboardHeight != nil {
//            return
//        }
//    }

}
extension AdminLoginViewController : UITextFieldDelegate
{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        activeField = textField
        lastOffset = self.loginScrollView.contentOffset
        return true
        
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
       // handleLoginButtonInteraction(textField: textField, range: range, string: string)
        
        var nameLength: Int = 0
        var emailLength: Int = 0
        var passwordLength: Int = 0
        
        if textField.tag == 100 {
            let currentCharacterCount = nameTextField.text?.count ?? 0
            
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            
            //let newLength = currentCharacterCount + string.count - range.length
            
            let newLength = getTextLength(textField: nameTextField, range: range, string: string)
            
            nameLength = newLength
            // Handling UI
            if newLength == 0 {
                self.nameTextField.roundedWithGrayBorder()
            }
            else {
                self.nameTextField.roundedWithBlueBorder()
            }
            //return newLength <= 30
        }
        else if textField.tag == 101 {
//            let currentCharacterCount = emailTextField.text?.count ?? 0
//            let newLength = currentCharacterCount + string.count - range.length
            
            let newLength = getTextLength(textField: emailTextField, range: range, string: string)
            emailLength = newLength
            // Handling UI
            if newLength == 0 {
                self.emailTextField.roundedWithGrayBorder()
            }
            else {
                self.emailTextField.roundedWithBlueBorder()
            }
        }
        else if textField.tag == 102 {
            
//            let currentCharacterCount = passwordTextField.text?.count ?? 0
//            let newLength = currentCharacterCount + string.count - range.length
            
            let newLength = getTextLength(textField: passwordTextField, range: range, string: string)
            
            passwordLength = newLength
            // Handling UI
            if newLength == 0 {
                self.passwordTextField.roundedWithGrayBorder()
            }
            else {
                self.passwordTextField.roundedWithBlueBorder()
            }
        }
//        if nameLength > 0 && emailLength > 0 && passwordLength > 0 {
//            loginButton.alpha = 1.0
//            loginButton.isUserInteractionEnabled = true
//        }
//        else {
//            loginButton.alpha = 0.5
//            loginButton.isUserInteractionEnabled = false
//        }
        
        return true
    }
    
    func getTextLength(textField: UITextField,range: NSRange,string: String) -> Int {
        let currentCharacterCount = textField.text?.count ?? 0
        let newLength = currentCharacterCount + string.count - range.length
        return newLength
    }
    
//    func handleLoginButtonInteraction(textField: UITextField, range: NSRange,string: String) {
//
//        var name: Int = 0
//        var email: Int = 0
//        var password: Int = 0
//
//        if textField.tag == 100 {
//            name = getTextLength(textField: nameTextField, range: range, string: string)
//        }
//        else if textField.tag == 101 {
//            email = getTextLength(textField: emailTextField, range: range, string: string)
//        }
//        else if textField.tag == 102 {
//            password = getTextLength(textField: passwordTextField, range: range, string: string)
//        }
//
//        if name != 0 && email != 0 && password != 0 {
//            loginButton.alpha = 1.0
//            loginButton.isUserInteractionEnabled = true
//        }
//        else {
//            loginButton.alpha = 0.5
//            loginButton.isUserInteractionEnabled = false
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //textField.resignFirstResponder()
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }

}

// MARK: Keyboard Handling
extension AdminLoginViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight.constant += self.keyboardHeight
            })
            
            // move if keyboard hide input field
            let distanceToBottom = self.loginScrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            
            if collapseSpace < 0 {
                // no collapse
                return
            }
            
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.loginScrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintContentHeight.constant -= self.keyboardHeight
            
            self.loginScrollView.contentOffset = self.lastOffset
        }
        
        keyboardHeight = nil
    }
}
