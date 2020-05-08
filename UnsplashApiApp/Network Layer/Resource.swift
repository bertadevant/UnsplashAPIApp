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

extension Resource where A: Decodable {
    init(get request: APIRequest) {
        self.apiRequest = request
        self.parse = { data in
            return try? JSONDecoder().decode(A.self, from: data)
        }
    }
}
