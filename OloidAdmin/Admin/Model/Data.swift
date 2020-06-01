//
//  Data.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 22/05/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import Foundation

struct ResultData: Decodable {
    let data: String
}

struct LoginToken: Decodable {

    let idToken: String
}

struct AppListArray: Decodable {
    let listArray: [String]
}
