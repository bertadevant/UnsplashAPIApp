//
//  Image.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 07/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

struct Image: Codable, Equatable {
    let id: String
    let color: String
    let width: Int
    let height: Int
    let description: String?
    let urls: ImageURL
    let user: Author
}

struct ImageURL: Codable, Equatable {
    let small: String
    let regular: String
}

struct Author: Codable, Equatable {
    let id: String
    let name: String
//    let profile_image: ImageURL
}

struct Pagination: Codable {
    let total_pages: Int
    let total: Int
    let results: ImageList
}

typealias ImageList = [Image]
