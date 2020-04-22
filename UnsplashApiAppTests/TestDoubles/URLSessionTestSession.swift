//
//  URLSessionTestSession.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 08/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation
@testable import UnsplashApiApp

class URLSessionSpy: URLSession, Session, TestSpy {
    enum Method {
        case load
        case download
    }
    
    var recordedMethods: [URLSessionSpy.Method] = []
    var recordedParameters: [AnyHashable] = []

    func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        record(.load)
        if let urlString = resource.apiRequest.components.url?.absoluteString {
          recordParameters(urlString)
        }
    }
    
    func download<A>(_ resource: Resource<A>, completion: @escaping (Data?, Error?) -> ()) {
        record(.download)
        if let urlString = resource.apiRequest.components.url?.absoluteString {
          recordParameters(urlString)
        }
    }
}
