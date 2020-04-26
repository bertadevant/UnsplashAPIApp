//
//  AlertController.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 22/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import UIKit

struct AlertController {
    private let message: String
    private let title: String
    private let handler: ((UIAlertAction) -> Void)?
    
    lazy var actionAlert: UIAlertController = {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        return alert
    }()
    
    init(error: Error, handler: ((UIAlertAction) -> Void)?) {
        self.message = "There was an error \(error.localizedDescription)"
        self.title = "Error"
        self.handler = handler
    }
    
    init(message: String, title: String, handler: ((UIAlertAction) -> Void)?) {
        self.message = message
        self.title = title
        self.handler = handler
    }
}
