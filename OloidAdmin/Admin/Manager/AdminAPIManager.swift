//
//  AdminAPIManager.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 21/05/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import Foundation

class AdminAPIManager: NSObject {
    
    typealias asynAPIResults = (_ response:String,_ error:NSError?) -> Void
    typealias applicationAPIResults = (_ response:NSArray,_ idArray:NSArray, _ error:NSError?) -> Void
    typealias pairAPIResults = (_ adminUserRes:AdminUser?, _ endpointRes: Endpoint?,_ error:NSError?) -> Void
    
    override init() {
        // 
    }
    
    func callLoginAPI(tenantName:String, uName:String, password:String, completionHandler:@escaping asynAPIResults) {
        
        let jsonBody:[String:Any] = [
                "TenantName": tenantName,
                "UserName": uName,
                "Password": password
        ]
        
        print("jsonBody: \(jsonBody)")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        
        // create post request
        
        guard let url = URL(string: AdminConstants.AdminUrlConstants.kLoginUrl) else
        {
            return
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        print("request sent: \(String(describing: request.allHTTPHeaderFields))")
        
        // insert json data to the request
        request.httpBody = jsonData
        request.timeoutInterval = 5.0
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            let httpResponse = response as! HTTPURLResponse
            
            let statusCode = httpResponse.statusCode
            
            print("header: \(statusCode) response json: \(httpResponse)")
            
//            let dRes = String(data: data, encoding: .utf8)
//
//            print("dResponse: \(String(describing: dRes))")
            
            if statusCode == Int(200) || statusCode == Int(201) {
                
                if let responseJSON = responseData as? [String: Any]
                {
                    let dictionary =  responseJSON["cognitoToken"] as! NSDictionary
                    
                    let subDict = dictionary["AuthenticationResult"] as! NSDictionary
                    
                    let idToken = subDict["IdToken"] as! String
                    let expireTime = subDict["ExpiresIn"] as! Int
                    
                    UserDefaults.standard.set(idToken, forKey: "idToken")
                    UserDefaults.standard.set(expireTime, forKey: "loginExpireTime")
                    
                    completionHandler(idToken,nil)
                }
            }
            else {
                completionHandler("error",nil)
            }
        }
        task.resume()
    }
    
    func getListApplications(completionHandler:@escaping applicationAPIResults) {
        
        // create post request
        
        guard let url = URL(string: AdminConstants.AdminUrlConstants.kListApplicationUrl) else
        {
            return
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
                
        let authorization = UserDefaults.standard.string(forKey: "idToken")
                
        request.setValue(authorization, forHTTPHeaderField:"Authorization")
        
        request.timeoutInterval = 5.0
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            let httpResponse = response as! HTTPURLResponse
            
            let statusCode = httpResponse.statusCode
                        
            //let dRes = String(data: data, encoding: .utf8)
            
           // print("dResponse: \(String(describing: dRes))")
            
            if statusCode == Int(200) || statusCode == Int(201) {
                var appArray: [String] = []
                var idArray: [String] = []
                if let responseJSON = responseData as? [String: Any]
                {
                    let dictionary =  responseJSON["data"] as! NSDictionary
                    
                    let dictArray = dictionary["Applications"] as! NSArray
                    
                    for dict in dictArray {
                        if let obj = dict as? [String: Any] {
                            let appType = obj["ApplicationName"] as! String
                            let appID = obj["ApplicationID"] as! String
                            appArray.append(appType)
                            idArray.append(appID)
                        }
                    }
                }
                completionHandler(appArray as NSArray,idArray as NSArray, nil)
            }
            else {
                completionHandler([],[],nil)
            }
        }
        task.resume()
    }
    
    func pairEndPoint(endpointName: String, appID: String,  completionHandler:@escaping pairAPIResults) {
        
        let jsonBody:[String:Any] = [
                "EndpointName": endpointName,
                "ApplicationID": appID
        ]
        
        print("jsonBody: \(jsonBody)")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        
        // create post request
        
        guard let url = URL(string: AdminConstants.AdminUrlConstants.kPairEndpointUrl) else
        {
            return
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let autorization = UserDefaults.standard.string(forKey: "idToken")
                
        request.setValue(autorization, forHTTPHeaderField:"Authorization")
        
        request.httpBody = jsonData
        request.timeoutInterval = 5.0
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            let httpResponse = response as! HTTPURLResponse
            
            let statusCode = httpResponse.statusCode
                        
           // let dRes = String(data: data, encoding: .utf8)
                        
            if statusCode == Int(200) || statusCode == Int(201) {
                
                if let responseJSON = responseData as? [String: Any] {
                    
                    let dictionary =  responseJSON["data"] as! NSDictionary
                    
                    let pwd = dictionary["Password"] as! String
                    let email = dictionary["Email"] as! String
                    let userID = dictionary["UserID"] as! String
                    let endpointID = dictionary["EndpointID"] as! String
                    let appID = dictionary["ApplicationID"] as! String
                    let appName = dictionary["ApplicationName"] as! String
                    let tenantName = dictionary["TenantName"] as! String
                    let tenantId = dictionary["TenantID"] as! String
                    
                    UserDefaults.standard.set(pwd, forKey: "password")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(userID, forKey: "userID")
                    UserDefaults.standard.set(endpointID, forKey: "endpointID")
                    UserDefaults.standard.set(appID, forKey: "appID")
                    UserDefaults.standard.set(appName, forKey: "appName")
                    UserDefaults.standard.set(tenantName, forKey: "tenantName")
                    UserDefaults.standard.set(tenantId, forKey: "tenantID")
                    
                  // let adminUser = AdminUser.init(password: pwd,email: email,userID: userID,endpointID: endpointID,applicationID: appID,applicationName: appName,tenantName: tenantName,tenantId: tenantId)
                    
                    let user = User.init(password: pwd, email: email)
                    let adminUser = AdminUser.init(tenantName: tenantName, tenantId: tenantId, password: pwd, email: email)
                    let endpoint = Endpoint.init(endpointId: endpointID, applicationId: appID, applicationName: appName, password: pwd, email: email)
                    
                    
                    completionHandler(adminUser, endpoint, nil)
                }
            }
            else {
                completionHandler(nil, nil,nil)
            }
        }
        task.resume()
    }
    
    func getAppConfig(completionHandler:@escaping asynAPIResults) {
        
        // create post request
        
        guard let url = URL(string: AdminConstants.AdminUrlConstants.kAppConfigUrl) else
        {
            return
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let autorization = UserDefaults.standard.string(forKey: "idToken")
                
        request.setValue(autorization, forHTTPHeaderField:"Authorization")
        
        request.timeoutInterval = 5.0
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            let httpResponse = response as! HTTPURLResponse
            
            let statusCode = httpResponse.statusCode
            
           // print("header: \(statusCode) response json: \(httpResponse)")
            
            let dRes = String(data: data, encoding: .utf8)
            
           // print("dResponse: \(String(describing: dRes))")
            
            if statusCode == Int(200) || statusCode == Int(201) {
                
                completionHandler("Success",nil)
            
            }
            else {
                completionHandler("Error",nil)
            }
        }
        task.resume()
    }
}

class User: NSObject {
    
    var password: String?
    var email: String?
    
    init(password: String, email: String) {
        self.password = password
        self.email = email
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
}


