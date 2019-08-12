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
                         pagination: Pagination = Pagination.testData()) -> SearchParameters {
        return SearchParameters(searchType: searchType,
                                query: query,
                                pagination: pagination)
    }
}

extension Pagination {
    static func testData(page: Int = 0,
                         per_page: Int = 0,
                         order_by: String = "",
                         images: ImageList = []) -> Pagination {
        return Pagination(page: page,
                          per_page: per_page,
                          order_by: order_by,
                          images: images)
    }
}
