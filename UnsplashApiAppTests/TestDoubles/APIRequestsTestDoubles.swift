import Foundation
@testable import UnsplashApiApp

final class APIRequestDummy: APIRequest {
    var components: URLComponents {
        return URLComponents()
    }
    var queryItems: [URLQueryItem] = []
}

final class APIRequestStub: APIRequest {
    var components: URLComponents {
        return testComponents
    }
    var queryItems: [URLQueryItem]  {
        return testablequeryItems
    }
    
    let testComponents: URLComponents
    let testablequeryItems: [URLQueryItem]
    
    init(queryItems: [URLQueryItem] = [],
         testComponents: URLComponents) {
        self.testablequeryItems = queryItems
        self.testComponents = testComponents
    }
}
