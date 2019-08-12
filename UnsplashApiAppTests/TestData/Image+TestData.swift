//
//  Image+TestData.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 08/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation
@testable import UnsplashApiApp

extension Image {
    static func testData(id: String = "",
                         color: String = "",
                         width: Int = 0,
                         height: Int = 0,
                         urls: ImageURL = ImageURL.testData()) -> Image {
        return Image(id: id, color: color, width: width, height: height, urls: urls)
    }
}

extension ImageURL {
    static func testData(small: String = "",
                         thumb: String = "") -> ImageURL {
        return ImageURL(small: small, thumb: thumb)
    }
}
