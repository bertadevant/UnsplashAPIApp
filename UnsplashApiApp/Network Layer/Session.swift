//
//  URLSessionExtension+Load.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 07/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

protocol Session {
    func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ())
    func download<A>(_ resource: Resource<A>, completion: @escaping (Data?, Error?) -> ())
}

class NetworkSession: Session {
    private let urlSession: URLSession = .shared
    private let authorizationKey: String
    
    init(apiKey: String) {
        self.authorizationKey = apiKey
    }
    
    func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        let request = urlRequest(apiRequest: resource.apiRequest)
        print("👾 resource URL \(request.url?.absoluteString ?? "nil")")
        urlSession.dataTask(with: request) { data, _, error in
            if let error = error {
                print("error while fetching data \(error)")
                completion(nil)
            }
            completion(data.flatMap(resource.parse))
        }.resume()
    }
    
    func download<A>(_ resource: Resource<A>, completion: @escaping (Data?, Error?) -> ()) {
        let request = urlRequest(apiRequest: resource.apiRequest)
        urlSession.dataTask(with: request) { data, _, error in
            if let error = error {
                print("error while fetching data \(error)")
                completion(nil, error)
            }
            completion(data, nil)
        }.resume()
    }
    
    private func urlRequest(apiRequest: APIRequest) -> URLRequest {
        guard let urlString = apiRequest.components.url?.absoluteString.removingPercentEncoding,
            let url = URL(string: urlString) else {
                preconditionFailure("We should have a valid URL \(apiRequest.components.url?.absoluteString.removingPercentEncoding ?? "nil"))")
        }
        var request = URLRequest(url: url)
        request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")
        return request
    }
}
