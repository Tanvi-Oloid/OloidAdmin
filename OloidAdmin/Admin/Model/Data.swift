//
//  Data.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 22/05/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    var password: String?
    var email: String?
    
    init(password: String, email: String) {
        self.password = password
        self.email = email
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let password = aDecoder.decodeObject(forKey: "password") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        self.init(password: password, email: email)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(password, forKey: "password")
        coder.encode(email, forKey: "email")
    }
}

class AdminUser: User {

    var tenantName: String?
    var tenantId: String?
    
    init(tenantName: String, tenantId: String, password: String, email: String) {
        
        super.init(password: password , email: email)
        self.tenantName = tenantName
        self.tenantId = tenantId
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let tenantName = aDecoder.decodeObject(forKey: "tenantName") as! String
        let tenantId = aDecoder.decodeObject(forKey: "tenantId") as! String
        let password = aDecoder.decodeObject(forKey: "password") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        
        self.init(tenantName: tenantName, tenantId: tenantId, password: password, email: email)
    }
    override func encode(with coder: NSCoder) {
        coder.encode(tenantName, forKey: "tenantName")
        coder.encode(tenantId, forKey: "tenantId")
        coder.encode(password, forKey: "password")
        coder.encode(email, forKey: "email")
    }

}

class Endpoint: User {
   
    var endpointID: String?
    var applicationID: String?
    var applicationName: String?
    
    init(endpointId: String, applicationId: String, applicationName: String,password: String, email: String) {
        
        super.init(password: password , email: email)
        self.endpointID = endpointId
        self.applicationID = applicationId
        self.applicationName = applicationName
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let endpointID = aDecoder.decodeObject(forKey: "endpointID") as! String
        let applicationID = aDecoder.decodeObject(forKey: "applicationID") as! String
        let applicationName = aDecoder.decodeObject(forKey: "applicationName") as! String
        let password = aDecoder.decodeObject(forKey: "password") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        
        self.init(endpointId: endpointID, applicationId: applicationID, applicationName: applicationName, password: password, email: email)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(endpointID, forKey: "endpointID")
        coder.encode(applicationID, forKey: "applicationID")
        coder.encode(applicationName, forKey: "applicationName")
        coder.encode(password, forKey: "password")
        coder.encode(email, forKey: "email")
    }
}




// Currently not in use
struct ResultData: Decodable {
    let data: String
}

struct LoginToken: Decodable {

    let idToken: String
}

struct AppListArray: Decodable {
    let listArray: [String]
}
