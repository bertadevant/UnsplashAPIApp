//
//  UIColorExtensionsTests.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 15/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import XCTest
@testable import UnsplashApiApp

//TODO: Test this better
class UIColorExtensionsTests: XCTestCase {

    func testIsLIghtReturnsTrueWhenLightColor() {
        let image = Image.testData(color: "#d68787")
        let viewState = ImageViewState.testData(image: image)
        XCTAssertTrue(UIColor(hexString: "#d68787")!.isLight())
        XCTAssertTrue(viewState.colors.textColor == UIColor.gray)
    }
    
    func testIsLIghtReturnsFalseWhenDarkColor() {
        let image = Image.testData(color: "#040124")
        let viewState = ImageViewState.testData(image: image)
        XCTAssertFalse(UIColor(hexString: "#040124")!.isLight())
        XCTAssertTrue(viewState.colors.textColor == UIColor.white)
    }
}
