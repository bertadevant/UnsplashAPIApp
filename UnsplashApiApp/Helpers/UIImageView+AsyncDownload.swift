//
//  UIImageView+AsyncDownload.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit
import Foundation

extension UIImageView {
    func imageFromServerURL(_ imageURL: String, placeHolder: UIImage?) {
        self.image = nil
        let request = LoadAPIRequest(imageURL: imageURL)
        let resource = Resource<Data>(get: request)
        Dependencies.enviroment.session.download(resource) { imageData, _ in
            let image = imageData.map{UIImage.init(data: $0)}
            DispatchQueue.main.async {
                self.image = image ?? placeHolder!
            }
        }
    }
}


