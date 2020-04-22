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
        let apiRequest = APIRequest.imageRequest(searchParameters: searchParameters)
        XCTAssertEqual(apiRequest.components.url?.description, "https://api.unsplash.com/photos/curated?page=1")
    }
    
    func testURLRequestIsCorrectForQuery() {
        let searchParameters = SearchParameters.testData(query: "office")
        let apiRequest = APIRequest.imageRequest(searchParameters: searchParameters)
        XCTAssertEqual(apiRequest.components.url?.description, "https://api.unsplash.com/photos/curated?page=1&query=office")
    }
    
    func testURLRquestIsCorrectForPage() {
        let searchParameters = SearchParameters.testData(page: 5)
        let apiRequest = APIRequest.imageRequest(searchParameters: searchParameters)
        XCTAssertEqual(apiRequest.components.url?.description, "https://api.unsplash.com/photos/curated?page=5")
    }
    
    func testURLRequestIsCorrectForLoading() {
        
    }
    
    func testURLRequestIsCorrectForDownloading() {
        
    }

}
