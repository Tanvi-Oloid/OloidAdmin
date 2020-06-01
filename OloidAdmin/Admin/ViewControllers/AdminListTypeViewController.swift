//
//  AdminListTypeViewController.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 23/05/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import UIKit

protocol AdminListTypeDelegate {
    
    func appTypeSelected(value:String, selectedIndex: Int)
}

class AdminListTypeViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var delegate:AdminListTypeDelegate?
    
    var listArray: NSArray!
    
    override func viewDidLoad() {
        
    }

}
extension AdminListTypeViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"AdminListTypeCellIdentifier", for: indexPath) as! AdminListTypeCell
        
        let value = listArray[indexPath.row] as! String
        cell.valueLabel.text = value
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedValue = listArray.object(at: indexPath.row) as! String
        
        self.delegate?.appTypeSelected(value: selectedValue, selectedIndex: indexPath.row)
        
        self.dismiss(animated: true, completion: nil)
    }
}

class AdminListTypeCell: UITableViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    
    
}
