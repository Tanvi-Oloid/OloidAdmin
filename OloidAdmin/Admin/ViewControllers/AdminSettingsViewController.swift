//
//  AdminSettingsViewController.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 21/05/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

class AdminSettingsViewController: UIViewController {

    @IBOutlet weak var selectAppButton: UIButton!
    @IBOutlet weak var endpointTextField: UITextField!
    @IBOutlet weak var appTypeTextField: UITextField!
    @IBOutlet weak var pairButton: UIButton!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var warningView: UIView!
    
    @IBOutlet weak var endpointNameLabel: UILabel!
    
    @IBOutlet weak var endpointIDLabel: UILabel!
    @IBOutlet weak var applicationNameLabel: UILabel!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var successViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoutViewVerticalConstraint: NSLayoutConstraint!
    
    var idToken: String?
    var adminAPIManager = AdminAPIManager.init()
    var appIdArray: NSArray!
    var appNameArray: NSArray!
    
    var selectedAppId: String?
    var isSuccessView: Bool = false
    var isUnpairView: Bool = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func selectAppButton(_ sender: Any) {
        
        self.warningView.isHidden = true
        
        if appNameArray.count != 0 {
            let storyBoard = UIStoryboard.init(name: "Admin", bundle:.main)
            let vc = storyBoard.instantiateViewController(withIdentifier:"AdminListTypeViewController") as! AdminListTypeViewController
            vc.delegate = self
            vc.listArray = appNameArray
            self.present(vc, animated: true, completion: nil)
        }
        else {
            self.warningView.isHidden = false
            self.errorLabel.text = "There are no Application Names"
        }
    }
    
    @IBAction func onPairButtonPressed(_ sender: Any) {
        
        self.activityIndicator.startAnimating()
        
        if pairButton.currentTitle == "Unpair" {
            clearAllFieldsOnUnpair()
        }
        else {
            self.warningView.isHidden = true
            
            if endpointTextField.text != "" && appTypeTextField.text != "" && selectedAppId != "" {
                
                if let endpointName = self.endpointTextField.text,
                    let appId = selectedAppId {
                    
                    UserDefaults.standard.set(endpointName, forKey: "endPointName")
                    adminAPIManager.pairEndPoint(endpointName: endpointName, appID: appId) { (response, error) in
                        
                        DispatchQueue.main.async {
                            
                            if error == nil {
                                
                                self.adminAPIManager.getAppConfig() { (response, error) in
                                    if response == "Success" {
                                        
                                        self.callFirebaseWithCredentials()
                                    }
                                }
                            }
                            else {
                                self.activityIndicator.stopAnimating()
                                self.warningView.isHidden = false
                                self.errorLabel.text = error?.localizedDescription
                            }
                        }
                    }
                }
                
            }
            else {
                // show warning to enter all fields
                self.warningView.isHidden = false
                self.errorLabel.text = "Please enter all fields"
            }
        }
        }
    
    func clearAllFieldsOnUnpair() {
        
        // Call unpair endpoint API
        
        adminAPIManager.deleteEndpointAPi { (response, error) in
                        
             DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if error == nil {
                    
                    let defaults = UserDefaults.standard
                    defaults.removeObject(forKey: "user")
                    defaults.removeObject(forKey: "endpoint")
                    defaults.removeObject(forKey: "endPointName")
                    
                    self.endpointTextField.alpha = 1.0
                    self.appTypeTextField.alpha = 1.0
                    self.endpointTextField.isUserInteractionEnabled = true
                    self.endpointTextField.text = ""
                    self.appTypeTextField.text = ""
                    self.selectAppButton.isUserInteractionEnabled = true
                    self.pairButton.setTitle("Pair", for: .normal)
                    self.endpointNameLabel.alpha = 1.0
                    self.applicationNameLabel.alpha = 1.0
                    self.endpointIDLabel.alpha = 1.0
                    self.endpointIDLabel.isHidden = true
                    
                }
                else {
                    self.warningView.isHidden = false
                    self.errorLabel.text = error?.localizedDescription
                }
            }
        }
    }
    
    func callFirebaseWithCredentials() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
                
//        CICOFirebase.shared.adminLoginWithUser(completion: { [weak self] (error, String) in
//
//            if error == nil {
//                self?.activityIndicator.stopAnimating()
//            }
//            if String == "Success" {
//
//                self?.isSuccessView = true
//                self?.bringFormPopupView()
//                self?.perform(#selector(self?.dismissPopupView), with: nil, afterDelay: 3.0)
//                //self?.perform(#selector(self?.bringFormPopupView), with: nil, afterDelay: 2.0)
//            }
//            else {
//                self?.warningView.isHidden = false
//                self?.errorLabel.text = "There was an issue configuring the device. Please try again"
//            }
//
//        })
    }
    
    @IBAction func yesButtonTapped(_ sender: Any) {
        
        // clearing ID token
        UserDefaults.standard.set("", forKey: "idToken")
        
//        if let vCtrls = self.navigationController?.viewControllers
//        {
//            let homeVC = vCtrls[1]
//
//            self.navigationController?.popToViewController(homeVC, animated: true)
//        }
        // TODO:
        // Handle Logout API
        let storyBoard = UIStoryboard.init(name: "Main", bundle:.main)
        
        let vc = storyBoard.instantiateViewController(withIdentifier:"HomeVC")
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func noButtonTapped(_ sender: Any) {
        showUnpairView()
    }
    
    func showUnpairView() {
        isUnpairView = true
        dismissPopupView()
        endpointTextField.alpha = 0.5
        appTypeTextField.alpha = 0.5
        endpointTextField.isUserInteractionEnabled = false
        selectAppButton.isUserInteractionEnabled = false
        pairButton.setTitle("Unpair", for: .normal)
        endpointNameLabel.alpha = 0.5
        applicationNameLabel.alpha = 0.5
        endpointIDLabel.alpha = 0.5
        endpointIDLabel.isHidden = false
        
        let defaults = UserDefaults.standard
        
        if let userData = defaults.object(forKey: "endpoint") as? Data {
            if let endpoint = NSKeyedUnarchiver.unarchiveObject(with: userData) as? Endpoint {
                
                if let id = endpoint.endpointID {
                    let text = "EndpointID: " + id
                    endpointIDLabel.text = text
                }
            }
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "idToken")
        let storyBoard = UIStoryboard.init(name: "Main", bundle:.main)
        
        let vc = storyBoard.instantiateViewController(withIdentifier:"HomeVC")
        
        self.navigationController?.pushViewController(vc, animated: true)
        
//        if let vCtrls = self.navigationController?.viewControllers {
//            let homeVC = vCtrls[1]
//
//            self.navigationController?.popToViewController(homeVC, animated: true)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pairButton.makeRoundedCornersWithBorder()
        yesButton.makeRoundedCornersWithBorder()
        noButton.makeRoundedCornersWithBorder()
        
        pairButton.alpha = 0.5
        pairButton.isUserInteractionEnabled = false
        
        idToken = UserDefaults.standard.string(forKey: "idToken")
        
        let endPointName = UserDefaults.standard.object(forKey: "endPointName") as? String
        
        let defaults = UserDefaults.standard

        var appName: String?
        if let userData = defaults.object(forKey: "endpoint") as? Data {
            if let endpoint = NSKeyedUnarchiver.unarchiveObject(with: userData) as? Endpoint {
                appName = endpoint.applicationName
            }
        }

        if endPointName != nil && appName != nil {

            endpointTextField.text = endPointName
            appTypeTextField.text = appName

            pairButton.alpha = 1.0
            pairButton.isUserInteractionEnabled = true

            showUnpairView()
        }
        
        self.hideKeyboardWhenTap()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func bringFormPopupView()
    {
        self.view.layoutIfNeeded()
        
        let blurEffect = UIBlurEffect(style: .dark)
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            
            //self.view.backgroundColor = self.view.backgroundColor
            
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.view.addSubview(blurEffectView)
            
        } else {
            self.view.backgroundColor = .black
            
        }
        
        self.perform(#selector(dismissPopupView), with: nil, afterDelay: 5.0)
        
        UIView.animate(withDuration:0.5) {
            
            self.view.layoutIfNeeded()
            
            if self.isSuccessView {
                self.successView.isHidden = false
                self.successViewVerticalConstraint.constant = 0
                self.view.addSubview(self.successView)
            }
            else {
                 // show logout view
                self.logoutViewVerticalConstraint.constant = 0
                if let appName = UserDefaults.standard.string(forKey: "appName") {
                    self.logoutLabel.text = "Do you want to log out of Admin Mode to launch application - " + appName
                }
                self.view.addSubview(self.logoutView)
            }
        }
    }
    
 @objc func dismissPopupView()
    {
        var refBlurVw:UIVisualEffectView?
        
        for vw in self.view.subviews
        {
            if vw is UIVisualEffectView
            {
                refBlurVw = vw as? UIVisualEffectView
            }
        }
        
        if let blrVw = refBlurVw
        {
            blrVw.removeFromSuperview()
        }
        
        self.logoutViewVerticalConstraint.constant = 900
        successViewVerticalConstraint.constant = 900
        self.isSuccessView = false
        
        if isUnpairView == false {
            bringFormPopupView()
        }
    }

}

extension AdminSettingsViewController: AdminListTypeDelegate {
    
    func appTypeSelected(value: String, selectedIndex: Int) {
        appTypeTextField.text = value
        
        self.selectedAppId = self.appIdArray.object(at: selectedIndex) as? String
        if appTypeTextField.text != "" {
            self.appTypeTextField.roundedWithBlueBorder()
        }
        else {
            self.appTypeTextField.roundedWithGrayBorder()
        }
        if endpointTextField.text?.count == 0 || appTypeTextField.text?.count == 0 {
            pairButton.alpha = 0.5
            pairButton.isUserInteractionEnabled = false
        }
        else {
            pairButton.alpha = 1.0
            pairButton.isUserInteractionEnabled = true
        }
    }
}
extension AdminSettingsViewController : UITextFieldDelegate
{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
            let currentCharacterCount = endpointTextField.text?.count ?? 0
            
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            
            let newLength = currentCharacterCount + string.count - range.length
            
            // Handling UI
            if newLength == 0 {
                self.endpointTextField.roundedWithGrayBorder()
            }
            else {
                self.endpointTextField.roundedWithBlueBorder()
            }
        
        if newLength == 0 || appTypeTextField.text?.count == 0 {
            pairButton.alpha = 0.5
            pairButton.isUserInteractionEnabled = false
        }
        else {
            pairButton.alpha = 1.0
            pairButton.isUserInteractionEnabled = true
        }
            return newLength <= 30
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

}
