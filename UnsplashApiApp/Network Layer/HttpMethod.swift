//
//  HttpMethod.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 07/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

enum HttpMethod<Body> {
    case get
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        }
    }
}
