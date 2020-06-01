//
//  ServerPath.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 21/05/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import Foundation

enum ServerPath {
    //Web API base URL
    static private let baseURL:URL = URL(string:"https://v2abf3htv3.execute-api.us-east-2.amazonaws.com/dev/")!
    
    // Cases to define specific service path
    case login
    case listApplications
    case pairEndpoint
    
}

extension ServerPath {
    // Return URL as per the case
    var url: URL {
        switch self {
        case .login:
            return ServerPath.baseURL.appendingPathComponent("login")
            
        case .listApplications:
            return ServerPath.baseURL.appendingPathComponent("applications")
            
        case .pairEndpoint:
            return ServerPath.baseURL.appendingPathComponent("endpoint/pair")
        }
        
    }
}
