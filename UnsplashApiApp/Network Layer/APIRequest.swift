//
//  APIRequest.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 07/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

private func unsplashComponent(path: String, queryItems: [URLQueryItem] = []) -> URLComponents {
    var component = URLComponents()
    component.scheme = "https"
    component.host = "api.unsplash.com"
    component.path = path
    component.queryItems = queryItems
    return component
}

protocol APIRequest {
    var components: URLComponents { get }
}

extension APIRequest {
    var urlRequest: URLRequest {
        guard let urlString = components.url?.absoluteString.removingPercentEncoding,
            let url = URL(string: urlString) else {
                preconditionFailure("We should have a valid URL \(String(describing: components.url?.absoluteString.removingPercentEncoding ?? nil))")
        }
        var request = URLRequest(url: url)
        request.setValue(Constants.apiAccessKey, forHTTPHeaderField: "Authorization")
        return request
    }
}

final class ImageAPIRequest: APIRequest {
    let searchParameters: SearchParameters
    
    var components: URLComponents {
        var queryItems: [URLQueryItem] = []
        let page: String = searchParameters.page == 0 ? "1" : searchParameters.page.description
        queryItems.append(URLQueryItem(name: "page", value: page))
        if !searchParameters.query.isEmpty {
            queryItems.append(URLQueryItem(name: "query", value: searchParameters.query))
        }
        return unsplashComponent(path: searchParameters.searchType.rawValue, queryItems: queryItems)
    }
    
    init(search: SearchParameters) {
        self.searchParameters = search
    }
}

//Unsplash API demands that we trigger a download count when downloading a picture, this request is created to handle that
// https://unsplash.com/documentation#track-a-photo-download
final class DownloadAPIRequest: APIRequest {
    let components: URLComponents
    
    init(imageID: String) {
        self.components = unsplashComponent(path: "/photos/\(imageID)/download")
    }
}

//Each Image parsed from the API comes with the urls for downloading the images, we use this request to get the proper URL for downloading for each image
final class LoadAPIRequest: APIRequest {
    let components: URLComponents
    
    init(imageURL: String) {
        self.components = URLComponents(string: imageURL) ?? URLComponents()
    }
}
