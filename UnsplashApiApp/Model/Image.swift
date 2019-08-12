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
    let urls: ImageURL
}

struct ImageURL: Codable, Equatable {
    let small: String
    let full: String
}

struct Pagination: Codable {
    let total_pages: Int
    let total: Int
    let results: ImageList
}

typealias ImageList = [Image]
