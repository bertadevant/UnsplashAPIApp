//
//  APIRequestTests.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 11/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import XCTest
@testable import UnsplashApiApp

class APIRequestTests: XCTestCase {

    func testURLRequestIsCorrectForCuratedSearchType() {
        let searchParameters = SearchParameters.testData(searchType: .curated)
        let apiRequest = ImageAPIRequest(search: searchParameters)
        XCTAssertEqual(apiRequest.urlRequest.url?.description, "https://api.unsplash.com/curated?page=0")
    }
    
    func testURLRequestIsCorrectForQuery() {
        let searchParameters = SearchParameters.testData(query: "office")
        let apiRequest = ImageAPIRequest(search: searchParameters)
        XCTAssertEqual(apiRequest.urlRequest.url?.description, "https://api.unsplash.com/curated?query=office&page=0")
    }
    
    func testURLRquestIsCorrectForPage() {
        let searchParameters = SearchParameters.testData(pagination: Pagination.testData(page: 5))
        let apiRequest = ImageAPIRequest(search: searchParameters)
        XCTAssertEqual(apiRequest.urlRequest.url?.description, "https://api.unsplash.com/curated?page=5")
    }

}
