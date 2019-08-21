//
//  SearchCategory.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 20/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

struct SearchCategory {
    let name: String
    let query: String
}

extension SearchCategory {
    static var barcelona = SearchCategory(name: "Barcelona", query: "barcelona")
    static var wallpaper = SearchCategory(name: "Wallpaper", query: "wallpaper")
    static var architecture = SearchCategory(name: "Architecture", query: "architecture")
    static var experimental = SearchCategory(name: "Experimental", query: "experimental")
    static var textures = SearchCategory(name: "Textures & Patterns", query: "textures-patterns")
}
