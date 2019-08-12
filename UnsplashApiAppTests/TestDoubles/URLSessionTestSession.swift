//
//  URLSessionTestSession.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 08/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation
@testable import UnsplashApiApp

class TestSession: Session {
    private var responses: [ResourceAndResponse]
    
    init(responses: [ResourceAndResponse]) {
        self.responses = responses
    }
    func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        let resourceUrlRequest = resource.apiRequest.urlRequest
        guard let responseIndex = responses.firstIndex(where: { $0.resource.apiRequest.urlRequest == resourceUrlRequest }) else {
            fatalError("No index on responses: \(resource.apiRequest.urlRequest.url)")
        }
        guard let response = responses[responseIndex].response as! A? else {
            fatalError("No such response: \(responses[responseIndex].response)")
        }
        responses.remove(at: responseIndex)
        completion(response)
    }
    
    func verify() -> Bool {
        return responses.isEmpty
    }
}
