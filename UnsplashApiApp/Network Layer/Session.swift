//
//  URLSessionExtension+Load.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 07/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

typealias Completion<A> = (Result<A,Error>) -> Void
protocol Session {
    func load<A>(_ resource: Resource<A>, completion: @escaping Completion<A>)
    func download<A>(_ resource: Resource<A>, completion: @escaping Completion<Data>)
    func cancel(_ request: URLRequest)
}

enum FetchError: String, Error {
    case noResponseFound = "There was no response from the server"
    case parsedFailed = "There was an error while parsing the objects"
}

class NetworkSession: Session {
    private let completionQueue: DispatchQueue
    
    init(completionQueue: DispatchQueue = DispatchQueue.main) {
        self.completionQueue = completionQueue
    }
    
    func load<A>(_ resource: Resource<A>, completion: @escaping Completion<A>) {
        let request = resource.apiRequest.urlRequest
        print("👾 resource URL \(request.url?.absoluteString ?? "nil")")
        Fetcher(request: request).get() { data, error in
            guard let data = data else {
                self.completionQueue.async { completion(.failure(FetchError.noResponseFound)) }
                return
            }
            guard let parseData = resource.parse(data) else {
                return
            }
            self.completionQueue.async { completion(.success(parseData)) }
        }
    }
    
    func download<A>(_ resource: Resource<A>, completion: @escaping Completion<Data>) {
        let request = resource.apiRequest.urlRequest
        Fetcher(request: request).get(){ data, error in
            guard let data = data else {
                self.completionQueue.async { completion(.failure(FetchError.noResponseFound)) }
                return
            }
            self.completionQueue.async { completion(.success(data))}
        }
    }
    
    func cancel(_ request: URLRequest) {
        Fetcher(request: request).cancel()
    }
}
