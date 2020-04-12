//
//  ImageViewState+TestData.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 12/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import UIKit
@testable import UnsplashApiApp

extension ImageViewState {
    static func testData(image: Image = Image.testData()) -> ImageViewState {
        return ImageViewState(image: image, downloadedImage: UIImage())
    }
}
