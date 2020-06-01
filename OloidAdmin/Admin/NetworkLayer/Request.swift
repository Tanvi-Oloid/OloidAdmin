//
//  Request.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 21/05/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case serviceError
    case networkError
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

struct Request<T: Decodable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
    var headerFields: Dictionary = [String: String]()
}

extension Request {
    init(url: URL) {
        self.url = url
    }
}
