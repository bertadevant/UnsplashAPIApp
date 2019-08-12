//
//  ImageAndResponseTestData.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 08/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation
@testable import UnsplashApiApp

struct ResourceAndResponse {
    let resource: Resource<Any>
    let response: Any?
    init<A>(_ resource: Resource<A>, response: A?) {
        //map here does not transfrom anything it tells compiler this can go to ANY
        self.resource = resource.map { $0 }
        self.response = response.map { $0 }
    }
}
