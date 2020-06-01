//
//  WebService.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 21/05/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import Foundation

class WebService {
    
    /**
     Method to load API request to receive data from server. It is using generic type to parse the response as per the request received from requesting Model.

     - Parameters:
        - request: Request type with Generic type.
        - completion: closer to handle the response.
     */
    func load<T>(request: Request<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {

        let urlRequest = self.getURLRequest(from: request)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            // check for error
            guard let data = data, error == nil else {
                completion(.failure(.networkError))
                return
            }

            // check for response code
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                completion(.failure(.serviceError))
                return
            }

            // decode the JSON data into received Model
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                completion(.success(result))
            } else {
                fatalError("JSON decoding failed for server response.")
                //                    completion(.failure(.decodingError))
            }
        }.resume()
    }
}

extension WebService {
    /**
     Private method to convert Request<T> to URLRequest so that API request can for the information from server.

     - Parameter request: Request<T> type with request request information
     */
    private func getURLRequest<T>(from request: Request<T>) -> URLRequest {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.body
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let headerFields = request.headerField {
//            
//            for key in headerFields.allKeys {
//                urlRequest.addValue(headerFields[key], forHTTPHeaderField: key)
//                //if key == ""
//            }
//        }
        return urlRequest
    }
}

