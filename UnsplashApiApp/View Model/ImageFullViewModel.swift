//
//  ImageFullViewModel.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 21/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation
import UIKit

class ImageFullViewModel {
    
    let image: ImageViewState
    
    init(image: ImageViewState) {
        self.image = image
    }
    
    func download(imageSavedClosure: @escaping (_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?) -> ()) {
        let downloader = ImageDownloader(imageSavedClosure: imageSavedClosure)
        downloader.download(image)
    }
}
