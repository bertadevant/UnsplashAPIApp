//
//  AlertController.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 22/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(error: Error, handler: ((UIAlertAction) -> Void)?) {
        self.init(title: "Error", message: "There was an error \(error.localizedDescription)", preferredStyle: .alert)
        addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
    }
    
    convenience init(message: String, title: String, handler: ((UIAlertAction) -> Void)?) {
        self.init(title: title, message: message, preferredStyle: .alert)
        addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
    }
}
