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
                         description: String? = nil,
                         urls: ImageURL = ImageURL.testData(),
                         user: Author = Author.testData()) -> Image {
        return Image(id: id, color: color, width: width, height: height, description: description, urls: urls, user: user)
    }
}

extension ImageURL {
    static func testData(small: String = "https://www.google.com/",
                         regular: String = "https://www.google.com/",
                         full: String = "https://www.google.com/") -> ImageURL {
        return ImageURL(small: small, regular: regular, full: full)
    }
}

extension Author {
    static func testData(id: String = "",
                         name: String = "") -> Author {
        return Author(id: id, name: name)
    }
}
