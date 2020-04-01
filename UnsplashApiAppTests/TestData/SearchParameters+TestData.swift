//
//  SearchParameters+TestData.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 11/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//
import Foundation
@testable import UnsplashApiApp

extension SearchParameters {
    static func testData(searchType: SearchType = .curated,
                         query: String = "",
                         page: Int = 0) -> SearchParameters {
        return SearchParameters(searchType: searchType,
                                query: query,
                                page: page)
    }
}
