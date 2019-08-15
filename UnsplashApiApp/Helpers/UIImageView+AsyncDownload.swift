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
    func imageFromServerURL(_ url: URL?, placeHolder: UIImage?) {
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
        guard let url = url else {
            setPlaceHolder()
            return
        }
        self.image = nil
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data,
                let downloadedImage = UIImage(data: data) else {
                setPlaceHolder()
                return
            }
            setImage(downloadedImage)
        }).resume()
        
        
    }
}
