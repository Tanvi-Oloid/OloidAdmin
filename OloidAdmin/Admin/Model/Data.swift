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
   
    var displayName: String?
    var secondaryID: String?
    var createdAt: String?
    var onlineModel: String?
    var primaryId: String?
    var updatedAt: String?
    var fullName: String?
    var connectionID: String?
    var deviceModel: String?
    var tenantName: String?
    var tenantID: String?
    var oloid: String?
    var status: String?
    var connectionDisplayName: String?

    
    init(displayName: String, secondaryID: String, createdAt: String, onlineModel: String, primaryId: String, updatedAt: String, fullName: String, connectionID: String, deviceModel: String, tenantName: String, tenantID: String, oloid: String, status: String, connectionDisplayName: String) {
        
        self.displayName = displayName
        self.secondaryID = secondaryID
        self.createdAt = createdAt
        self.onlineModel = onlineModel
        self.primaryId = primaryId
        self.updatedAt = updatedAt
        self.fullName = fullName
        self.connectionID = connectionID
        self.deviceModel = deviceModel
        self.tenantName = tenantName
        self.tenantID = tenantID
        self.oloid = oloid
        self.status = status
        self.connectionDisplayName = connectionDisplayName
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let displayName = aDecoder.decodeObject(forKey: "displayName") as? String
        let secondaryID = aDecoder.decodeObject(forKey: "secondaryID") as? String
        let createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
        let onlineModel = aDecoder.decodeObject(forKey: "onlineModel") as? String
        let primaryId = aDecoder.decodeObject(forKey: "primaryId") as? String
        let updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
        let fullName = aDecoder.decodeObject(forKey: "fullName") as? String
        let connectionID = aDecoder.decodeObject(forKey: "connectionID") as? String
        let deviceModel = aDecoder.decodeObject(forKey: "deviceModel") as? String
        let tenantName = aDecoder.decodeObject(forKey: "tenantName") as? String
        let tenantID = aDecoder.decodeObject(forKey: "tenantID") as? String
        let oloid = aDecoder.decodeObject(forKey: "oloid") as? String
        let status = aDecoder.decodeObject(forKey: "status") as? String
        let connectionDisplayName = aDecoder.decodeObject(forKey: "connectionDisplayName") as? String
        
        self.init(displayName: displayName ?? "", secondaryID: secondaryID ?? "", createdAt: createdAt ?? "", onlineModel: onlineModel ?? "", primaryId: primaryId ?? "", updatedAt:updatedAt ?? "", fullName: fullName ?? "", connectionID:connectionID ?? "", deviceModel: deviceModel ?? "", tenantName: tenantName ?? "", tenantID: tenantID ?? "", oloid:oloid ?? "", status:status ?? "", connectionDisplayName:connectionDisplayName ?? "")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(displayName, forKey: "displayName")
        coder.encode(secondaryID, forKey: "secondaryID")
        coder.encode(createdAt, forKey: "createdAt")
        coder.encode(onlineModel, forKey: "onlineModel")
        coder.encode(primaryId, forKey: "primaryId")
        coder.encode(updatedAt, forKey: "updatedAt")
        coder.encode(fullName, forKey: "fullName")
        coder.encode(connectionID, forKey: "connectionID")
        coder.encode(deviceModel, forKey: "deviceModel")
        coder.encode(tenantName, forKey: "tenantName")
        coder.encode(tenantID, forKey: "tenantID")
        coder.encode(oloid, forKey: "oloid")
        coder.encode(status, forKey: "status")
        coder.encode(connectionDisplayName, forKey: "connectionDisplayName")
        
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
