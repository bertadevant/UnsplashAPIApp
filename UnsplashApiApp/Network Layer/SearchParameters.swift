//
//  SearchParameters.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 19/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

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
    case download = "/photos"
}
