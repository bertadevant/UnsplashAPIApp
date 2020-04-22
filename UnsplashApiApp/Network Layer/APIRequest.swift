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
