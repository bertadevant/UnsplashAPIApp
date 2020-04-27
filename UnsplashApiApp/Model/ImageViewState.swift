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
    let image: UIImage?
    let author: AuthorViewState
    let location: LocationViewState?
    
    init(image: Image, downloadedImage: UIImage) {
        self.id = image.id
        self.colors = Colors(imageColor: UIColor(hexString: image.color))
        self.size = CGSize(width: image.width, height: image.height)
        self.description = image.description
        self.image = downloadedImage
        self.author = AuthorViewState(author: image.user)
        self.location = nil
    }
    
    init(image: ImageFull) {
        self.id = image.id
        self.colors = Colors(imageColor: UIColor(hexString: image.color))
        self.size = CGSize(width: image.width, height: image.height)
        self.description = image.description
        self.image = nil
        self.author = AuthorViewState(author: image.user)
        self.location = LocationViewState(location: image.location)
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

struct LocationViewState {
    let title: String
    let longitud: Double
    let latitud: Double
    
    init?(location: Location) {
        guard let latitud = location.position.latitude, let longitud = location.position.longitude else { return nil }
        self.title = location.title ?? ""
        self.latitud = latitud
        self.longitud = longitud
    }
}
