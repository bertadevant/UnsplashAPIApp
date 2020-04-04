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
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func urlRequest(from apiRequest: APIRequest) -> URLRequest {
        guard let url = apiRequest.components.url else {
            preconditionFailure("We should have a valid URL \(apiRequest.components.url?.absoluteString ?? "nil")")
        }
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(self.apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        let urlReq = urlRequest(from: resource.apiRequest)
        print("👾 resource URL \(urlReq.url?.absoluteString ?? "nil")")
        urlSession.dataTask(with: urlReq) { data, _, error in
            if let error = error {
                print("error while fetching data \(error)")
                completion(nil)
            }
            completion(data.flatMap(resource.parse))
        }.resume()
    }
    
    func download<A>(_ resource: Resource<A>, completion: @escaping (Data?, Error?) -> ()) {
        urlSession.dataTask(with: urlRequest(from: resource.apiRequest)) { data, _, error in
            if let error = error {
                print("error while fetching data \(error)")
                completion(nil, error)
            }
            completion(data, nil)
        }.resume()
    }
}
