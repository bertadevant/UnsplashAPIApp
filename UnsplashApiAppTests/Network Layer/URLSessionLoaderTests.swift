//
//  UnsplashApiAppTests.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 07/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import XCTest
@testable import UnsplashApiApp

class URLSessionLoaderTests: XCTestCase {

    func testEmptyAPICall() {
        let components = URLComponents(string: "https://api.unsplash.com/curated?page=0")!
        let request = APIRequestStub(queryItems: [], testComponents: components)
        let images = Resource<ImageList>(get: request)
        let testSession =  TestSession(responses: [
            ResourceAndResponse(images, response: [Image.testData()])
            ])
        let testDependencies = Dependencies(session: testSession)
        Dependencies.dependencies = testDependencies
        ImageModel().fetchImageList(search: SearchParameters.testData()) { imageList in
            XCTAssertNotNil(imageList)
        }
        XCTAssertTrue(testSession.verify())
    }

}
