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
    
    var addUserPopUpView = AddUserPopUpview()
    var addBadgePopUpView = BadgePopUpView()
    var userDetailVC = AdminUserProfileViewController()
    
    var connIdArray: NSArray!
    var connNameArray: NSArray!
    var selectedId: String!
    var connectionName: String!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTap()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkForEmptyScreen()
        super.viewWillAppear(animated)
    }
    
    func checkForEmptyScreen() {
        
        var appID: String?
        
        let defaults = UserDefaults.standard
        if let userData = defaults.object(forKey: "endpoint") as? Data {
            if let endpoint = NSKeyedUnarchiver.unarchiveObject(with: userData) as? Endpoint {
                appID = endpoint.applicationID
                
                errorLabel.isHidden = true
                callListConnectionAPI()
                
            }
        }
        else {
            appID = ""
            errorLabel.isHidden = false
        }
        
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
    
    func addPopUpView() {
//        let app = UIApplication.shared.delegate as! AppDelegate
//
//        if let activityTracker = app.adminActivityTracker
//        {
//            activityTracker.setNewDate(date: Date())
//        }
        
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
                        
            self.view.layoutIfNeeded()
            self.view.addSubview(self.addUserPopUpView)
        }
    }
    
    func dismissPopupView() {
        var refBlurVw:UIVisualEffectView?
        
        for vw in self.view.subviews {
            if vw is UIVisualEffectView
            {
                refBlurVw = vw as? UIVisualEffectView
            }
        }
        if let blrVw = refBlurVw {
            blrVw.removeFromSuperview()
        }
        
        UIView.animate(withDuration:0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func callListConnectionAPI() {
        // call API
        //addUserPopUpView.activityIndicator.startAnimating()
        
        self.activityIndicator.startAnimating()
        errorLabel.isHidden = false
        errorLabel.text = "Fetching connections list"
        adminAPIManager.listConnectionsAPi { (responseArray,idArray, error) in
            
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                
                if error == nil {
                    self.errorLabel.isHidden = true
                    
                    if responseArray.count != 0 {
                        self.connIdArray = idArray
                        self.connNameArray = responseArray
                        self.setUpPopUpViews()
                        self.bringFormPopupView()
                    }
                    else {
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = "There are no connections."
                        //self.addUserPopUpView.errorLabel.isHidden = false
                        //self.addUserPopUpView.errorLabel.text = "There are no connections"
                    }
                }
                else {
                   //  show error
                    
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = error?.localizedDescription
//                    self.addUserPopUpView.errorLabel.isHidden = false
//                    self.addUserPopUpView.errorLabel.text = error?.localizedDescription
                }
            }
        }
    }
}

// MARK: Add User Pop up Delegate

extension AdminAddUserViewController : AddUserPopUpviewDelegate
{
    func onCollectionNameClick() {
        let storyBoard = UIStoryboard.init(name: "Admin", bundle:.main)
        let vc = storyBoard.instantiateViewController(withIdentifier:"AdminListTypeViewController") as! AdminListTypeViewController
        vc.delegate = self
        vc.listArray = self.connNameArray
        self.present(vc, animated: true, completion: nil)
    }
    
    func onAddUserNextButtonTapped(userID: String, name: String) {
        //let view = BadgePopUpView.instantiate()
        
        addUserPopUpView.removeFromSuperview()
        
        addBadgePopUpView.userID = userID
        addBadgePopUpView.userName = name
        self.view.addSubview(addBadgePopUpView)
    }
    func onAddUserCancelButtonTapped() {
        
        let storyBoard = UIStoryboard.init(name: "Admin", bundle:.main)
        let vc = storyBoard.instantiateViewController(withIdentifier:"Tabbar") as! UITabBarController
        
        vc.selectedIndex = 0
        
                                    
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let storyBoard = UIStoryboard.init(name: "Admin", bundle:.main)
//        let vc = storyBoard.instantiateViewController(withIdentifier:"CICOFaceListVC")
//
//        //vc.idToken = response
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
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
        
        
        self.addBadgePopUpView.errorLabel.isHidden = true
        addBadgePopUpView.activityIndicator.startAnimating()
        let defaults = UserDefaults.standard
        guard let userData = defaults.object(forKey: "user") as? Data else {
            return
        }
        guard let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User else {
            return
        }
        
        adminAPIManager.callAddUserAPI(connectionId: self.selectedId, fullName: name, primaryID: userID, secondaryID: badgeNumber) { (response,  error) in
                        
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
        
//        let app = UIApplication.shared.delegate as! AppDelegate
//
//        if let activityTracker = app.adminActivityTracker
//        {
//            activityTracker.setNewDate(date: Date())
//        }
    }
    
    func onBadgeViewCancelTapped() {
        
        // Making text fields empty when user pop back to parent.
        addBadgePopUpView.badgeTextField.text = ""
        
        addUserPopUpView.userIdTextField.text = ""
        addUserPopUpView.nameTextField.text = ""
        addUserPopUpView.nextButton.isEnabled = false
        addUserPopUpView.nextButton.alpha = 0.5
        addBadgePopUpView.errorLabel.isHidden = true
        
        addBadgePopUpView.removeFromSuperview()
        
//        addUserPopUpView.removeFromSuperview()
//
//        addBadgePopUpView.userID = userID
//        addBadgePopUpView.userName = name
        self.view.addSubview(addUserPopUpView)
//        let app = UIApplication.shared.delegate as! AppDelegate
//
//        if let activityTracker = app.adminActivityTracker
//        {
//            activityTracker.setNewDate(date: Date())
//        }
        
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
