//
//  Resource.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 07/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

struct Resource<A> {
    var apiRequest: APIRequest
    let parse: (Data) -> A?
}

extension Resource {
    func map<B>(_ transform: @escaping (A) -> B) -> Resource<B> {
        return Resource<B>(apiRequest: apiRequest) { self.parse($0).map(transform) }
    }
}

extension Resource where A: Decodable {
    init(get request: APIRequest) {
        self.apiRequest = request
        self.parse = { data in
            do {
                return try JSONDecoder().decode(A.self, from: data)
            } catch (let error) {
                print("👾 error while decoding data \(error)")
                return nil
            }
        }
    }
}
