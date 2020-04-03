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
    
    func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        print("👾 resource URL \(resource.apiRequest.urlRequest.url?.absoluteString ?? "nil")")
        urlSession.dataTask(with: resource.apiRequest.urlRequest) { data, _, error in
            if let error = error {
                print("error while fetching data \(error)")
                completion(nil)
            }
            completion(data.flatMap(resource.parse))
        }.resume()
    }
    
    func download<A>(_ resource: Resource<A>, completion: @escaping (Data?, Error?) -> ()) {
        urlSession.dataTask(with: resource.apiRequest.urlRequest) { data, _, error in
            if let error = error {
                print("error while fetching data \(error)")
                completion(nil, error)
            }
            completion(data, nil)
        }.resume()
    }
}
