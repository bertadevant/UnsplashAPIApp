//
//  Dependencies.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 08/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

struct Dependencies {
    let session: Session
    static var dependencies = Dependencies()
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
}
