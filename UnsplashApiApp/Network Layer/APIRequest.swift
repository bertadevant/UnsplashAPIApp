//
//  APIRequest.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 07/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

protocol APIRequest {
    var components: URLComponents { get }
    var queryItems: [URLQueryItem] { get }
    var urlRequest: URLRequest { get }
}

extension APIRequest {
    var urlRequest: URLRequest {
        guard let urlString = components.url?.absoluteString.removingPercentEncoding,
            let url = URL(string: urlString) else {
                preconditionFailure("We should have a valid URL \(components.url?.absoluteString.removingPercentEncoding)")
        }
        var request = URLRequest(url: url)
        request.setValue(accessKey, forHTTPHeaderField: "Authorization")
        return request
    }
}

private extension APIRequest {
    var accessKey: String {
        return "Client-ID 40c9db0853526d8cf7d3338a9b6a14722de5ae8adb7efb83e5ea7954d4809dce"
    }
}

final class ImageAPIRequest: APIRequest {
    
    let searchParameters: SearchParameters
    
    init(search: SearchParameters) {
        self.searchParameters = search
    }
    
    var queryItems: [URLQueryItem] {
        return setQueryItems()
    }
    
    var components: URLComponents {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.unsplash.com"
        component.path = searchParameters.searchType.rawValue
        component.queryItems = self.queryItems
        return component
    }
    
    private func setQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        let page: String = searchParameters.page == 0 ? "1" : searchParameters.page.description
        queryItems.append(URLQueryItem(name: "page", value: page))
        if !searchParameters.query.isEmpty {
            queryItems.append(URLQueryItem(name: "query", value: searchParameters.query))
        }
        return queryItems
    }
}

struct SearchParameters {
    let searchType: SearchType
    let query: String
    let page: Int
}


enum SearchType: String {
    case curated = "/photos/curated"
    case random = "random"
    case photos = "/search/photos"
    case collections = "collections"
}
