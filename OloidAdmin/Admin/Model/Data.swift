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


class Connection: NSObject {
   
    var connectionID: String?
    var desc: String?
    var onlineModel: String?
    var createdAt: String?
    var connectionDisplayName: String?
    var updatedAt: String?
    
    init(connectionID: String,description: String,onlineModel: String,createdAt: String,connectionDisplayName: String,updatedAt: String) {
        
        self.connectionID = connectionID
        self.desc = description
        self.onlineModel = onlineModel
        self.createdAt = createdAt
        self.connectionDisplayName = connectionDisplayName
        self.updatedAt = updatedAt
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let connectionID = aDecoder.decodeObject(forKey: "connectionID") as! String
        let description = aDecoder.decodeObject(forKey: "description") as! String
        let onlineModel = aDecoder.decodeObject(forKey: "onlineModel") as! String
        let createdAt = aDecoder.decodeObject(forKey: "createdAt") as! String
        let connectionDisplayName = aDecoder.decodeObject(forKey: "connectionDisplayName") as! String
        let updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as! String
        
        self.init(connectionID: connectionID, description: description, onlineModel: onlineModel,createdAt: createdAt, connectionDisplayName: connectionDisplayName, updatedAt: updatedAt)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(connectionID, forKey: "connectionID")
        coder.encode(desc, forKey: "description")
        coder.encode(onlineModel, forKey: "onlineModel")
        coder.encode(createdAt, forKey: "createdAt")
        coder.encode(connectionDisplayName, forKey: "connectionDisplayName")
        coder.encode(updatedAt, forKey: "updatedAt")
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
