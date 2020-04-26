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
    let image: UIImage
    let author: AuthorViewState
    
    init(image: Image, downloadedImage: UIImage) {
        self.id = image.id
        self.colors = Colors(imageColor: UIColor(hexString: image.color))
        self.size = CGSize(width: image.width, height: image.height)
        self.description = image.description
        self.image = downloadedImage
        self.author = AuthorViewState(author: image.user)
    }
}

extension ImageViewState {
    struct Colors {
        let imageColor: UIColor
        let textColor: UIColor
        let containerColor: UIColor
        
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
}

struct AuthorViewState {
    let name: String
    
    init(author: Author) {
        self.name = author.name
    }
}
