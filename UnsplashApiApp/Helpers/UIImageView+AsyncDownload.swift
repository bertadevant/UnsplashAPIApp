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
        func setPlaceHolder() {
            DispatchQueue.main.async {
                self.image = placeHolder
            }
        }
        func setImage(_ downloadedImage: UIImage) {
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }
        self.image = nil
        let request = LoadAPIRequest(imageURL: imageURL)
        let resource = Resource<Data>(get: request)
        Dependencies.dependencies.session.download(resource) { imageData in
            guard let data = imageData,
                let image = UIImage(data: data) else {
                setPlaceHolder()
                    return
            }
            setImage(image)
        }
        
        
    }
}


