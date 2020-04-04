//
//  APIRequest.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 07/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

private func makeUnsplashComponent(path: String, queryItems: [URLQueryItem] = []) -> URLComponents {
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

final class ImageAPIRequest: APIRequest {
    let searchParameters: SearchParameters

    var components: URLComponents {
        var queryItems: [URLQueryItem] = []
        let page: String = searchParameters.page == 0 ? "1" : searchParameters.page.description
        queryItems.append(URLQueryItem(name: "page", value: page))
        if !searchParameters.query.isEmpty {
            queryItems.append(URLQueryItem(name: "query", value: searchParameters.query))
        }
        return makeUnsplashComponent(path: searchParameters.searchType.rawValue, queryItems: queryItems)
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
        self.components = makeUnsplashComponent(path: "/photos/\(imageID)/download")
    }
}

//Each Image parsed from the API comes with the urls for downloading the images, we use this request to get the proper URL for downloading for each image
final class LoadAPIRequest: APIRequest {
    let components: URLComponents

    init(imageURL: String) {
        var components = URLComponents(string: imageURL)
        components?.queryItems = []
        self.components = components ?? URLComponents()
    }
}
