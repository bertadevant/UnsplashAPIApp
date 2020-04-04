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

    // You can't base your unit test on comparing URLs because the order in query parameters order is generally irrelevant
    // So both "api.foo.com?a=1&b=2" and "api.foo.com?a=2&b=1" are the same resource despite their URL not being equal
    private func assertComponents(_ urlComps: URLComponents, path: String, queryItems: KeyValuePairs<String, String?>,
                                  file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(urlComps.scheme, "https", file: file, line: line)
        XCTAssertEqual(urlComps.host, "api.unsplash.com", file: file, line: line)
        XCTAssertEqual(urlComps.path, path, file: file, line: line)

        let expectedItems: [URLQueryItem]? = queryItems.map(URLQueryItem.init)
        XCTAssertEqual(urlComps.queryItems.map(Set.init), expectedItems.map(Set.init), file: file, line: line)
    }

    func testURLRequestIsCorrectForCuratedSearchType() {
        let searchParameters = SearchParameters.testData(searchType: .curated)
        let apiRequest = ImageAPIRequest(search: searchParameters)
        assertComponents(apiRequest.components, path: "/curated", queryItems: ["page": "0"])
    }
    
    func testURLRequestIsCorrectForQuery() {
        let searchParameters = SearchParameters.testData(query: "office")
        let apiRequest = ImageAPIRequest(search: searchParameters)
        assertComponents(apiRequest.components, path: "/curated", queryItems: ["query": "office", "page": "0"])
    }
    
    func testURLRquestIsCorrectForPage() {
        let searchParameters = SearchParameters.testData(page: 5)
        let apiRequest = ImageAPIRequest(search: searchParameters)
        assertComponents(apiRequest.components, path: "/curated", queryItems: ["page": "5"])
    }
    
    func testURLRequestIsCorrectForLoading() {
        
    }
    
    func testURLRequestIsCorrectForDownloading() {
        
    }

}
