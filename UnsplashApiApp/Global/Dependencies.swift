//
//  Dependencies.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 08/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

struct Dependencies {
    var mainSession: Session
    static var enviroment = Dependencies()
    
    init(session: Session = NetworkSession()) {
        self.mainSession = session
    }
}
