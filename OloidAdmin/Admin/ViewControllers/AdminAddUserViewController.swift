//
//  AdminAddUserViewController.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 04/06/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

class AdminAddUserViewController: UIViewController {
    
    var adminAPIManager = AdminAPIManager.init()
    @IBOutlet weak var vwMetaDataForm: UIView!
    
    var addUserPopUpView = AddUserPopUpview()
    var addBadgePopUpView = BadgePopUpView()
    var userDetailVC = AdminUserProfileViewController()
    
    var connIdArray: NSArray!
    var selectedId: String!
    var connectionName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpPopUpViews()
        self.bringFormPopupView()
//        self.setUpVwFormMetadata()
//        self.addPopUpView()
        // Do any additional setup after loading the view.
    }
    
    func setUpPopUpViews() {
        self.addUserPopUpView = AddUserPopUpview.instantiate()
        
        let themeColor = UIColor(red: 29.0/255.0, green:139.0/255.0 , blue: 241.0/255.0, alpha: 1.0)
        
        self.addUserPopUpView.cancelButton.layer.cornerRadius = 2.0
        self.addUserPopUpView.cancelButton.layer.borderColor = themeColor.cgColor
        
        self.addUserPopUpView.cancelButton.layer.borderWidth = 2.0
        
        self.addUserPopUpView.layer.cornerRadius = 10.0
        self.addUserPopUpView.center = CGPoint(x: self.view.frame.size.width  / 2,
        y: self.view.frame.size.height / 2)
        self.addUserPopUpView.delegate = self
        
        self.addBadgePopUpView = BadgePopUpView.instantiate()
        self.addBadgePopUpView.layer.cornerRadius = 10.0
        self.addBadgePopUpView.center = CGPoint(x: self.view.frame.size.width  / 2,
        y: self.view.frame.size.height / 2)
        self.addBadgePopUpView.delegate = self
        //self.setDelegates()
        
        self.addBadgePopUpView.cancelButton.layer.cornerRadius = 2.0
        self.addBadgePopUpView.cancelButton.layer.borderColor = themeColor.cgColor
        
        self.addBadgePopUpView.cancelButton.layer.borderWidth = 2.0
        
        self.addUserPopUpView.errorLabel.isHidden = true
        self.addBadgePopUpView.errorLabel.isHidden = true
    }
    
//    func setUpVwFormMetadata()
//    {
//        self.vwMetaDataForm.clipsToBounds = true
//        self.vwMetaDataForm.layer.cornerRadius = 8.0
//
//        for vw in self.vwMetaDataForm.subviews
//        {
//            if vw is ViewFaceMetaDataPopup
//            {
//                refOfStackVw = vw as? ViewFaceMetaDataPopup
//                break
//            }
//        }
//
//        if let stackVw = refOfStackVw
//        {
//            stackVw.delegate = self
//        }
//    }
    
    func addPopUpView() {
        /*let app = UIApplication.shared.delegate as! AppDelegate
        
        if let activityTracker = app.adminActivityTracker
        {
            activityTracker.setNewDate(date: Date())
        }*/
        
        self.bringFormPopupView()
    }
    
    func bringFormPopupView()
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
        
        UIView.animate(withDuration:0.5) {
            
           // self.topPopUpConstrain.constant = 350
            
            self.view.layoutIfNeeded()
            
            self.view.addSubview(self.addUserPopUpView)
            
            //self.view.addSubview(self.vwMetaDataForm)
            
        }
        
        //refOfStackVw?.setDefaults()
    }
    func dismissPopupView()
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
        
        UIView.animate(withDuration:0.5) {
            
           // self.topPopUpConstrain.constant = -500
            
            self.view.layoutIfNeeded()
            
            //self.view.addSubview(self.vwMetaDataForm)
            
        }
    }

}
//extension AdminAddUserViewController : ViewFaceMetaDataPopupDelegate
//{
//    func didNextButtonTap(inputs: FormInputs) {
//
//        self.dismissPopupView()
//        print("inputs: \(inputs)")
//
//        let app = UIApplication.shared.delegate as! AppDelegate
//
//        if let activityTracker = app.adminActivityTracker
//        {
//            activityTracker.setNewDate(date: Date())
//        }
//
//        let userMetaData = UserMetaData.init(badgeNumber: inputs.badgeNumber, displayName: inputs.displayName)
//
//        self.sendToPhotoClickMode(userMetaData: userMetaData)
//    }
//
//    func didCollectionNameTap() {
//        // call collection api
//    }
//
//    func didCancelButtonTap() {
//
//        let app = UIApplication.shared.delegate as! AppDelegate
//
//        if let activityTracker = app.adminActivityTracker
//        {
//            activityTracker.setNewDate(date: Date())
//        }
//
//        self.dismissPopupView()
//        print("cancel")
//    }
//
//    func bringFormPopupView()
//    {
//        self.view.layoutIfNeeded()
//
//        let blurEffect = UIBlurEffect(style: .dark)
//
//        if !UIAccessibility.isReduceTransparencyEnabled {
//
//            //self.view.backgroundColor = self.view.backgroundColor
//
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            //always fill the view
//            blurEffectView.frame = self.view.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//            self.view.addSubview(blurEffectView)
//
//        } else {
//            self.view.backgroundColor = .black
//
//        }
//
//        UIView.animate(withDuration:0.5) {
//
//            //self.topPopUpConstrain.constant = 350
//
//            self.view.layoutIfNeeded()
//
//            self.view.addSubview(self.vwMetaDataForm)
//        }
//
//        refOfStackVw?.setDefaults()
//    }
//
//    func dismissPopupView()
//    {
//        var refBlurVw:UIVisualEffectView?
//
//        for vw in self.view.subviews
//        {
//            if vw is UIVisualEffectView
//            {
//                refBlurVw = vw as? UIVisualEffectView
//            }
//        }
//
//        if let blrVw = refBlurVw
//        {
//            blrVw.removeFromSuperview()
//        }
//
//        UIView.animate(withDuration:0.5) {
//
//           // self.topPopUpConstrain.constant = -500
//
//            self.view.layoutIfNeeded()
//
//            self.view.addSubview(self.vwMetaDataForm)
//
//        }
//    }
//}

// MARK: Add User Pop up Delegate

extension AdminAddUserViewController : AddUserPopUpviewDelegate
{
    func onCollectionNameClick() {
        // call API
        addUserPopUpView.activityIndicator.startAnimating()
        adminAPIManager.listConnectionsAPi { (responseArray,idArray, error) in
            
            DispatchQueue.main.async {
                
                self.addUserPopUpView.activityIndicator.stopAnimating()
                
                if error == nil {
                    if responseArray.count != 0 {
                        
                        self.connIdArray = idArray
                        
                        let storyBoard = UIStoryboard.init(name: "Admin", bundle:.main)
                        let vc = storyBoard.instantiateViewController(withIdentifier:"AdminListTypeViewController") as! AdminListTypeViewController
                        vc.delegate = self
                        vc.listArray = responseArray
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    else {
                        self.addUserPopUpView.errorLabel.isHidden = false
                        self.addUserPopUpView.errorLabel.text = "There are no connections"
                    }
                }
                else {
                   //  show error
                    self.addUserPopUpView.errorLabel.isHidden = false
                    self.addUserPopUpView.errorLabel.text = error?.localizedDescription
                }
            }
        }
    }
    
    func onAddUserNextButtonTapped(userID: String, name: String) {
        //let view = BadgePopUpView.instantiate()
        
        addUserPopUpView.removeFromSuperview()
        
        addBadgePopUpView.userID = userID
        addBadgePopUpView.userName = name
        self.view.addSubview(addBadgePopUpView)
    }
    func onAddUserCancelButtonTapped() {
//        addUserPopUpView.userIdTextField.text = ""
//        addUserPopUpView.nameTextField.text = ""
//        addUserPopUpView.nextButton.isEnabled = false
//        addUserPopUpView.nextButton.alpha = 0.5
//
//        addUserPopUpView.removeFromSuperview()
//        let app = UIApplication.shared.delegate as! AppDelegate
//
//        if let activityTracker = app.adminActivityTracker
//        {
//            activityTracker.setNewDate(date: Date())
//        }
//        self.dismissPopupView()
//        print("cancel")
    }
}

// MARK: Badge Pop up Delegate
extension AdminAddUserViewController : BadgePopUpViewDelegate
{
    func onBadgeViewNextTapped(userID: String, name: String, badgeNumber: String) {
        
        // call aPI
        
        self.addBadgePopUpView.errorLabel.isHidden = true
        addBadgePopUpView.activityIndicator.startAnimating()
        let defaults = UserDefaults.standard
        guard let userData = defaults.object(forKey: "user") as? Data else {
            return
        }
        guard let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User else {
            return
        }
        
        adminAPIManager.callAddUserAPI(connectionId: self.selectedId, fullName: name, primaryID: userID, secondaryID: badgeNumber) { (responseArray,  error) in
                        
            DispatchQueue.main.async {
                self.addBadgePopUpView.activityIndicator.stopAnimating()
                
                if error == nil {
                    let storyBoard = UIStoryboard.init(name: "Admin", bundle:.main)
                    self.userDetailVC = storyBoard.instantiateViewController(withIdentifier:"AdminUserViewController") as! AdminUserProfileViewController
                    
                    self.userDetailVC.delegate = self
                    self.userDetailVC.fullName = name
                    self.userDetailVC.secondaryID = badgeNumber
                    self.userDetailVC.primaryID = userID
                    self.userDetailVC.connName = self.connectionName
                    self.addBadgePopUpView.removeFromSuperview()
                    self.view.addSubview(self.userDetailVC.view)
                                                                    
                    //self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    self.addBadgePopUpView.errorLabel.isHidden = false
                    self.addBadgePopUpView.errorLabel.text = error?.localizedDescription
                }
            }
        }
        
        
//        addBadgePopUpView.badgeTextField.text = ""
//        
//        addUserPopUpView.userIdTextField.text = ""
//        addUserPopUpView.nameTextField.text = ""
//        addUserPopUpView.nextButton.isEnabled = false
//        addUserPopUpView.nextButton.alpha = 0.5
//        
//        addBadgePopUpView.removeFromSuperview()
//        self.dismissPopupView()
        
        /*let app = UIApplication.shared.delegate as! AppDelegate
        
        if let activityTracker = app.adminActivityTracker
        {
            activityTracker.setNewDate(date: Date())
        }*/
    }
    
    func onBadgeViewCancelTapped() {
        
        // Making text fields empty when user pop back to parent.
        addBadgePopUpView.badgeTextField.text = ""
        
        addUserPopUpView.userIdTextField.text = ""
        addUserPopUpView.nameTextField.text = ""
        addUserPopUpView.nextButton.isEnabled = false
        addUserPopUpView.nextButton.alpha = 0.5
        
        addBadgePopUpView.removeFromSuperview()
        
//        addUserPopUpView.removeFromSuperview()
//
//        addBadgePopUpView.userID = userID
//        addBadgePopUpView.userName = name
        self.view.addSubview(addUserPopUpView)
        
        /*let app = UIApplication.shared.delegate as! AppDelegate
        
        if let activityTracker = app.adminActivityTracker
        {
            activityTracker.setNewDate(date: Date())
        }*/
        
        //self.dismissPopupView()
        print("cancel")
    }
}

extension AdminAddUserViewController: AdminListTypeDelegate {
    
    func appTypeSelected(value: String, selectedIndex: Int) {
        addUserPopUpView.collectionTextField.text = value
        self.connectionName = value
        
        self.selectedId = self.connIdArray.object(at: selectedIndex) as? String
        
        if addUserPopUpView.collectionTextField.text != "" && addUserPopUpView.nameTextField.text != "" && addUserPopUpView.userIdTextField.text != "" {
            
            addUserPopUpView.nextButton.alpha = 1.0
            addUserPopUpView.nextButton.isUserInteractionEnabled = true
        }
        else {
            addUserPopUpView.nextButton.alpha = 0.5
            addUserPopUpView.nextButton.isUserInteractionEnabled = false
        }
    }
}

extension AdminAddUserViewController: AdminUserViewDelegate {
    func onAdminUserViewBackTapped() {
        self.userDetailVC.view.removeFromSuperview()
        self.view.addSubview(addUserPopUpView)
    }
}
