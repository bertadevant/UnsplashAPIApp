//
//  URLSessionTestSession.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 08/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation
@testable import UnsplashApiApp

class SessionSpy: Session, TestSpy {
    enum Method {
        case load
        case download
    }

    private var buildURLRequest: (APIRequest) -> URLRequest = NetworkSession(apiKey: "testkey").urlRequest(from:)
    var recordedMethods: [SessionSpy.Method] = []
    var recordedParameters: [AnyHashable] = []

    func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        record(.load)
        if let params = resource.apiRequest.components.queryItems {
          recordParameters(params)
        }
    }
    
    func download<A>(_ resource: Resource<A>, completion: @escaping (Data?, Error?) -> ()) {
        record(.download)
        if let params = resource.apiRequest.components.queryItems {
          recordParameters(params)
        }
    }
}
