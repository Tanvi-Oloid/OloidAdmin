//
//  CICOFaceListVC.swift
//  CICOApp
//
//  Created by Lxkant on 5/17/19.
//  Copyright © 2019 Proxce Inc. All rights reserved.
//

import UIKit

class CellFaceBadges:UITableViewCell
{
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblPrimaryId:UILabel! // lblBadgeNumber
    @IBOutlet var lblNumberOfFaces:UILabel!
    //@IBOutlet var imgOfFace:UIImageView!
    @IBOutlet var lblLastUpdated:UILabel!
}

class CICOFaceListVC: UIViewController {
            
    @IBOutlet var tblView:UITableView!
    
    var aryBadges = [String]()
    
    var aryFilteredBadges = [String]()
    
//    var dictGroupedObjs = [String:[CICOFaceVaultObject]]()
//
//    var aryFaceObjectsUnGrouped = [CICOFaceVaultObject]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var lblNoDataMsg: UILabel!
    
    @IBOutlet weak var activityIndicator:
    UIActivityIndicatorView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
//    var awsProviderReference:CICOAWSProvider!
//
//    var cicoTimeUtility = CICOTimeUtility()
    
    var adminAPIManager = AdminAPIManager.init()
    
    var resultArray: NSArray = []
    var fullNameArray: [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.barStyle = .blackOpaque

        searchBar.tintColor = UIColor.init(red: 95.0/255.0, green: 158.0/255.0, blue: 252/255.0, alpha: 1.0)
        
        searchBar.backgroundColor = UIColor.clear
        
        lblNoDataMsg.isHidden = true
        
        self.setBarBorderOfSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        checkForEmptyScreen()
        
        //        let app = UIApplication.shared.delegate as! AppDelegate
        //
        //        if let activityTracker = app.adminActivityTracker
        //        {
        //            activityTracker.setNewDate(date: Date())
        //        }
        //
        //        if let cicoServices = appDelegate.cicoServices
        //        {
        //            var awsProvider = cicoServices.awsProvider()
        //            awsProvider.delegate = self
        //        }
        //
        //        self.fetchFaces()
        
        self.setDelegates()
    }
    
    
    func checkForEmptyScreen() {
        
        var appID: String?
        
        let defaults = UserDefaults.standard
        if let userData = defaults.object(forKey: "endpoint") as? Data {
            if let endpoint = NSKeyedUnarchiver.unarchiveObject(with: userData) as? Endpoint {
                appID = endpoint.applicationID
                
                lblNoDataMsg.isHidden = true
                tblView.isHidden = false
                if let appID = appID {
                    self.callListApplicationUsersAPI(appID: appID)
                }
            }
        }
        else {
            appID = ""
             lblNoDataMsg.isHidden = false
             tblView.isHidden = true
        }
    }
    
    func callListApplicationUsersAPI(appID: String) {
        
        var connID: String? = ""
        var oloid: String? = ""
        
        self.activityIndicator.startAnimating()
        self.tblView.isHidden = true
        
        oloid = UserDefaults.standard.string(forKey: "oloid")
        connID = UserDefaults.standard.string(forKey: "connection")
                    
        adminAPIManager.callListApplicationUsersAPI(applicationID: appID, connectionID: connID ?? "", oloid: oloid ?? "") { (responseArray,  error) in
                        
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                if error == nil {
                    self.resultArray = responseArray
                    self.tblView.isHidden = false
                    
                    for dict in self.resultArray {
                        if let obj = dict as? [String: Any] {
                            let name = obj["FullName"] as? String ?? ""
                            self.fullNameArray.append(name)
                        }
                    }
                    self.tblView.reloadData()
                }
                else {
                    self.lblNoDataMsg.isHidden = false
                    self.lblNoDataMsg.text = error?.localizedDescription
                }
            }
        }
    }
    
    func setBarBorderOfSearchBar()
    {
        for obj in (searchBar.subviews.first)!.subviews
        {
            if obj is UITextField
            {
                let txtFied = obj as! UITextField
                txtFied.clipsToBounds = true
                txtFied.layer.borderColor = UIColor.init(red: 95.0/255.0, green: 158.0/255.0, blue: 252/255.0, alpha:0.5).cgColor
                txtFied.layer.borderWidth = 0.8
                txtFied.layer.cornerRadius = 5.0
            }
        }
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
    
    deinit {
        
        //print("claiming CICOFaceListVC")
        
//        NotificationCenter.default.removeObserver(self, name: CICOConstants.Notification.nOnAppLogoUpdate, object: nil)
    }
    
//    @objc func onUpdateAppLogo(notification:Notification)
//    {
//        if let obj = notification.object
//        {
//            let img = obj as! UIImage
//
//            //self.imgVwLogo.image = img
//        }
//    }
    
    func showData(isShow:Bool)
    {
        DispatchQueue.main.async {
            
            self.tblView.isHidden = !isShow
            self.lblNoDataMsg.isHidden = isShow
        }
    }
    
    func setDelegates()
    {
        self.searchBar.delegate = self
        tblView.delegate = self
        tblView.dataSource = self
    }
    
//    @objc func refreshList()
//    {
//        self.searchBar.text = nil
//        self.fetchFaces()
//    }
    
    
//    func fetchFaces()
//    {
//        DispatchQueue.main.async { [weak self] in
//
//            self?.tblView.alpha = 0.0
//            // TODO:
//            //self?.activityIndicator.startAnimating()
//        }
//
//        if let cicoServices = appDelegate.cicoServices
//        {
//            var awsProvider = cicoServices.awsProvider()
//            awsProvider.delegate = self
//            awsProvider.listFacesFromAmazonReck()
//        }
//    }
    
    
//    @IBAction func onTapCancleAdminMode(_ sender: Any)
//    {
//        let btn = sender as! UIButton
//
//        btn.pressEffect()
//
//        let app = UIApplication.shared.delegate as! AppDelegate
//
//        if let activityTracker = app.adminActivityTracker
//        {
//            activityTracker.setNewDate(date: Date())
//        }
//
//        let alertVC = UIAlertController.init(title:"Are you sure?", message:"You want to logout from admin mode?", preferredStyle:.alert)
//
//        let actionYES = UIAlertAction.init(title:"YES".uppercased(), style: .cancel) { [weak self] (_) in
//
//            self?.perform(#selector(self?.logoutAdminMode), with: nil, afterDelay: 0.01)
//        }
//
//        let actionCancle = UIAlertAction.init(title:"cancel".uppercased(), style: .default) { (_) in
//
//            let app = UIApplication.shared.delegate as! AppDelegate
//
//            if let activityTracker = app.adminActivityTracker
//            {
//                activityTracker.setNewDate(date: Date())
//            }
//        }
//
//        alertVC.addAction(actionYES)
//        alertVC.addAction(actionCancle)
//
//        self.present(alertVC, animated: true, completion: nil)
//    }
    
//    @IBAction func onTapAddNewFace(_ sender: Any)
//    {
////        let app = UIApplication.shared.delegate as! AppDelegate
////
////        if let activityTracker = app.adminActivityTracker
////        {
////            activityTracker.setNewDate(date: Date())
////        }
////
////        self.bringFormPopupView()
//
//    }
    
//    func sendToPhotoClickMode(userMetaData:UserMetaData)
//    {
//        #if arch(i386) || arch(x86_64)
//        //print("Camera not supported in simulater,Please run in real device")
//        #else
//        self.searchBar.resignFirstResponder()
//        let vcCamera = self.storyboard?.instantiateViewController(withIdentifier:"PhotoCaptureVC") as!  PhotoCaptureVC
//        vcCamera.userMetaData = userMetaData
//        self.navigationController?.pushViewController(vcCamera, animated:false)
//        #endif
//    }
    
    @objc func promptInValidInput()
    {
        let alertController = UIAlertController(title: "Sorry!", message: "Invalid input", preferredStyle: .alert)
        
        // A cancel action
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            
            
        }
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func logoutAdminMode()
    {
//        let app = UIApplication.shared.delegate as! AppDelegate
//
//        if let activityTracker = app.adminActivityTracker
//        {
//            activityTracker.cleanUp()
//        }
//
//        app.adminActivityTracker = nil

        self.dismiss(animated:true, completion: nil)
    }
    
//    func getLastUpdatedDateTime(aryFaceObjects:[CICOFaceVaultObject]) -> (String?,Date?)
//    {
//        var maxTimeStamp:TimeInterval?
//
//        if let objFirst = aryFaceObjects.first
//        {
//            if let key = objFirst.key
//            {
//                let seperatedByUnderscore = key.components(separatedBy:"_")
//
//                if seperatedByUnderscore.count == 3
//                {
//                    if let strTimeStamp = seperatedByUnderscore.last
//                    {
//                        maxTimeStamp = TimeInterval(strTimeStamp)
//                    }
//                }
//            }
//        }
//
//        for obj in aryFaceObjects
//        {
//            if let key = obj.key
//            {
//                let seperatedByUnderscore = key.components(separatedBy:"_")
//
//                if seperatedByUnderscore.count == 3
//                {
//                    if let strTimeStamp = seperatedByUnderscore.last
//                    {
//                        if let timeStamp = TimeInterval(strTimeStamp),
//                           let mTimeStamp = maxTimeStamp
//                        {
//                            if timeStamp >= mTimeStamp
//                            {
//                                maxTimeStamp = timeStamp
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        if let mTimeStamp = maxTimeStamp
//        {
//            if let timeZone = appDelegate.getTimeZoneSettings()
//            {
//                // miliseconds to seconds
//                //let timeInSeconds = mTimeStamp
//
//                let (date,str12HourTime) = self.cicoTimeUtility.getSiteDate(strTimeZone: timeZone, epochTime:TimeInterval(mTimeStamp))
//
//
//                let dtComponents = str12HourTime?.components(separatedBy:"/")
//
//                // because of date conversion bug with miliseconds
//                if let year = dtComponents?.last
//                {
//                    let yearCompo = year.components(separatedBy:" ")
//
//                    if let yy = yearCompo.first
//                    {
//                        if let y = Int(yy)
//                        {
//                            if y > 2050
//                            {
//                                let timeInSeconds = mTimeStamp / 1000.0
//
//                                let (udate,ustr12HourTime) = self.cicoTimeUtility.getSiteDate(strTimeZone: timeZone, epochTime:TimeInterval(timeInSeconds))
//
//                                return (ustr12HourTime,udate)
//                            }
//                        }
//                    }
//                }
//
//                return (str12HourTime,date)
//            }
//
//        }
//
//        return (nil,nil)
//    }

}


extension CICOFaceListVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if self.resultArray.count != 0 {
            return self.resultArray.count
        }
        return 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"CellFaceBadges", for: indexPath) as! CellFaceBadges
        
        if self.resultArray.count != 0 {
            
            let dict = self.resultArray[indexPath.row]
            if let obj = dict as? [String: Any] {
                cell.lblName.text = obj["FullName"] as? String ?? ""
                cell.lblPrimaryId.text = obj["PrimaryID"] as? String ?? ""
                cell.lblLastUpdated.text = obj["UpdatedAt"] as? String ?? ""
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            
        }
        
//        let app = UIApplication.shared.delegate as! AppDelegate
//
//        if let activityTracker = app.adminActivityTracker
//        {
//            activityTracker.setNewDate(date: Date())
//        }
        
//        let badgeNumber = self.aryFilteredBadges[indexPath.row]
//
//        if let aryOfFaces = self.dictGroupedObjs[badgeNumber]
//        {
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier:"CICOFacesByBadgeID")
//            {
//                self.searchBar.resignFirstResponder()
//
//                let vcFaceByBadgeNumber = vc as! CICOFacesByBadgeID
//
//                vcFaceByBadgeNumber.aryFaceObjs = aryOfFaces
//
//                vcFaceByBadgeNumber.sourcePageTrigger = .from_homepage
//
//                if  let fObj = aryOfFaces.first,
//                    let badgeNumber = fObj.badgeNumber
//                {
//                    vcFaceByBadgeNumber.badgeNumber = badgeNumber
//                }
//
//                self.navigationController?.pushViewController(vcFaceByBadgeNumber, animated: true)
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170.0
    }
    
}

//extension CICOFaceListVC : CICOFaceDataDelegate
//{
//    func didDeleteFaceWithFaceIds(faceIds: [String], keys: [String]) {
//
//    }
//
//    func didFailToDeleteFaces(error: Error) {
//
//    }
//
//
//    func didReceiveFaceObjects(groupedObjs: [String : [CICOFaceVaultObject]], fObjs: [CICOFaceVaultObject])
//    {
//        DispatchQueue.main.async {
//
//            self.activityIndicator.stopAnimating()
//
//            self.tblView.alpha = 1.0
//
//            self.aryBadges = groupedObjs.keys.sorted()
//
//            self.aryFilteredBadges = self.aryBadges.sorted()
//
//            self.dictGroupedObjs = groupedObjs
//
//            //print("grouped objects: \(groupedObjs)")
//
//            self.aryFaceObjectsUnGrouped = fObjs
//
//            self.tblView.reloadData()
//
//            if self.aryFilteredBadges.count == 0
//            {
//                self.lblNoDataMsg.text = "No data found."
//                self.lblNoDataMsg.isHidden = false
//                self.tblView.isHidden = true
//            }
//            else
//            {
//                self.lblNoDataMsg.isHidden = true
//                self.tblView.isHidden = false
//            }
//        }
//    }
//
//    func didFailToReceiveFaceObjects(error: Error) {
//
//        DispatchQueue.main.async {
//
//            self.activityIndicator.stopAnimating()
//            self.tblView.reloadData()
//
//            self.lblNoDataMsg.text = "Some thing went wrong,Please try again later."
//            self.lblNoDataMsg.isHidden = false
//            self.tblView.isHidden = true
//        }
//    }
////
////    func didDownloadImage(img: UIImage, at indexPath: IndexPath) {
////
////        print("image download finish")
////
////        let badgeNumber = self.aryFilteredBadges[indexPath.row]
////
////        var aryObjs = self.dictGroupedObjs[badgeNumber]
////
////        if let fObj = aryObjs?.first
////        {
////            var obj = fObj
////
////            obj.img = img
////
////            aryObjs![0] = obj
////
////            self.dictGroupedObjs[badgeNumber] = aryObjs
////
////        }
////
////        DispatchQueue.main.async {
////
////            self.activityIndicator.stopAnimating()
////            self.tblView.reloadData()
////            //self.tblView.reloadRows(at: [indexPath], with:.none)
////        }
////    }
//
//}

extension CICOFaceListVC : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var searchedName: String? = ""
        var resultText: String? = ""
        
        if !searchText.isEmpty
        {
            let searchedText = searchText.lowercased()
            
//            self.aryFilteredBadges  = self.aryBadges.filter{
//                name in
//
//                return name.lowercased().contains(searchedText)
//            }
            
            if self.fullNameArray.count != 0 {
                self.fullNameArray.filter { name in
                    return name.lowercased().contains(searchedText)
                }
            }
            
            
            
            
//            if self.aryFilteredBadges.count == 0
//            {
//                let aryFilterByName = self.aryFaceObjectsUnGrouped.filter{
//                    obj in
//
//                    if let dp = obj.displayName
//                    {
//                        return dp.lowercased().contains(searchedText)
//                    }
//                    else
//                    {
//                        return false
//                    }
//
//                    /*if let fName = obj.firstName,
//                       let lName = obj.lastName
//                    {
//                        return fName.lowercased().contains(searchedText) || lName.lowercased().contains(searchedText)
//                    }
//                    else
//                    {
//                        return false
//                    }*/
//                }
//
//                  var tempAry = [String]()
//
//                  if aryFilterByName.count > 0
//                  {
//                       for obj in aryFilterByName
//                       {
//                            if let bNumber = obj.badgeNumber
//                            {
//                                if !tempAry.contains(bNumber)
//                                {
//                                    tempAry.append(bNumber)
//                                }
//                            }
//                       }
//                  }
//
//                  self.aryFilteredBadges = tempAry
//            }
//        }
//        else
//        {
//            self.aryFilteredBadges  = self.aryBadges
//        }
        
        self.tblView.reloadData()
    }
}
}


//extension CICOFaceListVC : ViewFaceMetaDataPopupDelegate
//{
//    func didCollectionNameTap() {
//        //
//    }
//
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
//            self.topPopUpConstrain.constant = 350
//
//            self.view.layoutIfNeeded()
//
//            self.view.addSubview(self.vwMetaDataForm)
//
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
//            self.topPopUpConstrain.constant = -500
//
//            self.view.layoutIfNeeded()
//
//            self.view.addSubview(self.vwMetaDataForm)
//
//        }
//    }
//
//
//}

//extension CICOFaceListVC : AdminActivityTrackerDelegate
//{
//    func noActivityDetected(fromLast: TimeInterval) {
//
//        self.logoutAdminMode()
//    }
//
//}


