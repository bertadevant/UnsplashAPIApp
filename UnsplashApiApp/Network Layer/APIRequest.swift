//
//  APIRequest.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 07/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

struct APIRequest {
    let components: URLComponents
    let authorizationKey: String = Constants.apiAccessKey
    var urlRequest: URLRequest {
        guard let urlString = components.url?.absoluteString.removingPercentEncoding,
            let url = URL(string: urlString) else {
                preconditionFailure("We should have a valid URL \(components.url?.absoluteString.removingPercentEncoding ?? "nil")")
        }
        var request = URLRequest(url: url)
        request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")
        return request
    }
}

extension APIRequest: Equatable {
    static func == (lhs: APIRequest, rhs: APIRequest) -> Bool {
        return lhs.authorizationKey == rhs.authorizationKey &&
            lhs.components == rhs.components &&
            lhs.urlRequest.url?.absoluteString == rhs.urlRequest.url?.absoluteString
    }
}

extension APIRequest {
    static func imageRequest(searchParameters: SearchParameters) -> APIRequest {
        var queryItems: [URLQueryItem] = []
        let page: String = searchParameters.page == 0 ? "1" : searchParameters.page.description
        queryItems.append(URLQueryItem(name: "page", value: page))
        if !searchParameters.query.isEmpty {
            queryItems.append(URLQueryItem(name: "query", value: searchParameters.query))
        }
        let components = unsplashComponent(path: searchParameters.searchType.rawValue, queryItems: queryItems)
        return APIRequest(components: components)
    }
    
    //Unsplash API demands that we trigger a download count when downloading a picture, this request is created to handle that
    // https://unsplash.com/documentation#track-a-photo-download
    static func downloadRequest(imageID: String) -> APIRequest {
        let components = unsplashComponent(path: "/photos/\(imageID)/download")
        return APIRequest(components: components)
    }
    
    //Each Image parsed from the API comes with the urls for downloading the images, we use this request to get the proper URL for downloading for each image
    static func loadRequest(imageURL: String) -> APIRequest {
        let components = URLComponents(string: imageURL) ?? URLComponents()
        return APIRequest(components: components)
    }
}

private func unsplashComponent(path: String, queryItems: [URLQueryItem] = []) -> URLComponents {
    var component = URLComponents()
    component.scheme = "https"
    component.host = "api.unsplash.com"
    component.path = path
    component.queryItems = queryItems
    return component
}
