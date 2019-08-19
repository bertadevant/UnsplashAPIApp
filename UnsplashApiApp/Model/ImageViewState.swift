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
    let actions: [Actions]?
    let author: AuthorViewModel
}

extension ImageViewState {
    init(image: Image, actions: [Actions]?) {
        self.id = image.id
        self.colors = Colors(imageColor: UIColor(hexString: image.color))
        self.size = CGSize(width: image.width, height: image.height)
        self.description = image.description
        self.imageRegular = image.urls.regular
        self.imageSmall = image.urls.small
        self.imageFull = image.urls.full
        self.actions = actions
        self.author = image.user.viewModel()
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

struct Actions {
    let type: ActionType
    let name: String
    let handler: () -> Void
}

enum ActionType {
    case button
    case userInteraction
}

struct AuthorViewModel {
    let name: String
}

extension Author {
    func viewModel() -> AuthorViewModel {
        return AuthorViewModel(name: self.name)
    }
}
