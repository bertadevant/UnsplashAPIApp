//
//  ImageFull.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 27/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import Foundation

struct ImageFull: Codable, Equatable {
    let id: String
    let description: String?
    let urls: ImageURL
    let color: String
    let width: Int
    let height: Int
    let location: Location
    let user: Author
}

struct Location: Codable, Equatable {
    let title: String?
    let name: String?
    let city: String?
    let country: String?
    let position: Position
}


struct Position: Codable, Equatable {
    let latitude: Double?
    let longitude: Double?
}
