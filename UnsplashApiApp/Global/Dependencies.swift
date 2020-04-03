//
//  Dependencies.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 08/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

struct Dependencies {
    var session: Session = NetworkSession()
    // FIXME: Extract this in some local-only config file to avoid commiting this to GitHub
    var apiKey: String = "40c9db0853526d8cf7d3338a9b6a14722de5ae8adb7efb83e5ea7954d4809dce"

    static var enviroment = Dependencies()
}
