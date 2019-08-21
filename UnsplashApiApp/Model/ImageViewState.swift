//
//  ImageViewState.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit

struct ImageViewState {
    let id: String
    let colors: Colors
    let size: CGSize
    let description: String?
    let imageSmall: String
    let imageRegular: String
    let imageFull: String
    let author: AuthorViewState
}

extension Image {
    func viewState() -> ImageViewState {
        return ImageViewState(id: self.id,
                              colors: Colors(imageColor: UIColor(hexString: self.color)),
                              size: CGSize(width: self.width, height: self.height),
                              description: self.description,
                              imageSmall: self.urls.small,
                              imageRegular: self.urls.regular,
                              imageFull: self.urls.full,
                              author: self.user.viewModel())
    }
}

struct Colors {
    let imageColor: UIColor
    let textColor: UIColor
    let containerColor: UIColor
}

extension Colors {
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

extension Author {
    func viewModel() -> AuthorViewState {
        return AuthorViewState(name: self.name)
    }
}
