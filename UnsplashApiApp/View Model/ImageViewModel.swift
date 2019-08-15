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
    let colors: Colors
    let size: CGSize
    let description: String?
    let imageSmall: URL
    let imageRegular: URL
    let actions: [Actions]?
    let author: AuthorViewModel
}

extension ImageViewModel {
    init?(image: Image, actions: [Actions]?) {
        guard let imageRegular = URL(string: image.urls.regular),
            let imageSmall = URL(string: image.urls.small) else {
                return nil
        }
        self.id = image.id
        self.colors = Colors(imageColor: UIColor(hexString: image.color))
        self.size = CGSize(width: image.width, height: image.height)
        self.description = image.description
        self.imageRegular = imageRegular
        self.imageSmall = imageSmall
        self.actions = actions
        self.author = image.user.viewModel()
    }
}

struct Colors {
    let imageColor: UIColor
    let textColor: UIColor
}

extension Colors {
    init(imageColor: UIColor?) {
        guard let imageColor = imageColor else {
            self.imageColor = .white
            self.textColor = .gray
            return
        }
        self.imageColor = imageColor
        self.textColor = imageColor.isLight() ? .gray : .white
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
