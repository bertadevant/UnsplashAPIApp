//
//  ImageViewState.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit

struct ImageViewState {
    struct Colors {
        let imageColor: UIColor
        let textColor: UIColor
        let containerColor: UIColor
    }

    let id: String
    let colors: Colors
    let size: CGSize
    let description: String?
    let imageSmall: String
    let imageRegular: String
    let imageFull: String
    let author: AuthorViewState
}

extension ImageViewState {
    init(image: Image) {
        self.init(
            id: image.id,
            colors: .init(imageColor: UIColor(hexString: image.color)),
            size: CGSize(width: image.width, height: image.height),
            description: image.description,
            imageSmall: image.urls.small,
            imageRegular: image.urls.regular,
            imageFull: image.urls.full,
            author: .init(author: image.user)
        )
    }
}


extension ImageViewState.Colors {
    init(imageColor: UIColor?) {
        guard let imageColor = imageColor else {
            self.imageColor = .white
            self.textColor = .gray
            self.containerColor = .white
            return
        }
        self.imageColor = imageColor
        self.textColor = imageColor.isLight() ? .gray : .white
        self.containerColor = imageColor.isLight() ? .white : .gray
    }
}

struct AuthorViewState {
    let name: String
}

extension AuthorViewState {
    init(author: Author) {
        self.init(name: author.name)
    }
}
