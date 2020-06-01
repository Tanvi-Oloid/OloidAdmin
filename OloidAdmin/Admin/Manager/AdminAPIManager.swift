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
   // typealias pairAPIResults = (_ adminUserRes:AdminUser?, _ endpointRes: Endpoint?,_ error:NSError?) -> Void
    
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
    
    func pairEndPoint(endpointName: String, appID: String,  completionHandler:@escaping asynAPIResults) {
        
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
                    
                    let defaults = UserDefaults.standard
                    
                    let user = User.init(password: pwd, email: email)
                    
                    do {
                        let userData = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
                        defaults.set(userData, forKey: "user")
                    } catch {
                        print("Couldn't write file")
                    }
                    
                    
                    let adminUser = AdminUser.init(tenantName: tenantName, tenantId: tenantId, password: pwd, email: email)
                    
                    do {
                        let adminData = try NSKeyedArchiver.archivedData(withRootObject: adminUser, requiringSecureCoding: false)
                        defaults.set(adminData, forKey: "adminUser")
                    } catch {
                        print("Couldn't write file")
                    }
                    
                    let endpoint = Endpoint.init(endpointId: endpointID, applicationId: appID, applicationName: appName, password: pwd, email: email)
                    
                    do {
                        let endpointData = try NSKeyedArchiver.archivedData(withRootObject: endpoint, requiringSecureCoding: false)
                        defaults.set(endpointData, forKey: "endpoint")
                    } catch {
                        print("Couldn't write file")
                    }
                    
                    completionHandler("Success", nil)
                }
            }
            else {
                completionHandler("Error", nil)
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