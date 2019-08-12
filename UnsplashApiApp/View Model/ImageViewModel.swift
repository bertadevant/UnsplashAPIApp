//
//  ImageViewState.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit

struct ImageViewModel {
    let id: String
    let color: UIColor?
    let size: CGSize
    let description: String?
    let imageSmall: URL
    let imageFull: URL
}

extension ImageViewModel {
    init?(image: Image) {
        guard let imageFull = URL(string: image.urls.full),
            let imageSmall = URL(string: image.urls.small) else {
                return nil
        }
        self.id = image.id
        self.color = UIColor(hexString: image.color)
        self.size = CGSize(width: image.width, height: image.height)
        self.description = image.description
        self.imageFull = imageFull
        self.imageSmall = imageSmall
    }
}

