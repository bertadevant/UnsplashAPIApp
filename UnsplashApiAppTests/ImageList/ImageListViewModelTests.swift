//
//  ImageListViewModelTests.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 30/03/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//
import XCTest
@testable import UnsplashApiApp

class ImageListViewModelTests: XCTestCase {
    
    func testFetchCorrectlyOnDelegate() {
        let firstPage = SearchParameters.testData(searchType: .curated, query: "Barcelona", page: 1)
        let secondPage = SearchParameters.testData(searchType: .curated, query: "Barcelona", page: 2)
        fetchForSearch(search: firstPage)
        fetchForSearch(search: secondPage)
    }
    
    private func fetchForSearch(search: SearchParameters, file: StaticString = #file, line: UInt = #line) {
        let session = URLSessionSpy()
        Dependencies.enviroment.mainSession = session
        let delegate = ImageListViewModelDelegateSpy()
        let viewModel = ImageListViewModel()
        let urlString = APIRequest.imageRequest(searchParameters: search).components.url?.absoluteString
        
        viewModel.delegate = delegate
        viewModel.fetchNewQuery(search)
        
        session.assertEqual(.load)
        session.assertParameterEqual(urlString!)
    }
}
