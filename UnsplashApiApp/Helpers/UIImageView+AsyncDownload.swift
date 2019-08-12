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
    func imageFromServerURL(_ url: URL, placeHolder: UIImage?) {
        self.image = nil
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.image = placeHolder
                }
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    self.image = downloadedImage
                } else {
                    self.image = placeHolder
                }
            }
        }).resume()
    }
}
