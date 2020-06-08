//
//  AdminUserProfileViewController.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 05/06/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

protocol AdminUserViewDelegate : NSObjectProtocol {
    
    func onAdminUserViewBackTapped()
}

class AdminUserProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var primaryIdLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    weak var delegate:AdminUserViewDelegate?
    
    var fullName: String? = ""
    var secondaryID: String? = ""
    var connName: String? = ""
    var primaryID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        fullNameLabel.text = fullName
        primaryIdLabel.text = primaryID

        // Do any additional setup after loading the view.
    }
     @IBAction func onbackPressed(_ sender: Any) {
        self.delegate?.onAdminUserViewBackTapped()
    }
}
extension AdminUserProfileViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"AdminUserCellIdentifier", for: indexPath) as! AdminUserTypeCell
        
        if indexPath.row == 0 {
            cell.nameLabel.text = "Name"
            cell.valueLabel.text = fullName
        }
        else if indexPath.row == 1 {
            cell.nameLabel.text = "Secondary ID"
                       cell.valueLabel.text = secondaryID
        }
        else if indexPath.row == 2 {
            cell.nameLabel.text = "Connection Name"
            cell.valueLabel.text = connName
        }
        
//        let value = listArray[indexPath.row] as! String
//        cell.valueLabel.text = value
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedValue = listArray.object(at: indexPath.row) as! String
//
//        self.delegate?.appTypeSelected(value: selectedValue, selectedIndex: indexPath.row)
//
//        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 121.0
    }
}

class AdminUserTypeCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}
